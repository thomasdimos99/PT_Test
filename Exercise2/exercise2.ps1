param(
    [string]$XmlRoot   = ".\XMLS",          
    [string]$OutputCsv = "pdg_list.csv"     
)

$xmlFiles = Get-ChildItem -Path $XmlRoot -Filter *.xml

$lines = @()

foreach ($file in $xmlFiles) {

    [xml]$xml = Get-Content -Path $file.FullName

    $items = $xml.SelectNodes("//Item[inputSymbol = '_pdg_list']")

    if ($items -and $items.Count -gt 0) {

        $values = @()

        foreach ($item in $items) {

            $valueNodes = $item.SelectNodes(".//value")

            foreach ($v in $valueNodes) {
                if ($v.InnerText) {
                    $splitVals = $v.InnerText.Split(",") | ForEach-Object { $_.Trim() }
                    $values += $splitVals
                }
            }
        }

        $values = $values | Where-Object { $_ -ne "" } | Select-Object -Unique

        if ($values.Count -gt 0) {
            $line = $file.FullName + ";" + ($values -join ";")
            $lines += $line
        }
    }
}

$lines | Set-Content -Path $OutputCsv

Write-Host "$($lines.Count) lines to $OutputCsv"