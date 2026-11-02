import Foundation

/// 运行一个命令，返回标准输出（去掉首尾空白）。
func run(_ executable: String, _ arguments: [String], in directory: String? = nil) -> String {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: executable)
    process.arguments = arguments
    if let directory = directory {
        process.currentDirectoryURL = URL(fileURLWithPath: directory)
    }
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = Pipe()
    do {
        try process.run()
    } catch {
        return ""
    }
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    process.waitUntilExit()
    return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

// 1. 获取 Finder 当前窗口的目录；没有窗口时使用桌面
let finderScript = """
tell application "Finder"
    if (count of Finder windows) > 0 then
        return POSIX path of (target of front Finder window as alias)
    else
        return POSIX path of (desktop as alias)
    end if
end tell
"""
var directory = run("/usr/bin/osascript", ["-e", finderScript])
if directory.isEmpty {
    directory = FileManager.default.homeDirectoryForCurrentUser.path
}

// 2. 在该目录下执行 prowl open .
_ = run("/bin/zsh", ["-l", "-c", "prowl open ."], in: directory)
