FROM debian:latest

RUN apt-get update -y && apt-get upgrade -y 

RUN apt-get install -y vim unzip curl wget less git

# Install Terraform
RUN curl -O https://releases.hashicorp.com/terraform/1.0.8/terraform_1.0.8_linux_amd64.zip
RUN unzip terraform_1.0.8_linux_amd64.zip
RUN chmod +x terraform
RUN mv terraform /usr/bin

# Install AWS CLI
RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip"
RUN unzip awscli-exe-linux-x86_64-2.0.30.zip
RUN ./aws/install

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x kubectl
RUN mv kubectl /usr/bin