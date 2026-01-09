# デモシナリオ

> **所要時間:** 約 10 分
> **前提:** terraform apply 済み

---

## Demo 1: Security Hub ダッシュボード確認（5分）

### 手順

1. **AWS Console にログイン**
   - https://ap-northeast-1.console.aws.amazon.com/securityhub/

2. **セキュリティスコアを確認**
   - トップページでセキュリティスコアを確認（初回は 50-70% 程度）

3. **Security standards を確認**
   - 左メニュー「Security standards」をクリック
   - 「AWS Foundational Security Best Practices」の準拠率を確認
   - 「CIS AWS Foundations Benchmark」の準拠率を確認

4. **Findings を確認**
   - 左メニュー「Findings」をクリック
   - フィルタ追加: `Severity label = CRITICAL`
   - 具体的な違反内容を確認

### 説明ポイント

```
「既存環境をスキャンするだけで、これだけのセキュリティ課題が可視化されます」
「CIS 準拠率 XX% → 改善提案の根拠として使えます」
「各 Finding には修正手順（Remediation）も表示されます」
```

---

## Demo 2: GuardDuty 脅威検出 + Sample Findings（3分）

### 手順

1. **GuardDuty Console を開く**
   - https://ap-northeast-1.console.aws.amazon.com/guardduty/

2. **Sample Findings を生成**
   - 左メニュー「Settings」をクリック
   - 「Sample findings」セクションで「Generate sample findings」をクリック
   - ※ これにより各種脅威タイプのサンプルが生成される

3. **Findings を確認**
   - 左メニュー「Findings」をクリック
   - Severity でソート（High/Critical が上に来る）
   - 任意の Finding をクリックして詳細を確認

4. **Security Hub 連携を確認**
   - Security Hub の Findings に GuardDuty の検出が表示されていることを確認
   - フィルタ: `Product name = GuardDuty`

### 説明ポイント

```
「GuardDuty はリアルタイムで脅威を検出します」
「不正アクセス、マルウェア、異常な API 呼び出しなどを自動検知」
「検出結果は Security Hub に自動集約されます」
```

---

## Demo 3: Slack 通知確認（2分）

### 手順

1. **Slack チャンネルを開く**
   - `#alerts-security-critical` を確認
   - Sample Findings の HIGH/CRITICAL が通知されているはず

2. **通知内容を確認**
   - Severity（重要度）
   - Finding Title（検出内容）
   - Resource（対象リソース）
   - Region / Account

3. **（オプション）EventBridge でテストイベントを送信**
   ```bash
   # AWS CLI でテストイベントを送信
   aws events put-events --entries '[
     {
       "Source": "demo.test",
       "DetailType": "Security Hub Findings - Imported",
       "Detail": "{\"findings\":[{\"Title\":\"Test Finding\",\"Severity\":{\"Label\":\"CRITICAL\"},\"Workflow\":{\"Status\":\"NEW\"},\"Resources\":[{\"Id\":\"test-resource\"}],\"AwsAccountId\":\"552927148143\",\"Region\":\"ap-northeast-1\",\"Description\":\"This is a test finding\"}]}"
     }
   ]'
   ```

### 説明ポイント

```
「重要度別に Slack チャンネルを分離しています」
「CRITICAL は即座に担当者へエスカレーション可能」
「対応履歴は Slack スレッドで追跡できます」
```

---

## Demo 4: CloudTrail 監査ログ確認（オプション・2分）

### 手順

1. **CloudTrail Console を開く**
   - https://ap-northeast-1.console.aws.amazon.com/cloudtrail/

2. **Trail を確認**
   - 「Trails」をクリック
   - `security-baseline-dev-trail` が有効になっていることを確認

3. **Event history を確認**
   - 「Event history」をクリック
   - 最近の API 呼び出しが記録されていることを確認

4. **S3 バケットを確認**
   - S3 Console で `security-baseline-dev-cloudtrail-logs-*` を開く
   - ログファイルが保存されていることを確認

### 説明ポイント

```
「すべての API 呼び出しが記録されています」
「誰が、いつ、何をしたか追跡可能」
「ログは 90 日間保持され、自動で削除されます」
```

---

## クリーンアップ

デモ終了後は以下を実行:

```bash
cd /Users/naoya/srv/workspace/dev/aws-well-architected-security-baseline/environments/dev
terraform destroy -auto-approve
```

### 削除されるリソース

- GuardDuty Detector
- CloudTrail + S3 Bucket
- Security Hub + Standards
- SNS Topics
- EventBridge Rules
- Chatbot Configurations

---

## トラブルシューティング

### Slack 通知が届かない

1. **Chatbot の認証を確認**
   - AWS Console → AWS Chatbot → 「Configured clients」
   - Slack workspace が連携されているか確認

2. **SNS Topic Policy を確認**
   - EventBridge からの Publish が許可されているか

3. **EventBridge ルールを確認**
   - Console で「Rules」を確認
   - 「Monitoring」タブでイベントがマッチしているか

### Security Hub の Findings が表示されない

1. **Standards が有効か確認**
   - Security Hub → Security standards
   - FSBP / CIS が「Enabled」になっているか

2. **初回スキャン完了を待つ**
   - 有効化後、最初のスキャン完了まで 15-30 分かかる場合あり

### GuardDuty の Findings が Security Hub に連携されない

1. **Product subscription を確認**
   - Security Hub → Integrations → GuardDuty が「Accepting findings」になっているか
