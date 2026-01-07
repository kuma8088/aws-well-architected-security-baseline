# PF13: Well-Architected Security Baseline Design

> **Created:** 2025-01-07
> **Status:** Approved

## Overview

AWS Well-Architected Framework（6つの柱）に準拠したセキュリティ基盤を構築。
顧客環境のセキュリティレビュー・改善提案能力を証明するポートフォリオ。

### Target Audience

- 情報システム部門
- セキュリティ担当
- コンプライアンス担当

### Key Value

- 「顧客環境のセキュリティレビュー・改善提案ができます」の直接証明
- AWS コンサルタント業務（最適化アドバイス）に直結
- Black Belt レクチャー対応能力のアピール

---

## Requirements Summary

| 項目 | 決定内容 |
|:-----|:---------|
| デモシナリオ | 脅威検出 + コンプライアンス（両方） |
| Security Hub 基準 | FSBP + CIS Benchmark |
| GuardDuty | 基本機能のみ（S3/EKS/Lambda Protection なし） |
| AWS Config | Security Hub 連携（自動有効化） |
| 通知チャンネル | セキュリティ専用（`#alerts-security-*`） |
| デモ違反 | 既存環境の違反を表示（意図的な違反リソース作成なし） |
| 実装フェーズ | 3 フェーズ（検出 → 集約 → 通知） |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        AWS Account                              │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  GuardDuty   │  │  AWS Config  │  │  CloudTrail  │          │
│  │  (脅威検出)   │  │  (構成監査)   │  │  (API監査)    │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                 │                 │                   │
│         └────────────────┼─────────────────┘                   │
│                          ▼                                      │
│              ┌───────────────────────┐                         │
│              │     Security Hub      │                         │
│              │  (統合ダッシュボード)   │                         │
│              │  - FSBP 基準          │                         │
│              │  - CIS Benchmark      │                         │
│              └───────────┬───────────┘                         │
│                          │                                      │
│                          ▼                                      │
│              ┌───────────────────────┐                         │
│              │     EventBridge       │                         │
│              │  (重要度別ルーティング) │                         │
│              └───────────┬───────────┘                         │
│                          │                                      │
│         ┌────────────────┼────────────────┐                    │
│         ▼                ▼                ▼                    │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐               │
│  │ SNS      │     │ SNS      │     │ SNS      │               │
│  │ Critical │     │ High     │     │ Medium   │               │
│  └────┬─────┘     └────┬─────┘     └────┬─────┘               │
│       │                │                │                      │
└───────┼────────────────┼────────────────┼──────────────────────┘
        ▼                ▼                ▼
   ┌─────────┐      ┌─────────┐      ┌─────────┐
   │  Slack  │      │  Slack  │      │  Slack  │
   │#sec-crit│      │#sec-high│      │#sec-warn│
   └─────────┘      └─────────┘      └─────────┘
```

### Design Points

- GuardDuty / Config / CloudTrail → Security Hub に自動集約
- Security Hub の Findings を EventBridge でルーティング
- 重要度（CRITICAL / HIGH / MEDIUM）別に Slack チャンネルへ通知
- Config モジュールは不要（Security Hub が自動有効化）
- IAM Access Analyzer は Security Hub 連携で自動有効化
- Inspector は対象リソース（EC2/ECR）がないため対象外

---

## Terraform Module Structure

```
aws-well-architected-security-baseline/
├── environments/
│   └── dev/
│       ├── main.tf              # モジュール統合
│       ├── provider.tf          # AWS Provider 設定
│       ├── backend.tf           # S3 backend（任意）
│       ├── variables.tf         # 環境変数
│       ├── outputs.tf           # 出力値
│       └── terraform.tfvars     # 設定値（gitignore）
│
├── modules/
│   ├── guardduty/               # Phase 1
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── cloudtrail/              # Phase 1
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── security-hub/            # Phase 2
│   │   ├── main.tf              # Hub + Standards 有効化
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── notification/            # Phase 3
│       ├── main.tf              # EventBridge + SNS
│       ├── chatbot.tf           # Slack 連携
│       ├── variables.tf
│       └── outputs.tf
│
└── docs/
    ├── plans/                   # 設計・実装計画
    └── demo/                    # デモシナリオ手順書
```

---

## Implementation Phases

### Phase 1: 検出サービス有効化

| タスク | 内容 |
|:-------|:-----|
| 1-1 | `modules/guardduty/` 作成 — Detector 有効化 |
| 1-2 | `modules/cloudtrail/` 作成 — 管理イベント記録 + S3 保存 |
| 1-3 | `environments/dev/` で両モジュールを呼び出し |
| 1-4 | `terraform apply` → AWS コンソールで有効化を確認 |

**完了条件:** GuardDuty / CloudTrail が有効、コンソールで確認可能

---

### Phase 2: Security Hub 統合

| タスク | 内容 |
|:-------|:-----|
| 2-1 | `modules/security-hub/` 作成 — Hub 有効化 |
| 2-2 | FSBP + CIS 基準を有効化 |
| 2-3 | Config 自動有効化を確認（Security Hub が自動で行う） |
| 2-4 | `terraform apply` → Security Hub ダッシュボードで Findings 確認 |

**完了条件:** Security Hub にセキュリティスコアと Findings が表示される

---

### Phase 3: Slack 通知連携

| タスク | 内容 |
|:-------|:-----|
| 3-1 | `modules/notification/` 作成 — EventBridge ルール |
| 3-2 | SNS Topics（critical / high / medium）作成 |
| 3-3 | Chatbot 設定（Slack チャンネル連携） |
| 3-4 | テスト通知で動作確認 |

**完了条件:** Security Hub の Findings が Slack に通知される

---

## Cost Estimate

### Per Demo Session (数時間)

| サービス | コスト |
|:---------|:-------|
| Security Hub | < $0.10 |
| GuardDuty | < $0.20 |
| Config | < $0.10 |
| CloudTrail | < $0.05 |
| SNS / EventBridge | ~ $0 |
| **合計** | **< $0.50** |

### Monthly (常時稼働の場合)

| サービス | コスト |
|:---------|:-------|
| Security Hub | $0.25 |
| GuardDuty | $1-5 |
| Config | $4.50 |
| CloudTrail | $0.10 |
| **合計** | **$10-20** |

**Note:** GuardDuty は初回 30 日無料トライアルあり

---

## Demo Scenarios

### Demo 1: Security Hub Dashboard (5min)

```
手順:
1. AWS コンソール → Security Hub を開く
2. 「セキュリティスコア」を確認（おそらく 50-70%）
3. 「Findings」タブで検出された違反を確認
4. フィルタで「Severity: CRITICAL」を絞り込み
5. 具体的な違反内容（例: root MFA 未設定）を説明

説明ポイント:
- 「何もしなくても既存環境の問題が可視化される」
- 「CIS 準拠率 XX% → 改善提案の根拠になる」
```

### Demo 2: GuardDuty Threat Detection (3min)

```
手順:
1. AWS コンソール → GuardDuty を開く
2. 「Findings」タブを確認
3. Sample Findings を生成（GuardDuty の機能）
4. Security Hub に連携されていることを確認

説明ポイント:
- 「リアルタイムで脅威を検出」
- 「Security Hub に自動集約される」
```

### Demo 3: Slack Notification (2min)

```
手順:
1. #alerts-security-critical チャンネルを開く
2. 通知が届いていることを確認
3. 通知内容（Severity, Resource, Description）を説明

説明ポイント:
- 「重要度別にチャンネル分離」
- 「即座に担当者へエスカレーション可能」
```

**合計デモ時間:** 約 10 分

---

## Related Projects

- [PF14: AWS Observability Incident Response](https://github.com/kuma8088/aws-observability-incident-response) - 運用監視・インシデント対応基盤

---

## Changelog

| Date | Change |
|:-----|:-------|
| 2025-01-07 | Initial design created |
