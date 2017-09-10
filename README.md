# docker-lets-encrypt-proxy

Nginx Reverse Proxy automatically managing Let's Encrypt certificates

Environment variables:

* `ORIGIN_HOST` main server hostname or ip address (eg https://www.domain.com ) 

# Instructions for deploying to AWS

* Create a new Amazon ECS cluster
* Make sure ports 80 and 443 are open to all inbound traffic
* Create a new ECS task pointing to this repo, make sure the ORIGIN_HOST variable is set
* Deploy the task to the ECS cluster
* Point new domains to the ECS cluster
