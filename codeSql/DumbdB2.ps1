$dumpFilePath = Read-Host -Prompt "Entrez le chemin complet du fichier de dump SQL" 
if (Test-Path $dumpFilePath) {
    $dbName = Read-Host -Prompt "Entrez le nom de la base de données où monter le dump"
    $dbUser = Read-Host -Prompt "Entrez votre nom d'utilisateur MySQL" 
    $dbPassword = Read-Host -Prompt "Entrez votre mot de passe MySQL" -AsSecureString 
    $dbPasswordBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassword) 
    $dbPasswordUnsecure = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($dbPasswordBSTR)
    mysql -u $dbUser -p $dbPasswordUnsecure $dbName < $dumpFilePath 
    Write-Host "Le dump a été monté sur la base de données $dbName avec succès." 
} else { 
    Write-Host "Le fichier de dump spécifié n'existe pas." 
}
