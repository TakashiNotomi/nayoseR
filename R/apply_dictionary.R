#' 名寄せ辞書を用いて自動的に対応付けを適用
#'
#' 過去に手動承認された名寄せ辞書（CSV）を利用して、新たな文字列ベクトルに対し
#' 自動で名寄せ結果を付与します。`match_names_sbert()` の結果を元に `launch_nayose_app()`
#' で承認されたペアを元に、自動で name_b（統一済み名称）を補完します。
#'
#' @param new_names 対象となる文字列ベクトル（事業名など）
#' @param dictionary_path 名寄せ辞書のCSVファイルパス（デフォルトは \"meiyose_dict.csv\"）
#'
#' @return data.frame(name_a, name_b)。name_bがNAなら辞書に該当なし
#' @export
apply_nayose_dictionary <- function(new_names, dictionary_path = "meiyose_dict.csv") {
  if (!file.exists(dictionary_path)) return(data.frame(name_a = new_names, name_b = NA))
  dict <- read.csv(dictionary_path, stringsAsFactors = FALSE)
  dict <- subset(dict, with(dict, status == "approved"))
  match_df <- data.frame(name_a = new_names)
  match_df <- merge(match_df, dict[, c("name_a", "name_b")], by = "name_a", all.x = TRUE)
  return(match_df)
}
