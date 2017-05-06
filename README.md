# sinaptika/deluge-web
Docker image for deluge web interface   
From alpine:3.5  
Deluge: 1.3.14  
This image contains only Deluge web interface.  
Deluge web interface port: 8112  
[Deluge 1.3.14](http://deluge-torrent.org/)  
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

4. Default password for the web interface is "deluge"

Other optional variables, that you can pass at `docker create -e` or `docker run -e`  
are:  
- `-e TZ=<timezone>` (examples: Europe/London or America/New_York)

#### Notes:
If you will be using your own ssl certificates, consider mounting /opt/deluge/ssl  
in a named docker volume: `-v v_deluge-web-ssl:/opt/deluge/ssl`  
If you are running a reverse proxy container (caddy, nginx) in the same docker  
network, you don't need to expose 8112 on the host.
