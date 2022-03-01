# Description

Tool helps to perform DDoS attack for the list of services. It's not intended to harm, but only for tests, so be careful! ONLY for tests :)

The main idea behind is:
1. You run the tool and say how many workers you want to have
1. Each worker goes to the remote and takes list of targest
1. Each worker start sending packets to the target in list for 30 minutes and then switch to the next one
1. When reaches to the end - start over

Also, keep in mind that number of agents will try to distribute among targets you have and it will be something like this (example of 5 agents for 2 targets):

```
Agent 1 -> site 1
Agent 2 -> site 2
Agent 3 -> site 1
Agent 4 -> site 2
Agetn 5 -> site 1
```

Sure thing, you are not limitted to this and there are few more options you can use:
1. Work in default mode (use VPN for this) 
1. Work in proxy mode (it's using Tor Network)
1. Work in proxy-custom mode (it's using `proxies.txt` file)
1. Work with locally defined targets (it's using `targets.txt file)

# Usage

`./ddos.sh <agents> <mode> <targets>`

- **agents** - Just a number of agents to spin up
   **1** - can be any number that is possible to handle from single machines, but don't make it too big

- **mode** - Mode to use for running the script
   **default** - requires VPN or being deployed to the required network subnet to have access
   **proxy** - send request through the proxychains with help of tor network
   **proxy-custom** - send requests using customly defined proxy servers in file 'proxies.txt' has to be defined in the format as 'socks5 127.0.0.1 9050'
- **targets** - The place, where targets should be taken from
   **remote** - will guery targets from the network and will follow them
   **local** - takes targets from the loca 'targets.txt' file


# Small quide on commands

1. Download and extract archive
1. Run `./ddos.sh 5` file 
  - (it will fetch docker image first time)
  - `5` is a number of agents to spin up
1. Run `./statistic.sh` to see whichs sites are under attack
1. Run `./stop.sh` to stop and kill all **ddos** containers

# Requirements

1. VPN if you don't use proxy
2. Linux machine with `docker` and `wget` preinstalled

