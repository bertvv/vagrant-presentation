% Vagrant tutorial
% Bert Van Vreckem
% 2015-09-07

## Whoami

*Bert Van Vreckem*

* Lecturer ICT at University College Ghent and CVO Panta Rhei
    * Mainly Linux & open source
    * Coordinator Bachelor thesises
* [\@bertvanvreckem](https://twitter.com/bertvanvreckem/)
* <http://be.linkedin.com/in/bertvanvreckem/>
* <http://youtube.com/user/bertvvhogent/>
* <http://hogentsysadmin.wordpress.com/>

## Have a question/remark? Please interrupt me!

## Agenda

* Vagrant introduction
* Getting base boxes
* Configuring boxes
* Provisioning
    * Shell, Ansible
    * setting up a LAMP stack
* Creating base boxes

# Introduction

## What is Vagrant?

<http://www.vagrantup.com/>

* Written by [Mitchell Hashimoto](https://twitter.com/mitchellh)
* Command line tool
* Automates VM creation with
    * VirtualBox
    * VMWare
    * Hyper-V
* Integrates well with configuration management tools
    * Shell
    * Ansible
    * Chef
    * Puppet
* Runs on Linux, Windows, MacOS

## Why use Vagrant?

> * Create new VMs quickly and easily
>     * Only one command! `vagrant up`
> * Keep the number of VMs under control
> * Reproducability
> * Identical environment in development and production
> * Portability
>     * No more 4GB .ova files
>     * `git clone` and `vagrant up`

## Assumptions

* Git
* Vagrant 1.7.4
* VirtualBox 4.3 or newer
    * default Host-only network (192.168.56.0/24)

```console
$ vagrant --version
Vagrant 1.7.4
$ VBoxHeadless --version
Oracle VM VirtualBox Headless Interface 4.3.30
(C) 2008-2015 Oracle Corporation
All rights reserved.

4.3.30_RPMFusionr10610
$ ifconfig vboxnet0
=> 192.168.56.1
```

## Try it yourself

* Clone the repository
  `git clone git@github.com:bertvv/vagrant-example.git`
* To get the code at certain points in the presentation, do:
  `git checkout tags/checkpoint-nn`

(sorry, the code is no longer up-to-date)

# Getting up and running

## Minimal default setup:

```bash
$ vagrant init centos/7
$ vagrant up
$ vagrant ssh
```

## What happens under the hood?


```bash
$ vagrant init centos/7
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.

```

A *Vagrantfile* is created (that's all!)

## What happens under the hood?

```bash
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'centos/7' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'centos/7'
    default: URL: https://atlas.hashicorp.com/centos/7
==> default: Adding box 'centos/7' (v1505.01) for provider: virtualbox
    default: Downloading: https://atlas.hashicorp.com/centos/boxes/7/versions/1505.01/providers/virtualbox.box
==> default: Box download is resuming from prior download progress
==> default: Successfully added box 'centos/7' (v1505.01) for 'virtualbox'!
==> default: Importing base box 'centos/7'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'centos/7' is up to date...
==> default: Setting the name of the VM: test_default_1441636487571_53914
==> default: Fixed port collision for 22 => 2222. Now on port 2200.
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
```

-------------------


```bash
==> default: Forwarding ports...
    default: 22 => 2200 (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2200
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection timeout. Retrying...
    default: 
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default: 
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
```

-------------------

```bash
    default: No guest additions were detected on the base box for this VM! Guest
    default: additions are required for forwarded ports, shared folders, host only
    default: networking, and more. If SSH fails on this machine, please install
    default: the guest additions and repackage the box to continue.
    default: 
    default: This is not an error message; everything may continue to work properly,
    default: in which case you may ignore this message.
==> default: Installing rsync to the VM...
==> default: Rsyncing folder: /home/bert/Downloads/test/ => /home/vagrant/sync
```

## What happens under the hood?

```bash
$ vagrant up
```

* The base box is downloaded and stored locally
    * in `~/.vagrant.d/boxes/`
* A new VM is created and configured with the base box as template
* The VM is booted
* The box is *provisioned*
    * only the first time, must be done manually afterwards

## Done!

You now have a working VM, ready for use:

```
$ vagrant ssh
[vagrant@localhost ~]$ cat /etc/redhat-release 
CentOS Linux release 7.1.1503 (Core) 
[vagrant@localhost ~]$ 

```

# Configuring Vagrant boxes

## Vagrantfile

Minimal Vagrantfile:

```ruby
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'centos/7'
end
```

Vagrantfile = Ruby

## Finding base boxes

* Hosted by Hashicorp: <https://atlas.hashicorp.com/>
* 3rd party repository: <http://vagrantbox.es/>

## Using another base box

From the command line (Published on Atlas):

```bash
$ vagrant box add centos/7
$ vagrant init centos/7
```
. . .

From the command line (Box not on Atlas):

```bash
$ vagrant box add --name centos71-nocm \
  https://tinfbo2.hogent.be/pub/vm/centos71-nocm-1.0.16.box
$ vagrant init centos71-nocm
```
. . .

In your Vagrantfile (only applies to "old" style):

```ruby
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'centos71-nocm'
  config.vm.box_url =
    'https://tinfbo2.hogent.be/pub/vm/centos71-nocm-1.0.16.box'
end
```

## Applying the change

```bash
$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
$ vagrant up
[...]
$ vagrant ssh
```

## Configuring the VM

```{.ruby .numberLines}
VAGRANTFILE_API_VERSION = '2'

HOST_NAME = 'box001'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.hostname = HOST_NAME
  config.vm.box = 'centos/7'
  config.vm.network :private_network,
    ip: '192.168.56.65',
    netmask: '255.255.255.0'

  config.vm.provider :virtualbox do |vb|
    vb.name = HOST_NAME
    vb.customize ['modifyvm', :id, '--memory', 256]
  end
end
```

## Configuring the VM

For more info,

* see the docs at <https://docs.vagrantup.com/>
* or the default `Vagrantfile`

## Applying changes

When you change the `Vagrantfile`, do:

```bash
$ vagrant reload
```

Or, if the change is profound:

```bash
$ vagrant destroy -f
$ vagrant up
```

## Setup with multiple VMs


Vagrantfile:

```ruby
config.vm.define HOST_NAME do |node|
  node.vm.hostname = HOST_NAME
  [...]
end
```

Specify `HOST_NAME` after `vagrant` command:

```bash
$ vagrant status     # Status of *all* boxes
$ vagrant up box001  # Boot box001
$ vagrant up         # Boot *all* defined boxes
$ vagrant ssh box001
```

## Setup with multiple VMs: Example

```{.ruby .numberLines}
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define 'box001' do |node|
    node.vm.hostname = 'box001'
    node.vm.box = 'centos/7'
    node.vm.network :private_network,
      ip: '192.168.56.65',
      netmask: '255.255.255.0'

    node.vm.provider :virtualbox do |vb|
      vb.name = 'box001'
    end
  end
```

## Setup with multiple VMs: Example (cont'd)

```{.ruby .numberLines startFrom="16"}
  config.vm.define 'box002' do |node|
    node.vm.hostname = 'box002'
    node.vm.box = 'centos/7'
    node.vm.network :private_network,
      ip: '192.168.56.66',
      netmask: '255.255.255.0'

    node.vm.provider :virtualbox do |vb|
      vb.name = 'box002'
    end
  end
end
```

## Setup with multiple VMs: Example (cont'd)

```{.ruby .numberLines}
hosts = [ { name: 'box001', ip: '192.168.56.65' },
          { name: 'box002', ip: '192.168.56.66' }]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  hosts.each do |host|
    config.vm.define host[:name] do |node|
      node.vm.hostname = host[:name]
      node.vm.box = 'centos/7'
      node.vm.network :private_network,
        ip: host[:ip],
        netmask: '255.255.255.0'
      node.vm.provider :virtualbox do |vb|
        vb.name = host[:name]
      end
    end
  end
end
```


## Summary

```bash
$ vagrant init user/box   # Create Vagrantfile for specified base box
$ vim Vagrantfile         # Customize your box
$ vagrant up [host]       # Create VM(s) if needed and boot
$ vagrant reload [host]   # After every change to Vagrantfile
$ vagrant halt [host]     # Poweroff
$ vagrant destroy [host]  # Clean up!
$ vagrant ssh [host]      # log in
$ vagrant status [host]   # Status of your VM(s)
```

# Provisioning

## Provisioning

= From *Just Enough Operating System* to fully functional configured box

* **Shell script**
* **Ansible**
* **Puppet** (Apply + Agent)
* Chef (Solo + Client)
* Docker
* Salt

# Shell provisioning

## Shell provisioning

Add to your Vagrantfile

```ruby
config.vm.provision 'shell', path: 'provision.sh'
```

Put the script into the same folder as `Vagrantfile`

## Recommended workflow

* First do the installation manually (`vagrant ssh`)
* Make sure every command runs without user interaction!
* Record every command in the script
* If everything works: `vagrant destroy -f && vagrant up`


## Provisioning script

Installs Apache and PHP

```bash
#!/bin/bash -eu
# provision.sh -- Install Apache and a test PHP script

sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
yum install -y httpd php

service httpd start
chkconfig httpd on

cat > /var/www/html/index.php << EOF
<?php phpinfo(); ?>
EOF
```

MySQL is left as an exercise for the reader ;-)

## Synced folders

* Add to your `Vagrantfile`:

    ```ruby
    config.vm.synced_folder 'html', '/var/www/html'
    ```

* Create folder `html` in your project root

    ```bash
    $ tree
    .
    |-- html
    |   `-- index.php
    |-- provision.sh
    `-- Vagrantfile
    ```

* `Vagrant reload`

## Disadvantages of shell provisioning

> * Not very flexible
> * Script should be non-interactive
> * Not scalable
>     * Long Bash scripts are horrible!
> * *Idempotence* not guaranteed
>     * What happens when you run provision script multiple times?
>     * Change to script is expensive: `vagrant destroy && vagrant up`

# Provisioning with Ansible

## Ansible

<http://ansible.com/>

* Configuration management tool written in Python
* Simple configuration (YAML)
* No agent necessary (but recommended for large setups)
* Idempotent

. . .

(of course, you know this, you went to the talks yesterday...)

## Vagrant configuration

```ruby
config.vm.define 'box001' do |node|
  [...]
  node.vm.provisioning 'ansible' do |ansible|
    ansible.playbook = 'ansible/site.yml'
  end
end
```

Pro tips:

* `define` directive is important to make automatic inventory work
    * See [Vagrant/Ansible documentation](http://docs.vagrantup.com/v2/provisioning/ansible.html)
* try to mimic standard Ansible directory structure
    * See [Ansible best practices](http://docs.ansible.com/playbooks_best_practices.html)

## Let's build a LAMP stack!

First, on one box

Then, database on a separate machine

## Vagrantfile

```{.ruby .numberLines}
VAGRANTFILE_API_VERSION = '2'
hosts = [ { name: 'box001', ip: '192.168.56.65' },
          { name: 'box002', ip: '192.168.56.66' } ]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'centos/7'
  hosts.each do |host|
    config.vm.define host[:name] do |node|
      node.vm.hostname = host[:name]
      node.vm.network :private_network,
        ip: host[:ip],
        netmask: '255.255.255.0'
      node.vm.synced_folder 'html', '/var/www/html'

      node.vm.provider :virtualbox do |vb|
        vb.name = host[:name]
      end

      node.vm.provision 'ansible' do |ansible|
        ansible.playbook = 'ansible/site.yml'
      end
    end
  end
end
```

## Ansible project structure

```
$ tree ansible/
ansible/
|-- group_vars
|   `-- all
|-- roles
|   |-- common
|   |   `-- tasks
|   |       `-- main.yml
|   |-- db
|   |   `-- tasks
|   |       `-- main.yml
|   `-- web
|       `-- tasks
|           `-- main.yml
`-- site.yml
```

## Main Ansible config file: `site.yml`

```yaml
---
- hosts: box001
  sudo: true
  roles:
    - common
    - web
    - db
```

## *Common* role

```yaml
---
# file common/tasks/main.yml
- name: Install base packages
  yum: pkg={{item}} state=installed
  with_items:
    - libselinux-python
```

## *Web* role

```yaml
---
# file web/tasks/main.yml
- name: Install Apache
  yum: pkg={{item}} state=installed
  with_items:
    - httpd
    - php
    - php-xml
    - php-mysql

- name: Start Apache service
  service: name=httpd state=running enabled=yes
```

## *Db* role

```{.yaml .numberLines}
---
# file db/tasks/main.yml
- name: Install MySQL
  yum: pkg={{item}} state=installed
  with_items:
    - mysql
    - mysql-server
    - MySQL-python

- name: Start MySQL service
  service: name=mysqld state=running enabled=yes

- name: Create application database
  mysql_db: name={{ dbname }} state=present

- name: Create application database user
  mysql_user: name={{ dbuser }} password={{ dbpasswd }}
                priv=*.*:ALL host='localhost' state=present
```

## Variables

```yaml
---
# file group_vars/all

# Application database
dbname: appdb
dbuser: appusr
dbpasswd: CaxWeikun6
```

## Workflow

1. Write `Vagrantfile`
    * `vagrant up` and `vagrant reload` until you get it right
2. Write configuration
    * `vagrant provision` until you get it right
3. Think you're done?
    * `vagrant destroy -f` and `vagrant up`

## Install a webapp

E.g. [Mediawiki](http://www.mediawiki.org/wiki/Download)

1. Unpack latest mediawiki.tar.gz into `html/wiki/` directory
2. Surf to <http://192.168.56.65/wiki> and follow instructions
3. Enter values from `group_vars/all` in the install page
4. Download `LocalSite.php` and save in `html/wiki/`

Automating Mediawiki installation is left as an exercise to the reader... ;-)

## How to use this for production

Inventory file, automatically created by Vagrant:

```bash
$ cat .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory
# Generated by Vagrant

box001 ansible_ssh_host=127.0.0.1 ansible_ssh_port=2222
box002 ansible_ssh_host=127.0.0.1 ansible_ssh_port=2200
```

In production, just use a different inventory file!

## Move database to another box

What should change?

. . .

```yaml
---
# file site.yml
- hosts: box001
  sudo: true
  roles:
    - common
    - web

- hosts: box002
  sudo: true
  roles:
    - common
    - db
```

## Move database to another box (cont'd)

What should change?

```yaml
---
# db/tasks/main.yml
[...]
- name: Create application database user
  mysql_user: name={{ dbuser }} password={{ dbpasswd }}
                priv=*.*:ALL host='%' state=present
```

This should be easy to automate

# Best practices

## Best practices

> * Follow guidelines of CfgMgmt tool
    * so you can use your box outside of Vagrant
> * Keep `Vagrantfile` minimal
    * change `Vagrantfile` => `vagrant reload`
    * more expensive than `vagrant provision`

## `Vagrantfile` bloat

```{.ruby .numberLines}
  # Enable provisioning with chef solo
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe "yum"
    chef.add_recipe "yum::epel"
    chef.add_recipe "openssl"
    chef.add_recipe "apache2"
    chef.add_recipe "apache2::default"
    chef.add_recipe "apache2::mod_ssl"
    chef.add_recipe "mysql"
    chef.add_recipe "mysql::server"
    chef.add_recipe "php"
    chef.add_recipe "php::module_apc"
    chef.add_recipe "php::module_curl"
    chef.add_recipe "php::module_mysql"
    chef.add_recipe "apache2::mod_php5"
    chef.add_recipe "apache2::mod_rewrite"
    chef.json = {
        :mysql => {
              :server_root_password => 'root',
              :bind_address => '127.0.0.1'
        }
    }
  end
```
# One `Vagrantfile` to rule them all

## A reusable Vagrantfile

See <https://github.com/bertvv/ansible-skeleton>

- The `Vagrantfile` should never be changed
- Host definitions in a Yaml file:

## Example

```Yaml
- name: srv001
  ip: 192.168.56.10

- name: srv002
  box: fedora22-nocm
  box_url: https://tinfbo2.hogent.be/pub/vm/fedora22-nocm-1.0.15.box
  synced_folders:
    - src: test
      dest: /tmp/test
    - src: www
      dest: /var/www/html
      options:
        :create: true
        :owner: root
        :group: root
        :mount_options: ['dmode=0755', 'fmode=0644']
```

# Creating base boxes

## Creating base boxes

Sometimes, the available base boxes just aren't good enough...

## Manually

1. Create a VM, and take some [requirements](http://docs.vagrantup.com/v2/boxes/base.html) into account
    * a.o. `vagrant` user with sudo, ssh, package manager, Guest Additions
    * if you want: Puppet, Chef, ...
2. Execute `vagrant package --base my-vm`
    * Result: file `my-vm.box`

## Disadvantages

* It's manual
* Not quite reproducable for other provider (e.g. VMWare, Hyper-V, bare metal)

## Enter Packer

<http://www.packer.io/>

>Packer is a tool for creating identical machine images for multiple platforms from a single source configuration.


## Packer template

* JSON file with settings
    * e.g. ISO download URL, VM type, provisioner
* Kickstart file
    * Automates installation from ISO
* Post-installation scripts
    * e.g. Configure for Vagrant, install Puppet, clean up yum repository, zerodisk (smaller disk images)
* Find loads of awesome Packer templates at <https://github.com/boxcutter>
    * Ubuntu, Debian, CentOS, Fedora, Windows, ...

# That's it!

## Thank you!

Presentation slides: <https://github.com/bertvv/vagrant-presentation>

Code (not up-to-date): <https://github.com/bertvv/vagrant-example>

More at:

<https://github.com/bertvv/>
<https://www.youtube.com/user/bertvvrhogent/>

[\@bertvanvreckem](https://twitter.com/bertvanvreckem)

![CC-BY](http://i.creativecommons.org/l/by/4.0/88x31.png)

