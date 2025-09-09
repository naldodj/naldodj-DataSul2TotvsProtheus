param(
    [Parameter(Mandatory=$true)]
    [string]$File,

    [string]$Encoding = "utf-8",

    [switch]$DecodeUtf8AsAscii,

    [switch]$ShowLineHash
)

function Get-StringHash($line) {
    $hash = 0
    $len  = $line.Length
    for ($i = 0; $i -lt $len; $i++) {
        $hash += [int][char]$line[$i] * ($i + 1)  # 1-based index
    }
    return $hash
}

$totalHash = 0
$lineNo = 0

if ($DecodeUtf8AsAscii) {
    # Read all lines as UTF8, then re-decode as ASCII (similar to DecodeUTF8() in Protheus)
    $lines = [System.IO.File]::ReadAllLines($File, [System.Text.Encoding]::UTF8)

    foreach ($line in $lines) {
        $lineNo++
        $ascii = [System.Text.Encoding]::ASCII.GetString([System.Text.Encoding]::UTF8.GetBytes($line))
        $lineHash = Get-StringHash $ascii
        $totalHash += $lineHash

        if ($ShowLineHash) {
            Write-Output ("Line {0}: {1}" -f $lineNo, $lineHash)
        }
    }
}
else {
    # Normal reader with chosen encoding
    $reader = [System.IO.StreamReader]::new($File, [System.Text.Encoding]::GetEncoding($Encoding))
    while (($line = $reader.ReadLine()) -ne $null) {
        $lineNo++
        $lineHash = Get-StringHash $line
        $totalHash += $lineHash

        if ($ShowLineHash) {
            Write-Output ("Line {0}: {1}" -f $lineNo, $lineHash)
        }
    }
    $reader.Close()
}

Write-Output "Total hash of file '$File' (Encoding: $Encoding, DecodeUtf8AsAscii=$DecodeUtf8AsAscii): $totalHash"
