# udpserver

This is a basic udp listener which runs in a CentOS Docker container and can be
spun up by terraform.  The server will listen on port 5000 which is exposed externally.

Example input and output look like:

```
$ echo -n '[17/06/2016 12:30] Time to leave' | nc -u 54.163.79.249 5000
{"timestamp":1468758600,"hostname":"ip-172-31-44-110","container":"brandonmetcalf/udpserver","message":"Time to leave"}
```

The Docker container is started with the syslog driver, so logs are written through syslog on the Docker host.

Basic assumptions and requirements are:

* AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY must be defined in user's environment
* Default security group in AWS already allows 5000/udp inbound
* SSH key pair defined in AWS and terraform variable key_name set to same
* Private key added to user's keychain

To launch the udp server in AWS, run:

```
$ terraform plan
$ terraform apply
$ terraform show
```

The above will pull the latest brandonmetcalf/udpserver from http://hub.docker.com/.

In order to build your own Docker image for udpserver, run:

```
cd docker
docker build .
```

### Next Steps and Scalability

Clearly, we need more than one udpserver container running for scalability and resiliency.  Additionally, we need a way
to balance UDP requests across all containers.  Since AWS ELBs do not support UDP, we could stand up a reverse proxy
such as HAProxy to fron the udpserver containers.  However, this is one more layer to maintain and if only one, another 
single point of failure.

I like load balancing at the DNS layer using Route53 andd health checks.  Each udpserver would have a equal weight policy
and corresponding health check.  Doing so we only have to worry about maintaining adequate udpserver resources and ensuring
the appropriate record is created in Route53. 
