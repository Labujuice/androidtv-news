# Android TV 新聞直播專案分析 (Project Analysis)

本專案是一個專為 Android TV 設計的開源應用程式，讓使用者能夠透過網路直接收看台灣的新聞直播頻道。

## 1. 專案功能與用途
*   **用途**：在 Android 電視上收看新聞直播。
*   **核心特色**：
    *   **yt-dlp 整合**：透過 Python 的 `yt-dlp` 函式庫動態取得影片串流網址，使用者不需要安裝 YouTube App。
    *   **電視友善介面**：支援遙控器操作（上下鍵轉台、數字鍵選台）。
    *   **高度自訂化**：使用者可以匯入自己的頻道清單 (JSON 格式)。
    *   **跨版本支援**：支援 Android 5.0 (API 21) 及更高版本。

## 2. 如何編譯 (Build)
本專案使用 Gradle 進行建構，並結合了 Chaquopy 套件來支援 Python 環境。

### 環境需求
*   JDK 17 或以上。
*   Android SDK (支援到 API 36)。
*   Python (用於 Chaquopy 建構過程)。

### 編譯指令
*   **預設編譯 (API 24+)**：
    ```bash
    ./gradlew assembleRelease
    ```
*   **針對舊版本 (API 21+) 編譯**：
    在 `gradle.properties` 中取消註解 `useApi21=true`，或在指令中帶入參數：
    ```bash
    ./gradlew assembleRelease -PuseApi21=true
    ```
    *生成的 APK 會帶有 `api21-` 後綴。*

## 3. 如何測試 (Test)
### 頻道清單測試
專案根目錄下有一個 `channel-test.py` 腳本，可用來驗證頻道 JSON 檔案中的網址是否有效。
*   **用法**：
    ```bash
    python3 channel-test.py [你的頻道清單檔案.json]
    ```
    該腳本會遍歷 JSON 中的所有頻道，並使用 `yt-dlp` 嘗試提取資訊，若失敗則會印出該網址。

### Android 單元測試與儀器測試
*   使用標準 Gradle 指令執行測試：
    ```bash
    ./gradlew test        # 單元測試
    ./gradlew connectedAndroidTest # 裝置連線測試
    ```

## 4. 如何調整頻道 (Adjust Channels)
頻道是透過 JSON 格式進行管理的，可以從應用程式的「設定」畫面匯入本地檔案或指定網址。

### 頻道格式說明
頻道清單的基本結構如下：
```json
{
  "channelList": [
    {
      "url": "影片或頻道網址",
      "name": "頻道顯示名稱",
      "ytdl-format": "yt-dlp 格式 (選填)",
      "volume": 1.0,
      "header": "Custom-Header: value (選填)"
    }
  ]
}
```
*   **自訂頻道來源**：你可以在設定中輸入外部 JSON 的網址，例如：`{"list": "https://example.com/channels.json"}`。
*   **單獨修改**：在 App 內的「頻道資訊」介面，可以針對單一頻道修改名稱、音量或 headers，這些設定會覆蓋清單檔案中的預設值。

## 5. 技術架構簡述
*   **開發語言**：Kotlin (Android 介面) + Python (解析核心)。
*   **播放器**：Media3 ExoPlayer (支援 HLS, RTMP 等)。
*   **Python 整合**：Chaquopy。
*   **網頁抓取**：Jsoup。
*   **錯誤報表**：ACRA。
