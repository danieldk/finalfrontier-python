import contextlib
import os
import pytest
import numpy as np

from finalfusion.io import FinalfusionFormatError
from finalfusion.storage import load_ndarray, load_storage, Storage, NdArray


def test_read_array(tests_root, vocab_array_tuple):
    with pytest.raises(TypeError):
        load_storage(None)
    with pytest.raises(FinalfusionFormatError):
        load_storage(1)
    with pytest.raises(IOError):
        load_storage("foo")
    e = load_storage(tests_root / "data" / "embeddings.fifu")
    matrix = vocab_array_tuple[1]
    matrix = matrix.squeeze() / np.linalg.norm(matrix, axis=1, keepdims=True)
    assert e.shape == (7, 10)
    assert np.allclose(e, matrix)


def test_mmap_array(tests_root, vocab_array_tuple):
    with pytest.raises(TypeError):
        load_storage(None, mmap=True)
    with pytest.raises(FinalfusionFormatError):
        load_storage(1, mmap=True)
    with pytest.raises(IOError):
        load_storage("foo", mmap=True)
    e = load_storage(tests_root / "data" / "embeddings.fifu", mmap=True)
    matrix = vocab_array_tuple[1]
    matrix = matrix.squeeze() / np.linalg.norm(matrix, axis=1, keepdims=True)
    assert e.shape == (7, 10)
    assert np.allclose(e, matrix)


def test_array_roundtrip(tests_root, tmp_path):
    filename = tmp_path / "write_simple.fifu"
    s = load_storage(tests_root / "data" / "embeddings.fifu", mmap=False)
    zero = s[0]
    assert isinstance(zero, np.ndarray)
    assert not isinstance(zero, Storage)
    assert not isinstance(zero, NdArray)
    s.write(filename)
    s2 = load_storage(filename)
    zero2 = s2[0]
    assert np.allclose(zero, zero2)
    assert s.shape == s2.shape
    assert np.allclose(s, s2)


def test_array_roundtrip_mmap(tests_root, tmp_path):
    filename = tmp_path / "write_simple.fifu"
    s = load_storage(tests_root / "data" / "simple_vocab.fifu", mmap=True)
    zero = s[0]
    s.write(filename)
    s2 = load_storage(filename, True)
    zero2 = s2[0]
    assert np.allclose(zero, zero2)
    assert s.shape == s2.shape
    assert np.allclose(s, s2)


def test_from_matrix():
    matrix = np.tile(np.arange(0, 10, dtype=np.float32), (10, 1))
    s = NdArray(matrix)
    assert np.allclose(matrix, s)
    assert s.shape == matrix.shape
    with pytest.raises(AttributeError):
        _ = NdArray(None)
    with pytest.raises(TypeError):
        _ = NdArray(np.arange(0, 10, dtype=np.float32))
    with pytest.raises(TypeError):
        _ = NdArray(np.tile(np.arange(0, 10), (10, 1)))
    with pytest.raises(TypeError):
        _ = NdArray(np.tile(np.arange(0, 10, dtype=np.float), (10, 1)))
    assert np.allclose(matrix, s)


def test_indexing():
    matrix = np.float32(
        np.random.random_sample(sorted(np.random.randint(10, 100, 2))))
    s = NdArray(matrix)
    assert np.allclose(matrix, s)
    for _ in range(1000):
        idx = np.random.randint(-len(s) * 2, len(s) * 2)
        if idx >= len(s) or idx < -len(s):
            ctx = pytest.raises(IndexError)
        else:
            ctx = contextlib.suppress()
        with ctx:
            val = s[idx]
        with ctx:
            assert np.allclose(val, matrix[idx])


def test_iter():
    matrix = np.tile(np.arange(0, 10, dtype=np.float32), (10, 1))
    s = NdArray(matrix)
    for storage_row, matrix_row in zip(s, matrix):
        assert np.allclose(storage_row, matrix_row)


def test_slicing():
    matrix = np.float32(np.random.random_sample((10, 10)))
    s = NdArray(matrix)
    assert np.allclose(matrix[:], s[:])
    assert np.allclose(matrix, s)

    for _ in range(250):
        upper = np.random.randint(-len(matrix) * 3, len(matrix) * 3)
        lower = np.random.randint(-len(matrix) * 3, len(matrix) * 3)
        step = np.random.randint(-len(matrix) * 3, len(matrix) * 3)
        ctx = pytest.raises(ValueError) if step == 0 else contextlib.suppress()

        assert np.allclose(matrix[:upper], s[:upper])
        assert np.allclose(matrix[lower:upper], s[lower:upper])
        with ctx:
            val = s[lower:upper:step]
        with ctx:
            assert np.allclose(matrix[lower:upper:step], val)
        with ctx:
            val = s[:upper:step]
        with ctx:
            assert np.allclose(matrix[:upper:step], val)
        with ctx:
            val = s[::step]
        with ctx:
            assert np.allclose(matrix[::step], val)


def test_slice_slice():
    for _ in range(250):
        matrix = np.float32(np.random.random_sample((100, 10)))
        s = NdArray(matrix)
        assert np.allclose(matrix[:], s[:])
        assert np.allclose(matrix, s)
        for _ in range(5):
            if len(matrix) == 0:
                break
            upper = np.random.randint(-len(matrix) * 2, len(matrix) * 2)
            lower = np.random.randint(-len(matrix) * 2, len(matrix) * 2)
            step = np.random.randint(-len(matrix) * 2, len(matrix) * 2)
            ctx = pytest.raises(
                ValueError) if step == 0 else contextlib.suppress()
            with ctx:
                matrix = matrix[lower:upper:step]
            with ctx:
                s = s[lower:upper:step]
                assert isinstance(s, np.ndarray)
                assert isinstance(s, Storage)
                assert isinstance(s, NdArray)
            assert np.allclose(matrix, s)


def test_write_sliced(tmp_path):
    matrix = np.float32(np.random.random_sample((10, 10)))
    s = NdArray(matrix)
    filename = tmp_path / "write_sliced.fifu"
    for _ in range(250):
        upper = np.random.randint(-len(matrix) * 3, len(matrix) * 3)
        lower = np.random.randint(-len(matrix) * 3, len(matrix) * 3)
        step = np.random.randint(-len(matrix) * 3, len(matrix) * 3)
        mmap = np.random.randint(0, 1)
        if step == 0:
            continue
        s[lower:upper:step].write(filename)
        s2 = load_ndarray(filename, bool(mmap))
        assert np.allclose(matrix[lower:upper:step], s2)


def test_iter_sliced():
    matrix = np.float32(np.random.random_sample((10, 10)))
    s = NdArray(matrix)
    for _ in range(250):
        upper = np.random.randint(-len(matrix) * 3, len(matrix) * 3)
        lower = np.random.randint(-len(matrix) * 3, len(matrix) * 3)
        step = np.random.randint(-len(matrix) * 3, len(matrix) * 3)
        if step == 0:
            continue
        for storage_row, matrix_row in zip(s[lower:upper:step],
                                           matrix[lower:upper:step]):
            assert np.allclose(storage_row, matrix_row)
