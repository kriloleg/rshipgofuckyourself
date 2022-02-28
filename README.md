# Description
So, how does this work...

This small utility helps to fetch remote file with defined list of ip addresses and check it from time to time. Using this list, each agent will work 30 min time window and swicth to the next item in the list. When reaches to the end it's... start over :)

You can spin as much agents as you want and distribution gonna be smth like:

Example for 5 agents and only 2 sites:
```
Agent 1 -> site 1
Agent 2 -> site 2
Agent 3 -> site 1
Agent 4 -> site 2
Agetn 5 -> site 1
```

# Small quide on commands

1. Download and extract archive
1. Run `./ddos.sh 5` file 
  - (it will fetch docker image first time)
  - `5` is a number of agents to spin up
1. Run `./statistic.sh` to see whichs sites are under attack
1. Run `./stop.sh` to stop and kill all **ddos** containers

# Requirements

1. Just have VPN enabled all this time
2. Use Linux machine (that have `docker` and `wget` to work)

# Disclaimer

Use only for tests )
