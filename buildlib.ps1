param (
    [switch]$nobuild
)

$destPath = "$PSScriptRoot"
$libPath = "$destPath/distribution.video"
$zipFileName = "gdist.zip"
$tmpPath = "E:/tmp"
$linuxLibPath = "/home/ccq/dev/opensource/libbaresip-android"

if (!$nobuild) {
echo "wsl -e bash -c '$linuxLibPath/build.sh && $linuxLibPath/cp.sh'"
ssh l82 "wsl -e bash -c `"$linuxLibPath/build.sh && $linuxLibPath/cp.sh`""
}

# 定义 ZIP 文件路径
$zipFilePath = "$tmpPath/$zipFileName"

# 定义解压目标目录
$extractPath = "$destPath"

# 检查 ZIP 文件是否存在
if (-Not (Test-Path $zipFilePath)) {
    Write-Error "ZIP 文件未找到: $zipFilePath"
    exit 1
}

# 检查目标目录是否存在，如果不存在则创建
if (-Not (Test-Path $extractPath)) {
    Write-Output "目标目录不存在，正在创建: $extractPath"
    New-Item -ItemType Directory -Path $extractPath | Out-Null
}

echo $extractPath

# 使用 7z 解压 ZIP 文件
try {
    # 调用 7z 命令行工具
    $7zPath = "7z"  # 如果 7z 在 PATH 中，直接使用 "7z"
    $arguments = "x `"$zipFilePath`" -o`"$extractPath`" -y"  # -y 表示覆盖已存在文件

    # 执行解压命令
    Start-Process -FilePath $7zPath -ArgumentList $arguments -Wait -NoNewWindow

    Write-Output "解压完成: $zipFilePath -> $extractPath"
} catch {
    Write-Error "解压失败: $_"
    exit 1
}
