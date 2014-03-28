% Vagrant tutorial
% Bert Van Vreckem
% LOADays, 4-5 April 2014

## Whoami

*Bert Van Vreckem*

Lecturer ICT at University College Ghent

## Agenda

# Introduction

## What is Vagrant?

## Why using Vagrant?

## Assumptions

* Vagrant version 1.5.1
* VirtualBox 4.3

```
$ vagrant --version
Vagrant 1.5.1
$ VBoxHeadless --version
Oracle VM VirtualBox Headless Interface 4.3.10
(C) 2008-2014 Oracle Corporation
All rights reserved.

4.3.10r93012
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

# Configuring vagrant boxes

## Vagrantfile

```ruby
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'centos65'
end
```


