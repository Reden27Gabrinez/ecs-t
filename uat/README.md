
### Create directories for app
```
mkdir -p uat && cd $_ && mkdir -p 0-network 1-iam 2-storage 4-ingress 5-app && \
cd 0-network && \
terragrunt scaffold git::https://gitlab.com/dmagsipoc1/aws-modules.git//modules/0-networking && \
cd ../1-iam/ && \
terragrunt scaffold git::https://gitlab.com/dmagsipoc1/aws-modules.git//modules/1-iam && \
cd ../2-storage/ && \
terragrunt scaffold git::https://gitlab.com/dmagsipoc1/aws-modules.git//modules/2-storage && \
cd ../5-app  && \
mkdir -p claws && \
terragrunt scaffold git::https://gitlab.com/dmagsipoc1/aws-modules.git//modules/5.0-ec2-asg
```
 <!-- du -ah /var/lib/ | sort -n -r | head -n 10 

 sudo du -h -s / | sort -n -r | head -n 10  -->

 <!-- cd ../4-ingress/ && \
terragrunt scaffold git::https://gitlab.com/dmagsipoc1/aws-modules.git//modules/4-ingress && \ -->

## Check dependency cycle

* This problem sometimes pertains to blank config path
```
dependency "iam" {
  config_path = ""
```

# Uncomment this line if you want to have common variables per environment in 0-network
```
include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}
```

# Add parameters in 1-iam
```
# Description: List of names of environment config stored in ssm parameter store.
parameter_store_env_names = ["claws-b64-new"]
```

## Delete instance profile
```
aws iam delete-instance-profile --instance-profile-name uat-instance-profile
```