# Common procedures

Manual for installing common tools, which are used to setup other software building blocks in the project.
This manual is applicable for Linux, specifically CentOS-7 machine.

## Set up web proxy on a Linux machine (in current session)

```
export http_proxy=http://web-proxy:8080
export https_proxy=http://web-proxy:8080
```

## Install Ansible

> Note: this step is needed on the Management Machine. The Management Machine is the machine, which shell we use to invoke Ansible commands.

```
root@machine:~# yum install epel-release -y
root@machine:~# yum update
root@machine:~# yum install ansible -y
```

Then you can check if it's OK

```
ansible --version
```

## Run the ansible script

Log on the management machine.

Download the recipe file (*.yaml) and transfer it to the management machine.

View the recipe file. The recipe is usually applicable for one server group. Find the name of the server group (below its "jenkinses").

```
- name: Setup automatition
  hosts: jenkinses
  tasks:
  (...)
```

Edit the `/etc/ansible/hosts` file. Create the section with the group if it does not exist. Specify correct server list in the group.

```
[jenkinses]
machine1
machine2
```

Optionally fix/check the connectivity via `SSH` to the servers in the group from the management machine.

Run the following command to execute the recipe.

```
ansible-playbook -b -K -u [USERNAME] RECIPE-NAME.yaml
```

- `-b` become root on the target machine
- `-K` ask for the sudo password
- `-u [USERNAME]` select the user login to use when contacting the target server (optional if the logins are the same). `USERNAME` is the system user on the servers from the list
- `RECIPE-NAME.yaml` is the name of the file with the recipe

> add ` -k` option if you are using ssh password authentication instead of ssh keys (`ansible-playbook -b -K -k -u [USERNAME] RECIPE-NAME.yaml`)

Other useful command-line parameters:

- `-i hosts` use specified hosts file instead of `/etc/ansible/hosts`


## IaC cloud machine common setup

Download the [IaC common setup automation](iac-common.yaml) recipe with [parameter file](group_vars/all).

Edit the parameter file (`group_vars/all`). Adjust the variables content if needed.

```
#proxy file location
proxy_file_location: /etc/environment

#proxy server lines - each can be commented out
http_proxy: "http://web-proxy:8080"
https_proxy: "http://web-proxy:8080"
no_proxy: "localhost,127.0.0.1"
```

Run the recipe. Running the recipe is described [here](#run-the-ansible-script).

This performs the following steps:

- Setting up the http and https proxy in environment file on the machine.
- Updating packages and refreshing the yum cache.


## Setup docker

First perform the [IaC cloud machine common setup](#iac-cloud-machine-common-setup) procedure if necessary.

Download the [Docker setup recipe](docker-setup.yaml) with [parameter file](group_vars/all).

Edit the parameter file (`group_vars/all`). Adjust the variables content if needed.

```
#proxy server lines - each can be commented out
http_proxy: "http://web-proxy:8080"
https_proxy: "http://web-proxy:8080"
no_proxy: "localhost,127.0.0.1"
```

(`proxy_file_location` is not used in this recipe)

Run the recipe. Running the recipe is described [here](#run-the-ansible-script).

This performs the following steps:

- Setting up the http and https proxy in for docker.
- Installing docker using yum.


