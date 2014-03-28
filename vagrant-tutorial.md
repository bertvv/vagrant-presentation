% Vagrant tutorial
% Bert Van Vreckem
% LOADays, 4-5 April 2014

## Whoami

*Bert Van Vreckem*

Lecturer ICT at University College Ghent

## Have a question/remark? Please interrupt me!

## Agenda

# Introduction

## What is Vagrant?

## Why using Vagrant?

## Assumptions

* Vagrant version 1.5.1
* VirtualBox 4.3.10
    * default Host-only network (192.168.56.0/24)

```shell-session
$ vagrant --version
Vagrant 1.5.1
$ VBoxHeadless --version
Oracle VM VirtualBox Headless Interface 4.3.10
(C) 2008-2014 Oracle Corporation
All rights reserved.

4.3.10r93012
$ ifconfig vboxnet0
=> 192.168.56.1
```


# Getting up and running

## Minimal default setup:

```bash

$ vagrant init hashicorp/precise32
$ vagrant up
$ vagrant ssh

```

## What happens under the hood?


```bash
$ vagrant init hashicorp/precise32
```

A *Vagrantfile* is created

## What happens under the hood?

```bash
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'hashicorp/precise32' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'hashicorp/precise32'
    default: URL: https://vagrantcloud.com/hashicorp/precise32
==> default: Adding box 'hashicorp/precise32' (v1.0.0) for provider: virtualbox
    default: Downloading: https://vagrantcloud.com/hashicorp/precise32/version/1/provider/virtualbox.box
==> default: Successfully added box 'hashicorp/precise32' (v1.0.0) for 'virtualbox'!
==> default: Importing base box 'hashicorp/precise32'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'hashicorp/precise32' is up to date...
==> default: Setting the name of the VM: example_default_1395996714768_3176
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 => 2222 (adapter 1)
```

-------------------


```bash
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: The guest additions on this VM do not match the installed version of
    default: VirtualBox! In most cases this is fine, but in rare cases it can
    default: prevent things such as shared folders from working properly. If you see
    default: shared folder errors, please make sure the guest additions within the
    default: virtual machine match the version of VirtualBox you have installed on
    default: your host and reload your VM.
    default: 
    default: Guest Additions Version: 4.2.0
    default: VirtualBox Version: 4.3
==> default: Mounting shared folders...
    default: /vagrant => /home/bert/CfgMgmt/vagrant-example
```

## Done!

You now have a working VM, ready for use:

```
$ vagrant ssh
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic-pae i686)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Fri Sep 14 06:22:31 2012 from 10.0.2.2
vagrant@precise32:~$ 
```
# Let's build a CentOS LAMP stack!

# Configuring Vagrant boxes

## Vagrantfile

Minimal Vagrantfile:

```ruby
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'hashicorp/precise32'
end
```

This is Ubuntu 12.04 LTS 32 bit,

we want CentOS 6.5 64 bit

## Finding base boxes

* <https://vagrantcloud.com/> (since 1.5)
* <http://vagrantbox.es/> (pre-1.5 boxes)

## Using another base box

From the command line (Vagrant cloud):

```bash
$ vagrant init alphainternational/centos-6.5-x64
```
. . .

From the command line ("old" style):

```bash
$ vagrant box add --name centos65 \
  http://packages.vstone.eu/vagrant-boxes/centos-6.x-64bit-latest.box
$ vagrant init centos65
```
. . .

In your Vagrantfile (only applies to "old" style):

```ruby
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'centos65'
  config.vm.box_url =
    'http://packages.vstone.eu/vagrant-boxes/centos-6.x-64bit-latest.box'
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
  config.vm.box = 'alphainternational/centos-6.5-x64'
  config.vm.network :private_network,
    ip: '192.168.56.65',
    netmask: '255.255.255.0'

  config.vm.provider :virtualbox do |vb|
    vb.name = HOST_NAME
  end
end
```

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

## Summary

```bash
$ vagrant init user/box   # Create Vagrantfile for specified base box
$ vim Vagrantfile         # Customize your box
$ vagrant up              # Create VM and boot it
$ vagrant reload          # After every change to Vagrantfile
$ vagrant destroy         # Clean up!
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


