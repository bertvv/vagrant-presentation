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

# Getting up and running

## Minimal default setup:

```bash

$ vagrant init hashicorp/precise32
$ vagrant up

```

## What happens under the hood?


```bash
$ vagrant init hashicorp/precise32
```



# Configuring vagrant boxes

## Vagrantfile

```ruby
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'centos65'
end
```


