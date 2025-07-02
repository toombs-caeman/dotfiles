# Aspirations of a home lab
The 'core' of the home lab would be a kubernetes cluster with associated control panes, a code pipeline and raid storage. The 'core' is distinguished as all of the services which are necessary for bootstrapping and maintaining the cluster itself (though they may be used for other things as well).

I've a number of 'apps' in mind as well, services which I would prefer to self host, if not build myself.

In terms of hardware, I want to focus on reviving old tech, and having fully hot pluggable nodes / storage. Lets give new life to old desktops, laptops, tablets and phones. This won't be the most power efficient, but the old hardware will be trash othewise.

# management actions
accomplish with nushell and talosctl?
* rotate master key
* bootstrap cluster
* provision new node
* deprovision node
* check node health, as part of monitoring system also

# level 0 - hardware & bios
* make sure to turn on bios setting to boot on power restore

## servers
* NAS build - master node (jack)
* old laptops - auxillary nodes (havarti)

## non-servers
* router - need to assign a static ip to at least the main server, and route incoming traffic to it
* domain name - toombs.casa? caeman.dev?
    * need an auto updater script
    * [update-godaddy-dns](https://github.com/UnklAdM/update-godaddy-dns/blob/master/update_gd_dns.sh)

# level 1 - cluster hypervisor
* [proxmox](https://www.proxmox.com/en/)
    * gpu passthrough?
    * [raid 10](https://www.youtube.com/watch?v=_8mtwLT_owE)
    * how is storage access provisioned? Does it play nice with k8s?
* server/cluster backups here?
* ?[NUT](https://networkupstools.org/)

# level 2 - orchestrator
* [talos?](https://www.talos.dev/v1.10/talos-guides/install/virtualized-platforms/proxmox/)
    * There should be by default one control VM and N worker VMs where N is the number of physical servers?

# level 2.5 - core apps
configured through k8s declarative configuration

* routing - traefik reverse proxy
    * ssl - letsencrypt certbot?
    * auth middleware - dex/keycloak
        * [dex](https://github.com/dexidp/dex) with passthrough to gitlab?
        * [gitlab as IdP](https://docs.gitlab.com/integration/openid_connect_provider/)
        * https://geek-cookbook.funkypenguin.co.nz/docker-swarm/traefik-forward-auth/dex-static/
    * auto-config to route k8s containers *.toombs.casa
    * auto/manual config route to proxmox VMs. can we do automatic? *.vm.toombs.casa
    * manual config access to proxmox host? proxmox.toombs.casa
    * manual config, what does toombs.casa point to?

* gitlab
    * IdP?
    * git host
    * issue tracker
    * ci/cd - does it need docker permissions to do that? maybe a separate vm? [fluxcd?](https://fluxcd.io/flux/)
    * release artifacts? push containers to local registry (alt jfrog)

* docker registry
    * [docker pull-through cache](https://docs.docker.com/docker-hub/image-library/mirror/#solution)
    * how can we have k8s pull containers from here?

* monitoring
    * grafana, loki, prometheus
    * alerting - apprise? one signal?
    * alert on raid health, disk full
    * alert on service restored
    * alert on IP/DNS update
    * alert on new/updated IdP user
    * alert on backup failure

* unified ssh access management?
    * unified access to vms and docker containers, define permissions in dex?
    * sso for ssh through dex?
        * [smallstep](https://smallstep.com/blog/diy-single-sign-on-for-ssh/)
    * proxmox ssh outside of this system, as a 'master key'?

* platform config
    * track in gitlab repo.
    * deployments through ci/cd (must have manual option for bootstrap/recovery)
    * terraform w/ proxmox provider?

* dynamic dns hack - update dns record if local ip changes.
    * in email notification, also send the new ip just in case
    * [update-godaddy-dns](https://github.com/UnklAdM/update-godaddy-dns/blob/master/update_gd_dns.sh)

# level 3 - userland apps (the first round)
* nas. - file server? private/semi-private
    * laptop/desktop/phone backups - syncthing?
    * Then comes the long process of compiling old drives into the nas. Old phones? Once this is done, use at least one drive as offline backup.
* dashboard. - links to all the traefik routes. this may be built in. [heimdall?](https://heimdall.site/)
* hire. - professional resume. public
* blog. - less professional musings. public
    * blog about bitwise games
* pihole. - pihole dns. local
* 3d. - 3d printer service [octoprint](https://octoprint.org/). local
* anki. - anki sync server. private/separate auth?

# next level (future apps maybe)
* off site replication of backups
* media server + a [projector](https://www.ign.com/articles/best-gaming-projector)
* 0x0. - file sharing
* pad. - etherpad, collaborative editing
* social nodes? activitypub, mastadon, scuttlebutt
* move repo's off github, mirror them there?
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
    * wallhaven
    * youtube
    * royalroad
* rss
* local wikipedia

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

* protein folding (folding@home)
* star searching

* [awesome-homelab](https://github.com/ccbikai/awesome-homelab)
