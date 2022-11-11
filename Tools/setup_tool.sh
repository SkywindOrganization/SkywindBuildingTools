#!/bin/bash

# 根據方法所帶的參數將編譯完成的執行檔移動到對應的目錄結構中，並將對應資訊寫入 info.json
# 第一個需求參數為工具執行檔名稱
# 第二個需求參數為工具名稱字串
# 第三個需求參數為工具實際版本字串
function setupTool() {

    # 實際工具名稱
    TOOL_EXEC_NAME=$1
    echo 工具執行檔名稱：$TOOL_EXEC_NAME

    # 目標工具名稱
    TOOL_NAME=$2
    echo 工具目標名稱：$TOOL_NAME

    # 工具實際版本
    TOOL_VERSION=$3
    echo 工具版本：$TOOL_VERSION

    # 工具二進制目標目錄名稱
    TOOL_DIR_NAME=$TOOL_NAME.artifactbundle
    echo 二進制目標名稱：$TOOL_DIR_NAME

    # 工具在二進制目錄中的路徑
    TOOL_PATH="$TOOL_NAME-$TOOL_VERSION-macos/bin/"
    echo 二進制目錄中的目錄：$TOOL_PATH

    # 工具編譯完成的路徑
    TOOL_BUILD_PATH=".build/apple/Products/Release/$TOOL_EXEC_NAME"
    echo 編譯完成工具執行路徑：$TOOL_BUILD_PATH

    # 工具二進制目錄中的路徑
    TOOL_BUNDLE=Per-Build/$TOOL_DIR_NAME
    mkdir $TOOL_BUNDLE

    # 建立 info.json
    touch $TOOL_BUNDLE/info.json
    cat > $TOOL_BUNDLE/info.json <<- EOM
{
    "schemaVersion": "1.0",
    "artifacts": {
        "$TOOL_NAME": {
            "version": "$TOOL_VERSION",
            "type": "executable",
            "variants": [
                {
                    "path": "$TOOL_NAME-$TOOL_VERSION-macos/bin/$TOOL_NAME",
                    "supportedTriples": ["x86_64-apple-macosx", "arm64-apple-macosx"]
                }
            ]
        }
    }
}
EOM

    # 複製建構完成的執行檔
    TARGET_PATH=$TOOL_BUNDLE/$TOOL_PATH
    mkdir -p $TARGET_PATH
    cp -f $TOOL_BUILD_PATH $TARGET_PATH/$TOOL_NAME
}
