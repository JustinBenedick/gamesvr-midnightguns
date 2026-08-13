# \# MidnightGuns Dedicated Server in Docker

# 

Midnight guns is a team based shooter based off the Quake 2 engine and id developed by \[TastySpleen](http://tastyspleen.net/)

===

# !\[Midnight Guns screenshot](https://raw.githubusercontent.com/LacledesLAN/gamesvr-midnightguns/master/.misc/artwork1.jpg "Midnight Guns Screenshot")

# 

# This repository is maintained by \[Laclede's LAN](https://lacledeslan.com). Its contents are intended to be bare-bones

# and used as a stock server. For examples of building a customized server from this Docker image browse its related

# child-projects \[gamesvr-tf2-blindfrag](https://github.com/LacledesLAN/gamesvr-tf2-blindfrag) and

# \[gamesvr-tf2-freeplay](https://github.com/LacledesLAN/gamesvr-tf2-freeplay). If any documentation is unclear or it has

# any issues please see \[CONTRIBUTING.md](./CONTRIBUTING.md).

# 

# \## Linux

# 

# \### Download

# 

# ```shell

# docker pull lacledeslan/gamesvr-midnightguns;

# ```

# 

# \### Run Self Tests

# 

# The image includes a test script that can be used to verify its contents. No changes or pull-requests will be accepted

# to this repository if any tests fail.

# 

# ```shell

# docker run -it --rm lacledeslan/gamesvr-midnightguns ./ll-tests/gamesvr-midnightguns.sh;

# ```

# 

# \### Run simple interactive server

# 

# ```shell

# docker run -it --rm --net=host lacledeslan/gamesvr-tf2 ./midnightguns  -server -protocol MIDNIGHT +sv\_port 27501 +map harlem +set hostname "Hostname" +exec server.cfg;

# ```

# 

# \## Getting Started with Game Servers in Docker

# 

# \[Docker](https://docs.docker.com/) is an open-source project that bundles applications into lightweight, portable,

# self-sufficient containers. For a crash course on running Dockerized game servers check out \[Using Docker for Game

# Servers](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/DockerAndGameServers.md). For tips, tricks,

# and recommended tools for working with Laclede's LAN Dockerized game server repos see the guide for \[Working with our

# Game Server Repos](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/WorkingWithOurRepos.md). You can

# also browse all of our other Dockerized game servers: \[Laclede's LAN Game Servers

# Directory](https://github.com/LacledesLAN/README.1ST/tree/master/GameServers).

# 

