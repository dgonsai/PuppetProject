# PuppetProject
GitHub repository - https://github.com/dgonsai/PuppetProject.git

Steps to replicate:

- With Git installed, right-click on the desktop and 'Git Bash'
- Type "git clone https://github.com/dgonsai/PuppetProject.git" and hit 'enter'
- Directory -> PuppetProject -> puppet -> modules
- Change url's in install.pp files to match the current server (currently 10.50.20.28:8080/aaron)
- Navigate to the new directory (with the vagrantfile) right-click and 'Git Bash'
- Type "vagrant up" and press 'enter'

DockerHub repository - "docker pull tw1l1ghtsp4rkl3/puppettoolset"

(ensure docker is installed first)