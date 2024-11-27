NOTE: These scripts are terrible. If you know minimally about CentOS 9 you can easily solve any problem that it may happen. 

---

wdpInstall.sh quick breakdown:

1- Installs Docker on your VM.

2- Starts Docker

3- Sets username and randomly generate root password and user password (for docker compose only)

4- Creates docker-compose.yml and the .conf file of the blog. (wp-blog.conf)

5- Docker composes up

---

wdpUninstall quick breakdown:

1- Stops nginx, wordpress and db containers

2- Removes nginx, wordpress and db containers

3- Removes blog volumes used by the containers

4- Removes the cloned directory (wdp-docker-directory)

---

This is my first upload to GitHub. I did this as a project for my internship.

---

SE: 
shellscript to run wordpress on docker using nginx on virtual machine centos 9
