#!/bin/sh
set -e

sudo apt update
sudo apt upgrade -y

sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# create github user
sudo mkdir -p /home/app
sudo useradd --no-create-home --home-dir /home/app --shell /bin/bash github
sudo usermod --append --groups docker github
sudo usermod --append --groups docker ubuntu
sudo chown github:github -R /home/app

github_pubkey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCcIhewA5UjW6VP2PydKGdwp3TtlkQT+0RVeOuQOQNalZKMLIynVhiQVef5gTY/9aEbiVueGoi/kHDKtxk1mbU0Q9gX7Euld20jk9NSpPrT/lXvMLfN8XSEg7QpSK21HrnXnlZ8dDZJfzvv8qQkch2P4pXKZHpeg1ksNaMbREQy0Kp+gqy0sbtBR51Xn9Acm4FvZtCPsrQh3lH6NzuPhuNFGB5mMS0Us+A/fCxe7xQ+odsAUhCQdC8uXz4Jp1rLQ3uLf04KCG5V82KzKy52a7Bb8cZm0TDbi1c5+wVTmBGmZzkIG19gQxhYA4Y2DbKA3lLrGE8lixYdE7KNBR2urvIQXP8jJiZv24+uhU9WAOYJG8Z4xwDW5kW/7zkPZf/sBGZrMNc5Q8vZCKSnbrzpaxQJVpwVE/cF5ydxdB5KriXzTnQjQyC+krNWM/zaBdjnkThOV77sIivk9T4Z4GJCB0Qh4tLXJdhx0BKOs7g2/FA+0/C19If8ka3dOA4+KYBr5EBMzSNf6FjKCuRw6VkfFQo6qkHM6UnS7ikg6a8mvFNirvS9yoanXuxk8NdfMfRp5ftT37q8DwM15YwBgkk3vo+czmCt/xJaQlPh/UNLFCmzAkyUMft2/Ps0+hTldGB5RgPMU9NJ1ceOiM9nwRlqvEKPm1n2X82DnP/UyJd/uDVWhQ== 201106@ppu.edu.ps'

sudo -u github sh -c "mkdir -p /home/app/.ssh && echo $github_pubkey > /home/app/.ssh/authorized_keys"

sudo reboot