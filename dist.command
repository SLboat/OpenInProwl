#!/bin/bash
# 打包 OpenInProwl：Release 编译 → 临时签名 → 产物放到 Release/ 目录，并压缩成 zip。
# 用法：双击本文件，或在终端执行 ./dist.command

set -euo pipefail

cd "$(dirname "$0")"

PROJECT="OpenInProwl.xcodeproj"
SCHEME="OpenInProwl"
APP_NAME="OpenInProwl.app"
OUT_DIR="Release"
BUILD_DIR="$(mktemp -d)"

cleanup() { rm -rf "$BUILD_DIR"; }
trap cleanup EXIT

echo "==> 编译 Release"
xcodebuild -project "$PROJECT" -scheme "$SCHEME" -configuration Release \
    -derivedDataPath "$BUILD_DIR" \
    CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY="-" \
    build | grep -E "error:|BUILD" || true

BUILT_APP="$BUILD_DIR/Build/Products/Release/$APP_NAME"
if [ ! -d "$BUILT_APP" ]; then
    echo "编译失败：找不到 $BUILT_APP" >&2
    exit 1
fi

echo "==> 校验签名"
codesign --verify --deep --strict "$BUILT_APP"

VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$BUILT_APP/Contents/Info.plist")"
ZIP_NAME="OpenInProwl-$VERSION.zip"

echo "==> 输出到 $OUT_DIR/"
mkdir -p "$OUT_DIR"
rm -rf "$OUT_DIR/$APP_NAME" "$OUT_DIR/$ZIP_NAME"
ditto "$BUILT_APP" "$OUT_DIR/$APP_NAME"
ditto -c -k --sequesterRsrc --keepParent "$OUT_DIR/$APP_NAME" "$OUT_DIR/$ZIP_NAME"

echo
echo "完成："
echo "  $(pwd)/$OUT_DIR/$APP_NAME"
echo "  $(pwd)/$OUT_DIR/$ZIP_NAME"
echo
echo "安装：把 $APP_NAME 复制到固定位置（如 /Applications/），再按住 ⌘ 拖入 Finder 工具栏。"

# 双击运行时保持窗口，方便查看输出
if [ -t 0 ]; then
    read -n 1 -s -r -p "按任意键关闭..."
    echo
fi
