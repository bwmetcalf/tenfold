# udpserver

This is a basic udp listener which runs in a CentOS Docker container and can be
spun up by terraform.  The server will listen on port 5000 which is exposed externally.

Example input and output look like:

```
$ echo -n '[17/06/2016 12:30] Time to leave' | nc -u 54.163.79.249 5000
{"timestamp":1468758600,"hostname":"ip-172-31-44-110","container":"brandonmetcalf/udpserver","message":"Time to leave"}
```

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


