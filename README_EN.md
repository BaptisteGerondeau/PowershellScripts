# PowershellScripts
Powershelling Windows Automation

# 1 - Cleanup_user.ps1

This script, thanks to [gist](https://gist.github.com/pmsmith/de573c82a7a2732347377f06d16dc230) clears cache, history and empties the cookie jar from :
- Edge
- Firefox
- Chrome

It also empties Windows' cache and the Recycle Bin, as well as wipes out the Download directory.

Additionally, the script :
- Empties the Recycle Bin
- Cleans up Windows' cache
- *Deletes the Downloads folder*

# 2 - generateur_tache_session.ps1

This script generates a task for the Windows Task Scheduler in xml format using the *logoff_task.xml* template.
The task will be assigned to the user session that executed the script.

Import the file "FermetureSession$USER.xml" in the task scheduler which should be at the path indicated in *"$taskpath"*

Place session_script.ps1 at *"$taskpath"*

Il faudra également accorder le droit d'"ouvrir une session en tant que tâche" via secpol.msc à l'utilisateur concerné.
Task user should have "Logon as batch job" right in secpol.msc
