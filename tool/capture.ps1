param(
    [string]$Device = 'emulator-5554',
    [string]$Adb = "$env:LOCALAPPDATA/Android/sdk/platform-tools/adb.exe"
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $Adb)) {
    throw 'Pass the Android SDK platform-tools adb.exe path using -Adb.'
}

function Invoke-Adb {
    & $Adb -s $Device @args
    if ($LASTEXITCODE -ne 0) {
        throw "adb $args exited with $LASTEXITCODE"
    }
}

$originalSize = Invoke-Adb shell wm size | Select-String 'Override size: (.+)'
$originalDensity = Invoke-Adb shell wm density | Select-String 'Override density: (.+)'
$restoreSize = if ($originalSize) { $originalSize.Matches[0].Groups[1].Value.Trim() } else { 'reset' }
$restoreDensity = if ($originalDensity) { $originalDensity.Matches[0].Groups[1].Value.Trim() } else { 'reset' }

Push-Location (Split-Path -Parent $PSScriptRoot)
try {
    Invoke-Adb shell wm size 860x1864
    Invoke-Adb shell wm density 320
    & flutter drive --debug -d $Device --driver=test_driver/capture_driver.dart --target=integration_test/capture_test.dart
    if ($LASTEXITCODE -ne 0) { throw 'Flutter integration test failed.' }
}
finally {
    try { Invoke-Adb shell wm density $restoreDensity }
    finally {
        try { Invoke-Adb shell wm size $restoreSize }
        finally { Pop-Location }
    }
}

