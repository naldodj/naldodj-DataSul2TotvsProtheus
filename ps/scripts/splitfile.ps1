$upperBound = 10MB
$ext = "csv"
$rootName = "movto_calcul_func"

$reader = new-object System.IO.StreamReader("C:\GitHub\naldodj-DataSul2TotvsProtheus\tables\movto_calcul_func.csv")
$count = 1
$fileName = "{0}{1}.{2}" -f ($rootName, $count, $ext)

# Inicializa o tamanho atual do arquivo
$currentFileSize = 0

while(($line = $reader.ReadLine()) -ne $null)
{
    # Calcula o tamanho do line em bytes
    $lineSize = [System.Text.Encoding]::UTF8.GetByteCount($line)
    
    # Se a adição do line ao arquivo não ultrapassar o limite superior
    if(($currentFileSize + $lineSize) -lt $upperBound)
    {
        Add-Content -path $fileName -value $line
        $currentFileSize += $lineSize
    }
    else
    {
        ++$count
        $fileName = "{0}{1}.{2}" -f ($rootName, $count, $ext)
        Set-Content -path $fileName -value $line  # Cria um novo arquivo com o line
        $currentFileSize = $lineSize
    }
}

$reader.Close()
