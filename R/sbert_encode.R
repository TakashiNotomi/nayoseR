#' ベクトルをSBERTでエンコード
#'
#' @param model SBERTモデルオブジェクト
#' @param string_vector ベクトル形式の文字列群
#' @return エンコードされたベクトル群
#' @export
sbert_encode <- function(model, string_vector) {
  vec <- model$encode(string_vector, normalize_embeddings = TRUE)
  return(vec)
}
