#' SBERTモデルをロード
#'
#' sentence-transformersの指定モデルを読み込みます。
#'
#' @param model_name 使用するHuggingFaceモデルの名前。デフォルトは多言語MiniLMモデル。
#' @return PythonオブジェクトのSBERTモデル
#' @export
#' @importFrom reticulate import
load_sbert_model <- function(model_name = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2") {
  sentence_transformers <- import("sentence_transformers", delay_load = TRUE)
  model <- sentence_transformers$SentenceTransformer(model_name)
  return(model)
}
