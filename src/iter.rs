use std::cell::RefCell;
use std::rc::Rc;

use finalfusion::prelude::*;
use numpy::{IntoPyArray, PyArray1};
use pyo3::class::iter::PyIterProtocol;
use pyo3::prelude::*;

use crate::EmbeddingsWrap;

#[pyclass(name=EmbeddingIterator)]
pub struct PyEmbeddingIterator {
    embeddings: Rc<RefCell<EmbeddingsWrap>>,
    idx: usize,
}

impl PyEmbeddingIterator {
    pub fn new(embeddings: Rc<RefCell<EmbeddingsWrap>>, idx: usize) -> Self {
        PyEmbeddingIterator { embeddings, idx }
    }
}

#[pyproto]
impl PyIterProtocol for PyEmbeddingIterator {
    fn __iter__(slf: PyRefMut<Self>) -> PyResult<Py<PyEmbeddingIterator>> {
        Ok(slf.into())
    }

    fn __next__(mut slf: PyRefMut<Self>) -> PyResult<Option<PyEmbedding>> {
        let slf = &mut *slf;

        let embeddings = slf.embeddings.borrow();
        let vocab = embeddings.vocab();

        if slf.idx < vocab.len() {
            let word = vocab.words()[slf.idx].to_string();
            let embed = embeddings.storage().embedding(slf.idx);

            slf.idx += 1;

            let gil = pyo3::Python::acquire_gil();
            Ok(Some(PyEmbedding {
                word,
                embedding: embed.into_owned().into_pyarray(gil.python()).to_owned(),
            }))
        } else {
            Ok(None)
        }
    }
}

/// A word and its embedding.
#[pyclass(name=Embedding)]
pub struct PyEmbedding {
    embedding: Py<PyArray1<f32>>,
    word: String,
}

#[pymethods]
impl PyEmbedding {
    /// Get the embedding.
    #[getter]
    pub fn get_embedding(&self) -> Py<PyArray1<f32>> {
        let gil = Python::acquire_gil();
        self.embedding.clone_ref(gil.python())
    }

    /// Get the word.
    #[getter]
    pub fn get_word(&self) -> &str {
        &self.word
    }
}

#[pyclass(name=EmbeddingWithNormIterator)]
pub struct PyEmbeddingWithNormIterator {
    embeddings: Rc<RefCell<EmbeddingsWrap>>,
    idx: usize,
}

impl PyEmbeddingWithNormIterator {
    pub fn new(embeddings: Rc<RefCell<EmbeddingsWrap>>, idx: usize) -> Self {
        PyEmbeddingWithNormIterator { embeddings, idx }
    }
}

#[pyproto]
impl PyIterProtocol for PyEmbeddingWithNormIterator {
    fn __iter__(slf: PyRefMut<Self>) -> PyResult<Py<PyEmbeddingWithNormIterator>> {
        Ok(slf.into())
    }

    fn __next__(mut slf: PyRefMut<Self>) -> PyResult<Option<PyEmbeddingWithNorm>> {
        let slf = &mut *slf;

        let embeddings = slf.embeddings.borrow();
        let vocab = embeddings.vocab();

        if slf.idx < vocab.len() {
            let word = vocab.words()[slf.idx].to_string();
            let embed = embeddings.storage().embedding(slf.idx);
            let norm = embeddings.norms().map(|n| n.0[slf.idx]).unwrap_or(1.);

            slf.idx += 1;

            let gil = pyo3::Python::acquire_gil();
            Ok(Some(PyEmbeddingWithNorm {
                word,
                embedding: embed.into_owned().into_pyarray(gil.python()).to_owned(),
                norm,
            }))
        } else {
            Ok(None)
        }
    }
}

/// A word and its embedding and embedding norm.
#[pyclass(name=EmbeddingWithNorm)]
pub struct PyEmbeddingWithNorm {
    embedding: Py<PyArray1<f32>>,
    norm: f32,
    word: String,
}

#[pymethods]
impl PyEmbeddingWithNorm {
    /// Get the embedding.
    #[getter]
    pub fn get_embedding(&self) -> Py<PyArray1<f32>> {
        let gil = Python::acquire_gil();
        self.embedding.clone_ref(gil.python())
    }

    /// Get the word.
    #[getter]
    pub fn get_word(&self) -> &str {
        &self.word
    }

    /// Get the norm.
    #[getter]
    pub fn get_norm(&self) -> f32 {
        self.norm
    }
}
