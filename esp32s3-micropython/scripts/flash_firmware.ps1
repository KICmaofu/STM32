# ESP32-S3 MicroPython 固件一键烧录脚本
#
# 用法:
#   .\flash_firmware.ps1 -Port COM5            # 烧录标准版固件(大多数板子)
#   .\flash_firmware.ps1 -Port COM5 -Octal     # 烧录 Octal PSRAM 版(N8R8/N16R8 模组)
#
# 参数:
#   -Port   开发板对应的串口号(设备管理器 或 `mpremote devs` 查看)
#   -Octal  板子是 Octal SPIRAM(如 WROOM-1 N16R8)时加上此开关
#   -Baud   烧录波特率, 默认 460800; 烧录失败可降低为 115200

param(
    [Parameter(Mandatory = $true)]
    [string]$Port,

    [switch]$Octal,

    [int]$Baud = 460800
)

$ErrorActionPreference = "Stop"

$firmwareDir = Join-Path (Split-Path $PSScriptRoot -Parent) "firmware"

if ($Octal) {
    $firmware = Join-Path $firmwareDir "ESP32_GENERIC_S3-SPIRAM_OCT-20260824-v1.29.0.bin"
} else {
    $firmware = Join-Path $firmwareDir "ESP32_GENERIC_S3-20260824-v1.29.0.bin"
}

if (-not (Test-Path $firmware)) {
    Write-Host "固件文件不存在: $firmware" -ForegroundColor Red
    exit 1
}

Write-Host "==> 串口: $Port" -ForegroundColor Cyan
Write-Host "==> 固件: $firmware" -ForegroundColor Cyan
Write-Host "==> [1/2] 擦除 Flash ..." -ForegroundColor Yellow
python -m esptool --port $Port --chip esp32s3 erase_flash

Write-Host "==> [2/2] 烧录 MicroPython v1.29.0 ..." -ForegroundColor Yellow
python -m esptool --port $Port --chip esp32s3 --baud $Baud write_flash 0 $firmware

Write-Host ""
Write-Host "==> 烧录完成! 按一下开发板 RST/EN 复位键。" -ForegroundColor Green
Write-Host "==> 进入交互式 REPL:  python -m mpremote connect $Port repl" -ForegroundColor Green
