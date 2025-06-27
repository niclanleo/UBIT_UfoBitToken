#!/bin/bash

CLASS_HASH="0x06e6ae8852d1645f6a0ed84794cdc5d38c9132ae362a178976acd9aeef684988"
ACCOUNT_JSON="/Users/arapachanate./ubit_account.json"
KEYSTORE_JSON="/Users/arapachanate./ubit_keystore.json"
OWNER_ADDRESS="0x01baa727f6cc8ff620b5059fddf11e00082f9e30eecb3744cdc6ef7076bbd5b8"

echo ""
echo "🚀 正在部署 UBIT Token 至主網..."
echo "🔐 擁有者地址: $OWNER_ADDRESS"
echo "📦 使用 Class Hash: $CLASS_HASH"
echo "🌐 網路：mainnet"
echo "--------------------------------------------"

starkli deploy \
  --account "$ACCOUNT_JSON" \
  --keystore "$KEYSTORE_JSON" \
  --network mainnet \
  --watch \
  "$CLASS_HASH" \
  "$OWNER_ADDRESS"

echo "✅ 部署完畢。請前往 StarkScan 或 Voyager 查詢狀態。"