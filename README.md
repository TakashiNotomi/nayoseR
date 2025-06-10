# 📦 nayoseR: 自治体データのための名寄せツール
nayoseR は、表記揺れした組織名や団体名などを高精度で名寄せするためのRパッケージです。
SBERTによる自然言語ベクトル化とShinyによる手動承認UIを組み合わせ、自動×手動のハイブリッド名寄せを実現します。

## 🚀 特徴
- ✅ SBERT による意味的類似度で候補を抽出
- ✅ 手動承認Shinyアプリで最終調整＆辞書構築
- ✅ 辞書再利用機能で一度判定した名寄せは流用可能
- ✅ 地方自治体の「事業名・取組名」など、複雑な表記揺れにも対応

# 🔧 インストール
開発版はGitHubからインストール：

```r
# remotes パッケージが必要
install.packages("remotes")
remotes::install_github("TakashiNotomi/nayoseR")
```
# 📘 使い方の流れ
## 1. SBERTモデルの読み込み
```r
model <- load_sbert_model()
```
## 2. 類似度による名寄せ候補抽出
```r
match_names_sbert(df_a, df_b, column_a = "name1", column_b = "name2", model)
# → match_result.csv を出力
```
## 3. Shinyアプリで手動承認
```r
launch_nayose_app()
# match_result.csv を読み込み、承認・拒否を実施
# 結果は nayose_dict.csv に保存
```
## 4. 名寄せ辞書で本番処理
```r
df_out <- apply_nayose_dictionary(df, column = "name", dict_path = "nayose_dict.csv")
```

# 📁 ファイル構成（出力）
| ファイル名 | 役割 |
| ---- | ---- |
| `match_result.csv` | 類似度による候補一覧 |
| `nayose_dict.csv` | 承認・拒否した辞書データ |

# 🧠 想定ユースケース
- 地方自治体の 「事務事業 × 取組」名寄せ
- サプライヤー名、学校名、団体名などの表記揺れ統一
- 自社DBと外部公開データの突合用マスタ作成

# ⚠️ 注意事項
SBERTの初期ロードにPythonとreticulate環境が必要。
match_result.csv は毎回上書きされるのでバックアップ推奨。
