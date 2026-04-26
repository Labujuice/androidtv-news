#!/bin/bash

# 定義顏色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

MODE="auto"
APK_PATH=""

# 參數解析
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --debug)
            MODE="debug"
            shift
            ;;
        --release)
            MODE="release"
            shift
            ;;
        *)
            echo -e "${RED}[!] 未知參數: $1${NC}"
            echo "用法: $0 [--debug | --release]"
            exit 1
            ;;
    esac
done

# 搜尋 APK
if [ "$MODE" == "debug" ]; then
    APK_PATH=$(find app/build/outputs/apk/debug/ -name "*.apk" | head -n 1)
elif [ "$MODE" == "release" ]; then
    APK_PATH=$(find app/build/outputs/apk/release/ -name "*.apk" | head -n 1)
else
    # Auto 模式：優先找 debug
    APK_PATH=$(find app/build/outputs/apk/debug/ -name "*.apk" | head -n 1)
    if [ -z "$APK_PATH" ]; then
        APK_PATH=$(find app/build/outputs/apk/release/ -name "*.apk" | head -n 1)
    fi
fi

if [ -z "$APK_PATH" ]; then
    echo -e "${RED}[!] 錯誤：找不到符合條件的 APK 檔案。${NC}"
    echo "請先執行 ./build-in-docker.sh [--debug | --release]"
    exit 1
fi

echo -e "${YELLOW}[*] 正在安裝 $APK_PATH 到 Waydroid...${NC}"
waydroid app install "$APK_PATH"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[✓] 安裝成功！${NC}"
    echo "您可以在 Waydroid 的應用程式選單中找到『新聞直播』。"
    echo "或直接啟動: waydroid app launch io.github.anenasa.news"
else
    echo -e "${RED}[!] 安裝失敗，請確保 Waydroid 正在執行中且已正確設定。${NC}"
fi
