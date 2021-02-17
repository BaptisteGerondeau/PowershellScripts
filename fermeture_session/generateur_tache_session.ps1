	
Add-Type -AssemblyName System.Windows.Forms
# generateur_tache_session.ps1 - Script pour generer la tache de nettoyage de session apres une deconnexion
# ATTENTION : IL EST NECESSAIRE DE DONNER A L'UTILISATEUR LE DROIT
# "D'OUVRIR UNE SESSION EN TANT QUE TACHE" via secpol.msc

# Variables

[System.Windows.MessageBox]::Show('Veuillez-mettre indiquer le chemin vers le script de nettoyage de session','Nettoyage de session',[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)

$FileBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$null = $FileBrowser.ShowDialog()

$scriptpath = $FileBrowser.SelectedPath

[System.Windows.MessageBox]::Show('Veuillez-mettre indiquer le chemin vers le dossier Téléchargements à nettoyer','Nettoyage de session',[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)

$FileBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$null = $FileBrowser.ShowDialog()

$downloadsfolderpath = $FileBrowser.SelectedPath


$taskpath = $env:USERPROFILE + '\Documents'
$taskpath = Resolve-Path -Path "$taskpath"
$title = "FermetureSession" + "$env:USERNAME"
$task_xml = (Get-Content .\logoff_task.xml)

# Templating de la tache
$userid = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$task_xml = $task_xml.replace("#USERID#", $userid )
$task_xml = $task_xml.replace("#TITLE#", $title )
$task_xml = $task_xml.replace("#SCRIPTPATH#", $scriptpath )
$task_xml = $task_xml.replace("#DOWNLOADSFOLDERPATH#", $downloadsfolderpath )

# Ecriture du xml de la tache (a importer dans taskschd.msc ouvert en tant qu'administrateur)
Set-Content -Path $taskpath\$title.xml -Value $task_xml

[System.Windows.MessageBox]::Show("La tâche a été génerée et placée là : $taskpath",'Nettoyage de session',[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)

[System.Windows.MessageBox]::Show("ATTENTION : IL EST NECESSAIRE DE DONNER A L'UTILISATEUR LE DROIT ''D'OUVRIR UNE SESSION EN TANT QUE TACHE'' via secpol.msc",'Nettoyage de session',[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Exclamation)
