#!/bin/bash
# 尋找最新編譯的 APK
APK_PATH=$(find app/build/outputs/apk/release/ -name "*.apk" | head -n 1)

if [ -z "$APK_PATH" ]; then
    echo "錯誤：找不到 APK 檔案，請先執行 ./build-in-docker.sh"
    exit 1
fi

echo "正在安裝 $APK_PATH 到 Waydroid..."
waydroid app install "$APK_PATH"

if [ $? -eq 0 ]; then
    echo "安裝成功！您可以在 Waydroid 的應用程式選單中找到『新聞直播』。"
    echo "或者執行以下指令直接啟動："
    echo "waydroid app launch io.github.anenasa.news"
else
    echo "安裝失敗，請確保 Waydroid 正在執行中。"
fi
