import sys

import numpy as np
import pytest
from finalfusion import load_finalfusion, Embeddings
from finalfusion.io import FinalfusionFormatError
from finalfusion.norms import Norms
from finalfusion.storage import NdArray
from finalfusion.vocab import SimpleVocab
from finalfusion.metadata import Metadata

TEST_NORMS = [
    6.557438373565674, 8.83176040649414, 6.164413928985596, 9.165151596069336,
    7.4833149909973145, 7.211102485656738, 7.4833149909973145
]


def test_read_embeddings(tests_root):
    e0 = load_finalfusion(tests_root / "data" / "simple_vocab.fifu",
                          mmap=False)
    if sys.byteorder != "big":
        e1 = load_finalfusion(tests_root / "data" / "simple_vocab.fifu",
                              mmap=True)
        assert np.allclose(e0.storage, e1.storage)
    with pytest.raises(TypeError):
        load_finalfusion(None)
    with pytest.raises(FinalfusionFormatError):
        load_finalfusion(1)
    with pytest.raises(IOError):
        load_finalfusion("foo")


def test_embeddings_from_vocab_and_storage():
    matrix = np.tile(np.arange(0, 10, dtype=np.float32), (10, 1))
    s = NdArray(matrix)
    v = SimpleVocab([str(i) for i in range(len(s))])
    e = Embeddings(storage=s, vocab=v)
    assert np.allclose(e.storage, matrix)
    assert np.allclose(s, matrix)
    with pytest.raises(AssertionError):
        _ = Embeddings(storage=s, vocab=None)
    with pytest.raises(AssertionError):
        _ = Embeddings(storage=None, vocab=v)
    with pytest.raises(AssertionError):
        _ = Embeddings(storage=s[:-1], vocab=v)
    with pytest.raises(AssertionError):
        matrix = np.tile(np.arange(0, 10, dtype=np.float32), (11, 1))
        _ = Embeddings(storage=NdArray(matrix), vocab=v)


def test_set_metadata(embeddings_fifu, tmp_path):
    m = Metadata({"test": "foo", "test2": 2})
    embeddings_fifu.metadata = m
    assert embeddings_fifu.metadata == m
    path = tmp_path / "meta.fifu"
    embeddings_fifu.write(path)
    e_loaded = load_finalfusion(path)
    assert e_loaded.metadata == embeddings_fifu.metadata
    embeddings_fifu.metadata = None
    assert embeddings_fifu.metadata is None
    with pytest.raises(TypeError):
        embeddings_fifu.metadata = {}
    with pytest.raises(TypeError):
        embeddings_fifu.metadata = "m"
    assert embeddings_fifu.metadata is None


def test_set_norms(embeddings_fifu):
    n = Norms(np.ones(len(embeddings_fifu.vocab), dtype=np.float32))
    embeddings_fifu.norms = n
    assert np.allclose(n, embeddings_fifu.norms)
    embeddings_fifu.norms = None
    assert embeddings_fifu.norms is None
    with pytest.raises(AssertionError):
        embeddings_fifu.norms = "bla"
    with pytest.raises(AssertionError):
        embeddings_fifu.norms = np.ones(len(embeddings_fifu.vocab),
                                        dtype=np.float32)
    with pytest.raises(AssertionError):
        embeddings_fifu.norms = Norms(
            np.ones(len(embeddings_fifu.vocab) - 1, dtype=np.float32))
    with pytest.raises(AssertionError):
        embeddings_fifu.norms = Norms(
            np.ones(len(embeddings_fifu.vocab) + 1, dtype=np.float32))
    assert embeddings_fifu.norms is None


def test_ff_embeddings_roundtrip(embeddings_fifu, vocab_array_tuple, tmp_path):
    filename = tmp_path / "write_embeddings.fifu"
    v = embeddings_fifu.vocab
    s = embeddings_fifu.storage
    embeddings_fifu.write(filename)
    assert v.words == vocab_array_tuple[0]
    matrix = vocab_array_tuple[1]
    matrix = matrix.squeeze() / np.linalg.norm(matrix, axis=1, keepdims=True)
    assert np.allclose(matrix, s)
    e_loaded = load_finalfusion(filename)
    assert np.allclose(s, e_loaded.storage)
    assert e_loaded.vocab == v


def test_embeddings_lookup(embeddings_fifu, vocab_array_tuple):
    matrix = vocab_array_tuple[1]
    matrix = matrix.squeeze() / np.linalg.norm(matrix, axis=1, keepdims=True)
    for i, word in enumerate(vocab_array_tuple[0]):
        assert np.allclose(embeddings_fifu[word], matrix[i])
    lookup = np.zeros_like(matrix)
    for i, word in enumerate(vocab_array_tuple[0]):
        embeddings_fifu.embedding(word, out=lookup[i])
        emb = embeddings_fifu.embedding(word)
        assert np.allclose(emb, lookup[i])
    assert np.allclose(matrix, lookup)
    with pytest.raises(KeyError):
        _ = embeddings_fifu["foo"]
    with pytest.raises(KeyError):
        _ = embeddings_fifu[None]
    with pytest.raises(KeyError):
        _ = embeddings_fifu[1]


def test_unknown_embeddings(embeddings_fifu):
    assert embeddings_fifu.embedding(
        "OOV") is None, "Unknown lookup with no default failed"
    assert embeddings_fifu.embedding(
        "OOV",
        default=None) is None, "Unknown lookup with 'None' default failed"
    assert np.allclose(
        embeddings_fifu.embedding("OOV",
                                  default=np.zeros(10, dtype=np.float32)),
        np.array([0.] * 10)), "Unknown lookup with 'list' default failed"
    out = np.zeros(10, dtype=np.float32)
    default = np.ones(10, dtype=np.float32)
    out2 = embeddings_fifu.embedding("OOV", default=default, out=out)
    assert out is out2
    assert np.allclose(out, default)
    out2 = embeddings_fifu.embedding("OOV", default=0, out=out)
    assert np.allclose(out2, 0)


def test_indexing(embeddings_fifu):
    assert embeddings_fifu["one"] is not None
    with pytest.raises(KeyError):
        _ = embeddings_fifu["Something out of vocabulary"]


def test_embeddings_oov(embeddings_fifu):
    assert embeddings_fifu.embedding("Something out of vocabulary") is None


def test_embeddings_with_norms_oov(embeddings_fifu):
    assert embeddings_fifu.embedding_with_norm(
        "Something out of vocabulary") is None


def test_iter_with_norms(embeddings_fifu):
    for i, (embedding, norm) in enumerate(zip(embeddings_fifu, TEST_NORMS)):
        w = embeddings_fifu.vocab.words[i]
        assert embedding[0] == w
        assert np.isclose(embedding[2], norm), "Norm fails to match!"
        emb_with_norm = embeddings_fifu.embedding_with_norm(w)
        assert emb_with_norm[1] == norm
        out = np.zeros_like(emb_with_norm[0])
        emb_with_out = embeddings_fifu.embedding_with_norm(w, out=out)
        assert np.allclose(emb_with_norm[0], emb_with_out[0])
        assert out is emb_with_out[0]
        assert norm == emb_with_out[1]


def test_no_norms(vocab_array_tuple):
    vocab, matrix = vocab_array_tuple
    embeddings = Embeddings(vocab=SimpleVocab(vocab), storage=NdArray(matrix))
    with pytest.raises(TypeError):
        _ = embeddings.embedding_with_norm("bla")
