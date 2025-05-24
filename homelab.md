# Aspirations of a home lab
The 'core' of the home lab would be a kubernetes cluster with associated control panes, a code pipeline and raid storage. The 'core' is distinguished as all of the services which are necessary for bootstrapping and maintaining the cluster itself (though they may be used for other things as well).

I've a number of 'apps' in mind as well, services which I would prefer to self host, if not build myself.

In terms of hardware, I want to focus on reviving old tech, and having fully hot pluggable nodes / storage. Lets give new life to old desktops, laptops, tablets and phones. This won't be the most power efficient, but the old hardware will be trash othewise.

If performance is ever a bottleneck, I want to be able to spin up a node on the cloud just as easily as on local hardware, though I intend to have long running services run on my hardware at home.
I may have a node for offsite backups running elsewhere.

# management scripts
* rotate keys
* provision new node
* deprovision node


# networking
nodes communicate to each other through wireguard.
* [wireguard](https://www.wireguard.com/)
    * [multicloud overlay network](https://kilo.squat.ai/)
## public subnet
A public domain name points to the ingress controller (nginx). Services are exposed as subdomains. SSL certs by letsencrypt
* caeman.dev:443 - professional profile and blog
* caeman.dev:22 - soft-serve git forge (read only)
* 0x0.caeman.dev - file sharing
* pad.caeman.dev - etherpad, collaborative editing
* social nodes? activitypub, mastadon, scuttlebutt

## private subnet
Private services are only available through wireguard at `<service>.k8s` domains?
Trusted 'seats' also need to be runnning wireguard to access the subnet
* k8s gui
* NAS
    * sshfs
* artifact store
* git gui
* monitoring - grafana
* alerting - apprise
* 3d printer service [octoprint](https://octoprint.org/)
* password manager?
* pihole egress

# hypervisor
* [proxmox](https://www.proxmox.com/en/)
* [NUT](https://networkupstools.org/)
* bare metal k8s
* talos linux - k8s optimized linux distro
* custom node image?
* k8s vs [k3s](https://k3s.io/)

# compute
something like aws lambda + ec2 + ecs
* lambda - deploy single files scripts as webhooks, cron, etc.
    run on demand, but not long-running
* docker - containerized apps, the bulk of compute
* vms - to run windows mostly
* hypervisors - what actually runs on the bare metal? How do they connect to the cluster?

# GPU
* gpu passthrough?

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
* relational db - postgres? sqlite
* storage - truenas?
* docker cluster - k8s?

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
* user/permission management interface
    * want to specify user sign up, default permissions
    * also specify access control for services, default access control for new services

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
        * [listentoanything](https://listentoanything.com/)

    * project gutenburg -> TTS -> phone
* rss
* generate an AI summary of the news
* local wikipedia
* atuin sync
* adblock/pihole
* media server + a [projector](https://www.ign.com/articles/best-gaming-projector)
* filesharing - nextcloud
    * [0x0](https://0x0.st/)
* password manager
    * bitwarden?
    * vaultwarden
    * keepass
* llm - ollama
* gsuite replacement
* personal CRM / contact list tool
    * sqlite + charm tui
* fediverse nodes
* cryptomining? probably not
* [distributed rendering for blender](https://github.com/LogicReinc/LogicReinc.BlendFarm)
* collaborative editing - [etherpad](https://github.com/ether/etherpad-lite)
* IoT
* search index?
* firefox sync
* read later app + extension [wallabag](https://wallabag.org/)
* 3d printer farm
* [omg.lol](https://omg.lol)
* [pico.sh](https://pico.sh/)
    * micro pubsub over ssh
    * rss-to-email
    * pastebin over ssh?
    * [experiments](https://pico.sh/lab)
* make and host io games

# science
* protein folding (folding@home)
* star searching

# media store
* wallhaven
* youtube
* royalroad

# ref
* [awesome-homelab](https://github.com/ccbikai/awesome-homelab)

* data orchestrator?
    * apache airflow
    * kubeflow
* message streaming / bus / queue
    * kafka
    * amazon sqs
    * rabbitmq
    * mqtt
* PXE netboot controller [pixiecore](https://github.com/danderson/netboot/tree/main/pixiecore)
