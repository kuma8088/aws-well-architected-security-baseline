# ポートフォリオ拡張オプション

> 作成日: 2025-01-10
> ステータス: 検討中

---

## 背景

現在のポートフォリオは AWS リソースのみを監視対象としている。
ポートフォリオ環境単体では実際の脅威検出やコンプライアンス違反がほとんど発生しないため、
実運用環境との連携により、より実践的なデモが可能になる。

---

## Option A: AWS 環境を充実させる

### 概要

EdgeShift や他のサービスの一部機能を AWS に移行し、監視対象を増やす。

### 実装例

- EdgeShift の API を API Gateway + Lambda で実装
- Cloudflare Workers から AWS Lambda への一部移行
- RDS/DynamoDB を使ったデータ層の追加

### メリット

- 追加の統合作業が不要
- AWS ネイティブのセキュリティ機能をフル活用
- 実際のトラフィックがあれば Findings も発生

### デメリット

- 既存アーキテクチャの変更が必要
- Cloudflare のエッジ性能を失う

### 工数

中〜大

---

## Option B: Cloudflare セキュリティイベント統合

### 概要

Cloudflare の WAF/Security Events を AWS Security Hub に統合する。

### アーキテクチャ

```
Cloudflare WAF Events
       ↓
  Logpush (S3)
       ↓
  Lambda (変換)
       ↓
  Security Hub (BatchImportFindings API)
       ↓
  EventBridge → SNS → Slack
```

### 実装ステップ

1. Cloudflare Logpush を設定（WAF events → S3）
2. S3 トリガーの Lambda を作成
3. Cloudflare イベント → ASFF (AWS Security Finding Format) 変換
4. Security Hub にインポート

### メリット

- マルチクラウド統合の実績になる
- EdgeShift の実トラフィックを監視
- 面白いポートフォリオ事例

### デメリット

- Cloudflare Enterprise または Pro が必要（Logpush）
- 変換ロジックの実装が必要

### 工数

中

### 参考

- [Cloudflare Logpush](https://developers.cloudflare.com/logs/about/)
- [Security Hub BatchImportFindings](https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-findings-batchimport.html)

---

## Option C: マルチクラウド監視ダッシュボード

### 概要

Grafana または Datadog を使って、AWS + Cloudflare + Dell Services を統合監視する。
Security Hub とは別のアプローチ。

### アーキテクチャ

```
AWS CloudWatch ─────┐
                    │
Cloudflare Analytics ───→ Grafana/Datadog ───→ Slack
                    │
Dell (Prometheus) ──┘
```

### 実装ステップ

1. Grafana Cloud または Datadog アカウント設定
2. 各環境のデータソース接続
   - AWS: CloudWatch Integration
   - Cloudflare: API Integration
   - Dell: Prometheus Exporter
3. ダッシュボード作成
4. アラートルール設定

### メリット

- 真のマルチクラウド/ハイブリッド監視
- 柔軟なダッシュボード
- コスト可視化も可能

### デメリット

- このポートフォリオの範囲外（別プロジェクト向き）
- 追加の SaaS コスト

### 工数

大

---

## Option D: 現状維持（採用）

### 概要

このポートフォリオは「AWS セキュリティガバナンス基盤」として完結させる。

### 理由

- スコープを明確に保つ
- 実装・ドキュメントが完了している
- 必要に応じて後から拡張可能

### 今後の方針

- 実運用で使う場合は Option B の Cloudflare 統合を検討
- マルチクラウド監視が必要なら Option C を別ポートフォリオとして実装

---

## 推奨順序

1. **今回**: Option D で完了
2. **短期**: Option B（Cloudflare 統合）を追加実装
3. **中期**: Option C を別ポートフォリオとして検討

---

## 関連ドキュメント

- [デモシナリオ](../demo/demo-scenario.md)
- [設計ドキュメント](./2025-01-07-security-baseline-design.md)
