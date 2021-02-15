# generateur_tache_session.ps1 - Script pour generer la tache de nettoyage de session apres une deconnexion
# ATTENTION : IL EST NECESSAIRE DE DONNER A L'UTILISATEUR LE DROIT
# "D'OUVRIR UNE SESSION EN TANT QUE TACHE" via secpol.msc

# Variables
$taskpath = $env:USERPROFILE + '\Documents'
$taskpath = Resolve-Path -Path "$taskpath"
$title = "FermetureSession" + "$env:USERNAME"
$task_xml = (Get-Content .\logoff_task.xml)

# Templating de la tache
$userid = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$task_xml = $task_xml.replace("#USERID#", $userid )
$task_xml = $task_xml.replace("#TITLE#", $title )
$task_xml = $task_xml.replace("#TASKPATH#", $taskpath )

# Ecriture du xml de la tache (a importer dans taskschd.msc ouvert en tant qu'administrateur)
Set-Content -Path $taskpath\$title.xml -Value $task_xml
