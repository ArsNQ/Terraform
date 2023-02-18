## AUTHENTICATION
```bash
gcloud auth application-default login
gcloud config set project <my-gcp-project>
```

### step to reproduce
```bash
terraform init
terraform plan 
terraform apply
```

### show ip address
```bash
terraform show | grep "nat_ip"
```

sudo yum makecache
sudo yum install subscription-manager
subscription-manager register
subscription-manager refresh
subscription-manager list --available
subscription-manager attach --pool=2c9490ad84346c0501843ea1d14c0fa1
subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.11-rpms" --enable="rhel-7-server-ansible-2.9-rpms"
yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
yum -y update

yum -y install openshift-ansible
yum -y install docker

ssh-keygen

for host in 34.27.200.12 104.198.224.43 34.173.3.252; do ssh-copy-id -i ~/.ssh/id_rsa.pub $host; done
