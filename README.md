# Windows VM

### Build Docker Image
```bash
DOCKER_BUILDKIT=1 docker build --build-arg UID="$(id -u)" --build-arg GID="$(id -g)" --build-arg USER=$USER -t windows_vm_builder -f Dockerfile .
```

## Install Packer
```bash
wget https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer
```

## Examples
```bash
git clone git@github.com:devopsjourney1/packer-windows.git
```
