# 新聞直播

在 Android 系統電視上透過網路觀看新聞直播

## 下載

https://github.com/anenasa/androidtv-news/releases

Android 7 以上系統可下載 androidtv-news-版本.apk，Android 5 和 6 可下載 androidtv-news-api21-版本.apk

## 特色

使用 [yt-dlp](https://github.com/yt-dlp/yt-dlp) 取得影片網址，無須安裝 Youtube 應用程式

使用遙控器轉台

可自訂頻道

## 用法

### 主畫面
1. 轉台：使用上/下鍵或頻道上/下鍵轉台
2. 選擇頻道：輸入數字後按 OK
3. 顯示選單：按 OK，選單中可選擇顯示頻道表、頻道資訊、新增頻道和設定

### 頻道資訊

可顯示頻道的一些資訊，也能修改頻道的名稱、網址、yt-dlp 格式、音量和 header，這裡的設定會覆蓋頻道清單檔案裡的設定。如果要回復到頻道清單檔案的設定，只要把要回復的屬性清空並儲存即可。

## 預設頻道

預設頻道條件：
1. 來源必須合法
2. 台灣能看得到
3. 無須登入

如果有頻道建議歡迎提出。

## 自訂頻道

以 json 格式自訂頻道，可在設定畫面匯入頻道清單或選擇網址，可參考[預設頻道檔案](https://anenasa.github.io/channel/config.txt)。

### 自訂頻道檔案格式

頻道檔案如下（最後一個頻道後面不能加逗點，其他頻道都要）：

    {
      "channelList": [
        頻道1,
        頻道2,
        ...
      ]
    }

頻道格式（最後一個選項後面不能加逗點，其他選項都要）：

    {
      "url": "頻道網址",
      "name": "頻道名稱",
      "ytdl-format": "yt-dlp 格式（可省略）",
      "volume": 音量（可省略）,
      "header": "name: value（可省略）",
      "ytdl-options": JSON 物件（可省略）
    }

頻道也可以是網路上的頻道清單檔案：

    {
      "list": "頻道清單檔案網址"
    }

yt-dlp 格式請參考[這裡](https://github.com/yt-dlp/yt-dlp/blob/master/README.md#format-selection)。預設格式為bv*+ba/b

如果要設定多個 header 可使用 \r\n 分隔（因為反斜線在 json 格式中是特殊字元，所以要用 \\\\r\\\\n 分隔）

ytdl-options 請參考[這裡](https://github.com/yt-dlp/yt-dlp/blob/master/yt_dlp/YoutubeDL.py#L184)。目前只支援字串的選項，如果你想使用的選項不支援歡迎回報。

## Cookies
可在設定畫面匯入，請參考 https://github.com/yt-dlp/yt-dlp/wiki/FAQ#how-do-i-pass-cookies-to-yt-dlp

## 開發與測試

本專案支援在 Linux 環境下使用 Docker 進行自動化編譯，並可配合 Waydroid 進行模擬測試。

### 1. 使用 Docker 編譯 APK
您不需要在本地安裝 Android SDK，只要有 Docker 即可進行編譯。

*   **一般編譯**：
    ```bash
    chmod +x build-in-docker.sh
    ./build-in-docker.sh
    ```
    編譯完成後，APK 會產出在 `app/build/outputs/apk/release/` 目錄中。
*   **清除暫存檔**：
    ```bash
    ./build-in-docker.sh clean
    ```
    *註：本指令會自動掛載 Gradle 快取目錄 (`~/.gradle_docker_cache`)，第二次以後的編譯速度會顯著提升。*

### 2. 使用 Waydroid 進行模擬測試
推薦在 Linux 上使用 Waydroid 模擬 Android TV 環境。

#### 設定電視模式
為了獲得最真實的電視體驗，建議將 Waydroid 切換為電視介面：
```bash
# 設定 UI 為電視模式並調整解析度為 1080p
sudo waydroid prop set persist.waydroid.ui_mode television
sudo waydroid prop set persist.waydroid.width 1920
sudo waydroid prop set persist.waydroid.height 1080
sudo systemctl restart waydroid-container
```

#### 安裝與執行
我們提供了自動化安裝腳本：
1.  確保 Waydroid 視窗已開啟。
2.  執行安裝腳本：
    ```bash
    chmod +x install-to-waydroid.sh
    ./install-to-waydroid.sh
    ```
3.  **操作提示**：
    *   使用鍵盤 **方向鍵**、**Enter** (確認)、**Esc** (返回) 來模擬電視遙控器。
    *   直接啟動 App 指令：`waydroid app launch io.github.anenasa.news`

## 許可證
[GNU General Public License v3.0](https://github.com/anenasa/androidtv-news/blob/main/LICENSE)
