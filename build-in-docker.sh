#!/bin/bash

# 1. 建立 Docker 映像
echo "Building Docker image 'android-news-builder'..."
docker build -t android-news-builder .

# 2. 執行編譯程序
# 將目前的專案目錄掛載到容器內的 /app
echo "Starting build process in Docker..."
docker run --rm -v "$(pwd)":/app android-news-builder

echo "Build finished! Check the 'app/build/outputs/apk/' directory for results."
