FROM ubuntu:jammy

RUN apt update && \
apt install wget gpg curl lsb-release python3-pip software-properties-common -y && \
wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
apt update && apt install -y terraform packer && \
wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.67.14/terragrunt_linux_amd64 -O terragrunt && \
chmod 755 terragrunt && \
mv terragrunt /usr/local/bin/terragrunt && \
pip install awscli