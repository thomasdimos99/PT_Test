param(
    [Parameter(Mandatory = $true)]
    [string]$RootPath,           

    [string]$OutputFile = "missing_actions.txt" 
)

$actionFolders = Get-ChildItem -Path $RootPath -Recurse -Directory |
    Where-Object { $_.Name -match '^Action\d+$' }


$missing = foreach ($folder in $actionFolders) {
    $scriptPath = Join-Path $folder.FullName "Script.mts"

    if (-not (Test-Path $scriptPath)) {
        $folder.FullName   
    }
}


$missing | Set-Content -Path $OutputFile

Write-Host "Found $($missing.Count) Action# files without Script.mts."
Write-Host "$OutputFile"