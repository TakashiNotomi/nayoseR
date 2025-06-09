#' 類似文字列の意味的マッチング（SBERTベース）
#'
#' 2つの文字列ベクトルに対してSBERT（Sentence-BERT）モデルを用いて意味ベクトルを生成し、
#' コサイン類似度に基づいてマッチング候補を抽出します。
#' 上位N件の候補から、しきい値以上のものを結果として返します。
#'
#' @param names_a ベクトルA（例：予算側の事業名など）
#' @param names_b ベクトルB（例：職員側の事務事業名など）
#' @param threshold 類似度のしきい値（0〜1）。これ以上のスコアのみを抽出。デフォルトは0.75。
#' @param top_n 各name_aに対して取得する類似候補の上位件数（デフォルト3件）
#'
#' @return data.frame(name_a, name_b, similarity)。しきい値以上のマッチのみを返す
#' @export
match_names_sbert <- function(names_a, names_b, threshold = 0.75, top_n = 3) {

  # モデル読み込み＆エンコード
  model <- nayoseR::load_sbert_model()
  vec_a <- nayoseR::sbert_encode(model, names_a)
  vec_b <- nayoseR::sbert_encode(model, names_b)

  # コサイン類似度計算
  sklearn <- import("sklearn.metrics.pairwise")
  sim_matrix <- sklearn$cosine_similarity(vec_a, vec_b)

  # マッチ処理
  results <- list()
  for (i in seq_along(names_a)) {
    sim_scores <- sim_matrix[i, ]
    top_matches <- order(sim_scores, decreasing = TRUE)[1:min(top_n, length(sim_scores))]
    for (j in top_matches) {
      if (sim_scores[j] >= threshold) {
        results[[length(results) + 1]] <- data.frame(
          name_a = names_a[i],
          name_b = names_b[j],
          similarity = sim_scores[j]
        )
      }
    }
  }

  do.call(rbind, results)
}
