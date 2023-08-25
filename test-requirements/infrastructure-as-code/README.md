# devops.technical-tests.infrastructure-as-code

Given an application with a frontend, a backend and a Redis, write Terraform scripts to provision a necessary infrastructure on AWS. These scripts should include the following resources:
  - 2 EC2 instances
    - an identity access management role allowing instances to communicate with each other
  - a VPC containing with following attached resources
    - a VPC Internet gateway
    - a VPC NAT gateway
    - an elastic ip address
    - 2 subnets (a public and a private)
    - a VPC routing table
    - the necessary route table entries to redirect the subnets
    - a security group
  - an Elasticache instance with the following attributes
    - part of the previous VPC
    - a security group allowing the port `6379` from the private subnet
  - a S3 buckets name `prrtprrt-$YOURNAME`
    - versionning enable
    - server side encryption configuration enabled with a customer key, aliased `prrtprrt-$YOURNAME`
  - provide the necessary .tf files to test your code
