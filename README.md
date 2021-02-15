# PowershellScripts
Powershelling Windows Automation

# 1 - script_session.ps1

Ce script, grâce à ce [gist](https://gist.github.com/pmsmith/de573c82a7a2732347377f06d16dc230) il nettoie le cache, et tout autre donnee de session pour ce navigateurs:
- Edge
- Firefox
- Chrome

Additionellemnt, le script :
- Vide la corbeille
- Nettoie le cache Windows
- Supprime *le contenu du dossier Téléchargements*

# 2 - generateur_tache_session.ps1

Ce script grâce au template de tache logoff_task.xml permet de générer une tâche éxecutant le script_session.ps1
La tâche est éxecutée à la fermeture de session de l'utilisateur ayant éxecuté le script.

Pour importer la tâche il faut lancer le planificateur de tâche en tant qu'administrateur et **importer une tâche...**
Une fois l'import lancé, il faut sélectionner le fichier xml *FermetureSession + nom de l'utilisateur* au chemin indiqué dans *"$taskpath"*.

Pour la bonne execution de la tâche, il faudra le placer au chemin indiqué dans la variable *"$taskpath"* de generateur_tache_session.ps1

Il faudra également accorder le droit d'"ouvrir une session en tant que tâche" via secpol.msc à l'utilisateur concerné.
