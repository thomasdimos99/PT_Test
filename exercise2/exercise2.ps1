param(
    [string]$XmlRoot   = ".\XMLS",          
    [string]$OutputCsv = "pdg_list.csv"   
)

$xmlFiles = Get-ChildItem -Path $XmlRoot -Filter *.xml

$lines = @()

foreach ($file in $xmlFiles) {

    [xml]$xml = Get-Content -Path $file.FullName

    $inputNodes = $xml.SelectNodes("//inputSymbol[normalize-space(text()) = '_pdg_list']")

    if ($inputNodes -and $inputNodes.Count -gt 0) {

        $values = @()

        foreach ($node in $inputNodes) {
            $parent = $node.ParentNode

            $valueNodes = $parent.SelectNodes(".//value")

            foreach ($v in $valueNodes) {
                $val = $v.InnerText.Trim()
                if ($val) { $values += $val }
            }
        }

        $values = $values | Select-Object -Unique

        if ($values.Count -gt 0) {
            $line = $file.FullName + ";" + ($values -join ";")
            $lines += $line
        }
    }
}

$lines | Set-Content -Path $OutputCsv

Write-Host "Έτοιμο. Γράφτηκαν $($lines.Count) γραμμές στο $OutputCsv"