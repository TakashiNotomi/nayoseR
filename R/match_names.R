#' @title match_names_sbert
#' @description SBERTで類似度を計算し、条件に合う組を抽出＋CSV出力（任意）
#' @param names_a 比較元のベクトル
#' @param names_b 比較対象のベクトル
#' @param threshold 類似度のしきい値
#' @param top_n 各names_aに対して上位何件まで評価するか
#' @param output_path 出力先ファイルパス（NULLならCSV出力しない）
#' @return 類似ペアのデータフレーム
#' @export
match_names_sbert <- function(names_a, names_b, threshold = 0.75, top_n = 3, output_path = NULL) {
  model <- nayoseR::load_sbert_model()
  vec_a <- nayoseR::sbert_encode(model, names_a)
  vec_b <- nayoseR::sbert_encode(model, names_b)
  sklearn <- reticulate::import("sklearn.metrics.pairwise")
  sim_matrix <- sklearn$cosine_similarity(vec_a, vec_b)

  results <- list()
  for (i in seq_along(names_a)) {
    sim_scores <- sim_matrix[i, ]
    top_matches <- order(sim_scores, decreasing = TRUE)[1:min(top_n, length(sim_scores))]
    for (j in top_matches) {
      if (sim_scores[j] >= threshold) {
        results[[length(results) + 1]] <- data.frame(
          name_a = names_a[i],
          name_b = names_b[j],
          similarity = sim_scores[j],
          stringsAsFactors = FALSE
        )
      }
    }
  }

  out <- do.call(rbind, results)

  if (!is.null(output_path)) {
    utils::write.csv(out, file = output_path, row.names = FALSE)
  }

  return(out)
}
