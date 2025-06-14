% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load_sbert_model.R
\name{load_sbert_model}
\alias{load_sbert_model}
\title{SBERTモデルをロード}
\usage{
load_sbert_model(
  model_name = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"
)
}
\arguments{
\item{model_name}{使用するHuggingFaceモデルの名前。デフォルトは多言語MiniLMモデル。}
}
\value{
PythonオブジェクトのSBERTモデル
}
\description{
sentence-transformersの指定モデルを読み込みます。
}
