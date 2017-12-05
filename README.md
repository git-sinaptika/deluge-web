# sinaptika/deluge-web
Docker image for deluge web interface  
From alpine:3.7  
[Deluge: 1.3.15](http://deluge-torrent.org/)    
This image contains only Deluge Web interface.  
Deluge daemon port: /  
Deluged incoming port tcp&udp: /  
Deluge web interface port: 8112  
[Github](https://github.com/git-sinaptika/deluge-web)  


#### Simple instructions:  
1. Pull the image from docker-hub:  
`docker pull sinaptika/deluge-web`  

2. Create a directory called deluge inside your home directory on the host:  
`mkdir ~/deluge`

3. Create or run your container:  
`docker run -d \`  
`--name c_deluge-web \`  
`-p 8112:8112 \`  
`-v ~/deluge:/opt/deluge \`  
`sinaptika/deluge-web`

4. Default password for the web interface is "deluge". Change it on first logon.

Other optional variables, that you can pass at `docker create -e` or `docker run -e`  
are:  
- `-e TZ=<timezone>` (examples: Europe/London or America/New_York)

#### Notes:
Don't use *--net host* on *docker create*, unless you know what you are doing.  
If you are using more than one interface with deluge, add docker network to container.  
Macvlan works great, so does ipvlan (but ipvlan is not yet included in docker stable).  
If you are having problems with file permission, check *-e D_UID=* and *-e D_D_UMASK=*  
If you are using only the web interface for accessing deluged, you don't need to  
expose port 58846 on the host.  
If building this image locally, don't forget that compiling latest libtorrent  
will take some time even on modern hw.  
For proxying just deluge-web don't use Apache or Nginx, it's overkill. Try caddy?  
If you are proxying more containers on your host, try traefik? Both support letsencrypt.  
If you are using dockerfile labels (docker-gen, etc), you can remove/change existing ones.  
All of the above is ofc just an opinion and ymmv.

**For a complete deluge docker image, consider using deluge images.**  
[deluge github](https://github.com/git-sinaptika/deluge)  
[deluge dockerhub](https://hub.docker.com/r/sinaptika/deluge/)  

**For advance uses or more customization, consider using separate images for deluged and deluge-web.**  
[deluged github](https://github.com/git-sinaptika/deluged)  
[deluged dockerhub](https://hub.docker.com/r/sinaptika/deluged/)  
[deluge-web github](https://github.com/git-sinaptika/deluge-web)  
[deluge-web dockerhub](https://hub.docker.com/r/sinaptika/deluge-web/)  

#### Changelog for deluge, deluged and deluge-web:  
**0.1**  
- supervisor integration  
  - umask and user done
  - passing variables to entrypoint and supervisor done  

**0.2**  
- fixing typos in readme, some basic editing in dockerfile
  - starting to unify structure/style in deluged, deluge-web and deluge images  

**0.3**
- downgraded libtorrent to 1.0.11 for stable, latest, and 1.3.15 tags
- added dev and stable

**0.4**
- Changed to multi-stage build and ssl force on deluge-web

**0.5**
- Dir strcuture changes on github and tag changes on docker hub
- Some syntax changes
- Added first run with debug for deluge-web

**0.6**
- Changed git source from git:deluge.org to github 
- removed selfsigned certs from image

**0.7**
- Upgraded libtorrent and deluge base images to Alpine 3.7