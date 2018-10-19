# Build squid3_proxy docker
```
docker build --tag=squid3_proxy -f squid3_proxy.dockerfile .
```

# Create two network
```
# with internet
docker network create --subnet=172.19.0.0/16 internet

# without internet
docker network create --internal --subnet 10.1.1.0/24 no-internet
```


# Run proxy server
```
# run proxy server with internet work
docker run --rm -t -d --network=internet -p 3128:3128 --name=proxy_server squid3_proxy

# connect proxy server to the network without internet as well
docker network connect no-internet proxy_server

# log into proxy server
docker exec -it proxy_server /bin/bash

# test internet
curl www.google.com

# test proxy
export http_proxy=http://username:p%40ssw0rd@localhost:3128
curl www.google.com

```

# Test proxy with air-gapped endpoint
```
# run air-gapped endpoint 
docker run --rm -t -d --network=no-internet --link=proxy_server --name=airgap_endpoint centos:7

# log into air-gapped endpoint 
docker exec -it airgap_endpoint /bin/bash

# test internet
curl www.google.com

# test proxy
export http_proxy=http://username:p%40ssw0rd@proxy_server:3128
curl www.google.com
```

# Clean up
```
docker rm -f airgap_endpoint
docker rm -f proxy_server
docker network rm no-internet
docker network rm internet
```

