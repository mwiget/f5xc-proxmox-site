# Deploy F5 Distributed Cloud Site on Proxmox VE

Example Terraform scripts to deploy F5XC Appstack and Secure Mesh sites on Proxmox Virtual Environment.

## Requirements

### F5XC CE VM Template

Download the latest qcow2 image from https://docs.cloud.f5.com/docs/images/node-cert-hw-kvm-images manually 
via Browser or run [./download_ce_image.sh](download_ce_image.sh) directly on your Proxmox server, then
create a template from the download file on your Proxmox server, adjusting the full (!) path to the downloaded
qcow2 image, the template id and the Proxmox iso storage to save it:

```
#!/bin/bash
# adjust full path to downloaded qcow2 file, target template id and storage ...
qcow2=/root/rhel-9.2024.11-20240523024833.qcow2
id=9000
storage=cephpool

echo "resizing image to 50G ..."
qemu-img resize $qcow2 50G
echo "destroying existing VM $id (if present) ..."
qm destroy $id
echo "creating vm template $id from $image .."
qm create $id --memory 16384 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
qm set $id --name f5xc-ce-template
qm set $id --scsi0 $storage:0,import-from=$qcow2
qm set $id --boot order=scsi0
qm set $id --serial0 socket --vga serial0
qm template $id
```

## Create terraform.tfvars

Copy [terraform.tfvars.example](terraform.tfvars.example) to terraform.tvars and adjust accordingly.

## Deploy Site

Adjust the count variable in the following templates to pick how many App itack, single and dual nic Secure Mesh sites
to deploy:

- [appstack.tf](./appstack.tf)
- [securemesh-single-nic.tf](./securemesh-single-nic.tf)
- [securemesh-dual-nic.tf](./securemesh-dual-nic.tf) (requires 2nd network for inside interface. Example uses VLAN tag on VLAN aware default vmbr0)

Deploy with 

```
terraform init
terraform plan
terraform apply
```

Terraform will created the site(s) in your F5XC Tenant, clone and launch the VM(s), automatically accept the node(s)
registration request and wait for the site(s) to become ONLINE.

