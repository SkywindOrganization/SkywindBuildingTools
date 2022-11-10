#!/bin/bash
# 將需要預先編譯的可執行檔與版本在本腳本進行定義

# 建構工具二進制目錄的方法定義
source $(dirname "$0")/setup_tool.sh

echo 預先處理 Per-Build 資料夾
mkdir Per-Build

# 複製工具到特定結構內
setupTool "formater" "0.50.3"
setupTool "linter" "0.50.0-rc.4"
