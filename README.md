# Breakathon Example Infrastructure

This directory contains everything used to provision the breakathon example app.

```
files/     - various files used inside a level
terraform/ - Terraform recipes used to provision the level
packer/    - Packer recipes used to pre-bake the level AMIs
```

# Breakathon Contestant Guide

## Overview

Greetings!  Welcome to the PagerDuty Breakathon.  We're excited to
try out something a little different than most hackathons.  Your team will
be given several levels to solve. Whichever team completes the most
levels in the shortest time wins!

A level consists of a set of infrastructure pieces (frontend, app host,
database, cache, and SSH jump host). Within each level, there's at
least one problem that's preventing the web application from returning a
correct result.  Your task is to find the problem, and fix it!

Good luck, have fun, don't take it too seriously, and enjoy the Breakathon!

## The Infrastructure

Each challenge has the same set of infrastructure.  In ASCII art form, its:


                  (Internet)
                      |
            ----------------------
            |                    |
        (frontend1)          (jumphost1)
            |                    |
            ----------------------
                      |
               (private network)
                      |
            ----------------------
            |         |          |
         (app1)     (db1)     (cache1)


Each set of infrastructure for a level is created from the same
Packer images and Terraform templates - a sanitized version is available
in this repo.

All of the infrastructure is running within AWS using a dedicated set
of resources per challenge.  All hosts are t2.nano instances, running
Ubuntu 16.04.

* frontend1 is running Nginx as a proxy to the backend host app1. It is
  accessible from the public Internet on ports 80 and 443.
* jumphost1 is running an SSH server, and can connect to all of the other hosts
  via a private network. It is accessible from the public Internet on port 22.
* app1 is running a small boutique web application in a Docker container.  It is only accessible via
  the private network.
* db1 is running MySQL 5.6. It is only accessible via the private network.
* cache1 is running Redis 4.0.  It is only accessible via the private network.

## The Rules

* Using Google & other reference material is OK.
* Downloading and installing tools on the hosts is OK.
* The breakathon tool will confirm if the level is working or not.

## Getting Help

* Can we reset a challenge?

Yes.  Contact the judges, and they will run the command to destroy and
recreate the challenge.

Please be aware that this will irreversibly destroy all the progress your team
has made so far. There are no backups, and you will have to restart the
challenge from scratch.
