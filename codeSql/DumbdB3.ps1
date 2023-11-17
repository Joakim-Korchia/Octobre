$mysqlServer = "localhost"
$mysqlDatabase = "prestation2"
$mysqlUser = "root"
$mysqlPassword = ""

# Obtenez la date du jour au format "yyyyMMdd"
$dateStamp = Get-Date -Format "yyyyMMdd"

# Définir le chemin de sauvegarde avec le nom du dossier
$backupParentPath = "C:\Users\stagiaire-05\Documents\dumps"
$backupFolderPath = Join-Path $backupParentPath "Backup_$dateStamp"

# Créer le dossier s'il n'existe pas
if (-not (Test-Path -Path $backupFolderPath -PathType Container)) {
    New-Item -Path $backupFolderPath -ItemType Directory | Out-Null
}

# Définir le nom de fichier de sauvegarde avec le timestamp
$timestamp = Get-Date -Format "HH_mm"
$backupFileName = "prestation2_$timestamp.sql"
$backupFilePath = Join-Path $backupFolderPath $backupFileName

# Construire la commande mysqldump
$mysqldumpCommand = "mysqldump.exe"
$mysqldumpArgs = "--host=$mysqlServer --user=$mysqlUser --password=$mysqlPassword --databases $mysqlDatabase --result-file=$backupFilePath"

# Exécuter la commande mysqldump
Start-Process -FilePath $mysqldumpCommand -ArgumentList $mysqldumpArgs -Wait -NoNewWindow

# Afficher un message indiquant que la sauvegarde est terminée
Write-Host "La sauvegarde de la base de données $mysqlDatabase a été créée : $backupFilePath"