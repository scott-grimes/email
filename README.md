## personal cloud

Semi-automated private email, owncloud, and website provisioning

# Requirements

aws cli
jq
openssl
ansible

# Fresh Install Infrastructure Steps

1) Create a new AWS account and generate access keys. Set your AWS_PROFILE variable accordingly then create an s3 bucket

`aws s3api create-bucket --bucket "u$(aws iam get-user | jq -r '.User.UserId')-$(openssl rand -hex 8)" --region "us-east-1" | jq -r '.Location'`

Update terraform/mail/backend with the name of your bucket from above

2) Create a dynamo table to store terraform backend

`aws dynamodb create-table --table-name terraform-lock-table --key-schema AttributeName=LockID,KeyType=HASH --attribute-definitions AttributeName=LockID,AttributeType=S --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5`

3) Create an ssh key to login to your instance (optionally place your own pub key in secrets/ssh_key.pub)

`ssh-keygen -t rsa -b 4096 -N "" -q -f secrets/ssh_key`

4) Generate the certificates for the vpn to ssh onto the instance

`./lib/generate_vpn_certificates.sh`

5) Cd to terraform/mail and run

```
tf init
tf apply -target=module.email.aws_ec2_client_vpn_endpoint.default -target=module.email.aws_acm_certificate.client -target=module.email.aws_acm_certificate.server

```

6) Currently tf does not fully support vpn client endpoints. Run
`./lib/associate_vpn.sh`
This will complete the last few tasks that tf cannot do (associate_vpn, adding routes to vpn etc)

7) Connect to vpn using secrets/email.ovpn. Then finish applying tf resources in terraform/mail
`tf apply`

Note: it's required to be on the vpn for terraform to provision the instance correctly

8) You now have an empty server, provision it
```
PRIVATE_IP=$(aws ec2 describe-instances | jq -r '.Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddress')
DOMAIN=scottgrim.es
ansible-playbook -e "working_host=${PRIVATE_IP}" -e "domain=${DOMAIN}" --private-key ../secrets/ssh_key -u ubuntu site.yml
```

10) Run

setup user

10) get dkin records

create mx and a record pointing to public ip

<!-- sudo dd if=/dev/zero of=/swapfile bs=1M count=1000
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon -s
vim /etc/fstab
/swapfile swap swap defaults 0 0 -->

# Transfer Steps
