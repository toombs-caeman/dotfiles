# Aspirations of a home lab
If I were to get into having more serious compute around the house.

I think it would be cool to revive old laptops and phones by connecting them into a home k8s cluster.

# hardware
* rack mount server
* old laptops
* old phones
* network switch?
* router

# hypervisor
* [proxmox](https://www.proxmox.com/en/)
* [NUT](https://networkupstools.org/)
* bare metal k8s
* talos linux - k8s optimized linux distro

# compute
something like aws lambda + ec2 + ecs
* lambda - deploy single files scripts as webhooks, cron, etc.
    run on demand, but not long-running
* docker - containerized apps, the bulk of compute
* vms - to run windows mostly
* hypervisors - what actually runs on the bare metal? How do they connect to the cluster?

# storage
not sure what the best way is here. Something like s3?
* NAS
* ceph cluster?
* raid cluster? btrfs raid6?
* trueNAS?

# artifact repository - jfrog?
* machine images
    * server image - arch iso?
    * desktop image - arch iso.
    * bsd, etc. cross-compiler images?
    * windows vm
* docker images - a local mirror and private store
* binaries

# basic services
* monitoring dashboard - grafana
* notifications - apprise
* logging - ??
* time series db - influxdb
* relational db - postgres?
* storage - truenas?
* docker cluster - k8s?

# network
* domain name - duckdns, toombs.club, stacyfake.name, caeman.tech
* ssl certificates - letsencrypt
* routing - nginx
* dns server? to shortcircuit local name resolution
* openwrt?

# code pipeline
* git origin - gogs, gitlab?
    * [forgejo](https://forgejo.org/)
    * [soft-serve](https://github.com/charmbracelet/soft-serve?tab=readme-ov-file) [charm](https://charm.sh/)
    
* ci/cd
    * [fluxcd](https://fluxcd.io/)
    * dokku / piku
* artifact repository - jfrog?

# management
* project kanban / ticket system - jira, asana
* services dashboard - 
* backups
    * offsite backups
* provisioning
    * terraform, dokku, k8s?
    * rancher desktop. probably not

# identity & authentication
* IdP - google? keycloak?
* [ssh through sso](https://smallstep.com/blog/diy-single-sign-on-for-ssh/)

# Applications
* RDP
    * can we get the latency (over lan) low enough to passthrough to a windows vm for gaming?
    * [win-docker](https://github.com/dockur/windows)
    * windows vm - can the latency get low enough for RDP gaming on LAN?
    * remote desktop viewing for a windows application.
* scrapers
    * scrape data and store it
    * send notifications on webnovel updates
    * scrape novel text, generate audio with TTS, load to phone for morning commute?
    * project gutenburg -> TTS -> phone
* rss
* generate an AI summary of the news
* local wikipedia
* atuin sync
* adblock/pihole
* media server + a [projector](https://www.ign.com/articles/best-gaming-projector)
* filesharing - nextcloud
    * [0x0](https://0x0.st/)
* password manager - bitwarden?
* llm - ollama
* gsuite replacement
* personal CRM / contact list tool
* fediverse nodes
* cryptomining? probably not
* [distributed rendering for blender](https://github.com/LogicReinc/LogicReinc.BlendFarm)
* collaborative editing - [etherpad](https://github.com/ether/etherpad-lite)
* IoT
* search index?
* url shortener
* firefox sync
* read later app + extension https://wallabag.org/
* 3d printer farm

# science
* protein folding (folding@home)
* star searching

# ref
* [awesome-homelab](https://github.com/ccbikai/awesome-homelab)

