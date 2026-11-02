# OpenInProwl

一个放在 Finder 工具栏里的按钮：点一下，就在 Prowl 中打开 Finder 当前所在的目录。

它做的事情只有一件：获取 Finder 前台窗口的路径，然后在该目录下执行 `prowl open .`。

## 最低要求

- **macOS 26 (Tahoe) 或更高版本**：深色图标使用 Icon Composer 的 `.icon` 格式，旧系统只能显示浅色版本。
- **Xcode 26 或更高版本**：用于编译工程。
- **Prowl**：已安装到 `/Applications/Prowl.app`，并且 `prowl` 命令可用。可以在终端执行 `which prowl` 确认，输出应为 `/usr/local/bin/prowl`。

## 编译

```bash
cd OpenInProwl
xcodebuild -project OpenInProwl.xcodeproj -scheme OpenInProwl -configuration Release build
```

或者用 Xcode 打开 `OpenInProwl.xcodeproj`，选择 `OpenInProwl` 方案后按 ⌘B。

编译产物位于 DerivedData 中的 `Build/Products/Release/OpenInProwl.app`。

## 安装

把 `OpenInProwl.app` 复制到一个固定的位置，例如 `/Applications/` 或 `/Applications/S1/`。不要直接从 DerivedData 中拖入工具栏，那个位置会在清理构建目录后消失。

```bash
cp -R "<DerivedData 路径>/Build/Products/Release/OpenInProwl.app" /Applications/
```

## 加入 Finder 工具栏

1. 打开任意 Finder 窗口。
2. 在工具栏空白处右键，选择「自定义工具栏…」。也可以直接在工具栏上按住 **⌘**，拖动以下操作。
3. **按住 ⌘**，把 `OpenInProwl.app` 拖到工具栏上。
4. 松开鼠标，点击「完成」。

**注意：添加时必须按住 ⌘**，否则 Finder 会忽略拖入的项目。

移除时同样按住 ⌘，把按钮从工具栏拖出即可。

## 首次使用

第一次点击按钮时，macOS 会询问是否允许 `OpenInProwl` 控制 Finder。请点「允许」。如果误点了「拒绝」，到 `系统设置 → 隐私与安全性 → 自动化` 中重新打开它对 Finder 的权限。

## 使用

在 Finder 中打开某个目录，点击工具栏上的按钮，该目录就会在 Prowl 中打开。如果没有打开任何 Finder 窗口，则使用桌面目录。

加入工具栏后的效果（左侧为本工具的按钮，右侧为终端按钮）：

<img src="docs/finder-toolbar.png" alt="Finder 工具栏中的 OpenInProwl 按钮" width="360">

## 故障排查

- **拖入没有反应**：确认是否按住了 ⌘；确认 App 位于固定位置，而不是 DerivedData 里。
- **点击后没有打开 Prowl**：在终端执行 `prowl open .`，确认 `prowl` 命令能正常工作。
- **更换图标后工具栏仍显示旧图标**：把按钮移除后重新拖入。

## 致谢

本工具参考了 [OpenInTerminal-Lite](https://github.com/Ji4n1ng/OpenInTerminal)（Copyright (c) 2019 Jianing Wang，MIT 许可）的设计：以 Finder 工具栏按钮的形式快速打开目录，以及 `.icon` 格式的浅色／深色图标组织方式。`AppIcon.icon/icon.json` 沿用了它的配置结构，其余代码为重新编写。
