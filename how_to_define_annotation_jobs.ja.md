# iKut Annotation - アノテーションタスクの定義方法

# iKut Annotation とは

画像分類モデル開発のための学習データを作成するためのツールです。
ラベル付けを担当するワーカーは複数枚の画像に対してラベルを手動で付与することができます。

# 概要

この文章は、画像分類モデル開発者がアノテーションタスクを定義する方法を解説しています。

# アノテーションタスクの構成

アノテーションタスクは以下のファイルで構成されています。

- YAML ファイル
- 画像ファイル

両方とも HTTPS ホスティングされている必要があります。ワーカーは YAML ファイルの URL を入力することで、アノテーションタスクを始めることができます。

## YAML ファイル

| key | value |
| --- | --- |
| labels | 全種類の画像ラベル配列 |
| images | アノテーション対象画像 |

images フィールドの要素

| key | value |
| --- | --- |
| label | 画像のラベル |
| url | 画像の https スキーマの URL |

### 例

```yaml
labels:
- takoyaki
- sushi
- gyoza
- other
images:
- label: takoyaki
  url: https://ikut-annotation-sample.web.app/image/1002013.jpg
- label: takoyaki
  url: https://ikut-annotation-sample.web.app/image/1002167.jpg
- label: takoyaki
  url: https://ikut-annotation-sample.web.app/image/1002237.jpg
- label: takoyaki
  url: https://ikut-annotation-sample.web.app/image/1003289.jpg
- label: sushi
  url: https://ikut-annotation-sample.web.app/image/100332.jpg
```



