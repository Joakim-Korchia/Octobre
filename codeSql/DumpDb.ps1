$dbName = Read-Host -Prompt "Entrez le nom de la base de données à dumper"
$currentDate = Get-Date -Format "yyyyMMdd"
$fileName = "${currentDate}-${dbName}-dump.sql"
mysqldump -u your_username -p $dbName | Out-File $fileName
Write-Host "Le dump de la base données a été crée dans le fichier $fileName"