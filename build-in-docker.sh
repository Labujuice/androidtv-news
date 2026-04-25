#!/bin/bash

IMAGE_NAME="android-news-builder"

# 1. 檢查 Docker 映像檔是否已存在，不存在才建置
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "Image '$IMAGE_NAME' not found. Building..."
    docker build -t $IMAGE_NAME .
else
    echo "Image '$IMAGE_NAME' already exists. Skipping build. (Use 'docker build' manually to force update)"
fi

# 2. 準備 Gradle 快取目錄 (在宿主機建立，確保持久化)
# 使用獨立的目錄避免與宿主機本身的 .gradle 衝突
GRADLE_CACHE="$HOME/.gradle_docker_cache"
mkdir -p "$GRADLE_CACHE"

# 3. 執行編譯程序
echo "Starting build process in Docker..."
docker run --rm \
    -v "$GRADLE_CACHE":/root/.gradle \
    -v "$(pwd)":/app \
    $IMAGE_NAME

echo "Build finished! Check the 'app/build/outputs/apk/' directory for results."
