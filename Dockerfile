# 使用 Ubuntu 22.04 作為基礎映像
FROM ubuntu:22.04

# 設定環境變數避免互動式安裝詢問
ENV DEBIAN_FRONTEND=noninteractive

# 安裝基本工具、JDK 17
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    unzip \
    git \
    software-properties-common \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 加入 deadsnakes PPA 並安裝 Python 3.11 (對齊 Chaquopy 版本)
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3.11-distutils \
    && rm -rf /var/lib/apt/lists/*

# 設定預設 Python 為 3.11
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# 設定 JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# 安裝 Android SDK
ENV ANDROID_SDK_ROOT=/opt/android-sdk
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip /tmp/cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# 設定 SDK 相關環境變數
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools

# 接受授權並安裝所需的 SDK 組件 (對齊 build.gradle.kts)
RUN yes | sdkmanager --licenses && \
    sdkmanager "platforms;android-36" \
               "build-tools;36.0.0" \
               "build-tools;35.0.0" \
               "platform-tools" \
               "ndk;25.2.9519653"

# 設定工作目錄
WORKDIR /app

# 預設執行命令
CMD ["./gradlew", "assembleRelease"]
