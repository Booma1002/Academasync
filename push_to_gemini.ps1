chcp 65001 >$null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

"--- FLUTTER ARCHITECTURE TELEMETRY ---" | Out-File "FlutterContext.txt" -Encoding utf8

"`n--- BUILD CONFIGURATION (pubspec.yaml) ---" | Out-File "FlutterContext.txt" -Append -Encoding utf8
if (Test-Path "pubspec.yaml") {
    Get-Content "pubspec.yaml" | Out-File "FlutterContext.txt" -Append -Encoding utf8
}

"`n--- SOURCE CODE MANIFEST ---" | Out-File "FlutterContext.txt" -Append -Encoding utf8
$TargetFolders = @("lib")

foreach ($folder in $TargetFolders) {
    if (Test-Path $folder) {
        Get-ChildItem -Path $folder -Recurse -Include *.dart | ForEach-Object {
            "`n`nFILE: $($_.FullName)`n-----------------------" | Out-File "FlutterContext.txt" -Append -Encoding utf8
            Get-Content $_.FullName | Out-File "FlutterContext.txt" -Append -Encoding utf8
        }
    }
}

Write-Host "DONE! Your manifest now contains the full Dart Architecture Map." -ForegroundColor Green