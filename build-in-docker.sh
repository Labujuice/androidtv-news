#!/bin/bash

# 定義顏色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # 無顏色

IMAGE_NAME="android-news-builder"
GRADLE_TASK="assembleRelease"

# 檢查參數
if [ "$1" == "clean" ]; then
    echo -e "${YELLOW}[!] Clean mode activated.${NC}"
    GRADLE_TASK="clean"
fi

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}   Android TV News - Docker Builder    ${NC}"
echo -e "${BLUE}=======================================${NC}"

# 1. 檢查 Docker 映像檔
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo -e "${YELLOW}[!] Image '$IMAGE_NAME' not found. Building...${NC}"
    docker build -t $IMAGE_NAME .
else
    echo -e "${GREEN}[✓] Image '$IMAGE_NAME' already exists.${NC}"
fi

# 2. 準備 Gradle 快取目錄
GRADLE_CACHE="$HOME/.gradle_docker_cache"
mkdir -p "$GRADLE_CACHE"

# 3. 執行編譯程序 (根據參數決定 task)
echo -e "${BLUE}[*] Running Gradle task: $GRADLE_TASK in Docker...${NC}"
docker run --rm \
    -v "$GRADLE_CACHE":/root/.gradle \
    -v "$(pwd)":/app \
    $IMAGE_NAME ./gradlew $GRADLE_TASK

# 4. 結束處理
if [ "$GRADLE_TASK" == "assembleRelease" ]; then
    echo -e "${BLUE}=======================================${NC}"
    echo -e "${GREEN}[✓] Build finished!${NC}"
    
    # 搜尋並列出 APK
    echo -e "${BLUE}[*] Generated APK files:${NC}"
    APK_FILES=$(find app/build/outputs/apk/ -name "*.apk" 2>/dev/null)
    if [ -z "$APK_FILES" ]; then
        echo -e "${RED}    No APK files found.${NC}"
    else
        while read -r line; do
            echo -e "${GREEN}    - $line${NC}"
        done <<< "$APK_FILES"
    fi
elif [ "$GRADLE_TASK" == "clean" ]; then
    echo -e "${GREEN}[✓] Clean finished!${NC}"
fi
echo -e "${BLUE}=======================================${NC}"
