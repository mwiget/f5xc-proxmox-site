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

## Example multi-node App Stack Site

Setting master_node_count=3 and worker_node_count=10 in appstack.tf, then deploy with `terraform apply`. 

Once complete, kubeconfig file <cluster-name>.kubeconfig gets created. The helper script [env.sh](./env.sh) can be 
sourced in a shell to populate the env variable KUBECONFIG:

```
. . .
Apply complete! Resources: 45 added, 0 changed, 0 destroyed.

Outputs:

proxmox = <sensitive>
(base) m1:f5xc-proxmox-site mwiget$ source env.sh
(base) m1:f5xc-proxmox-site mwiget$ k get nodes -o wide
NAME               STATUS   ROLES        AGE     VERSION       INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                                      KERNEL-VERSION                 CONTAINER-RUNTIME
mw-appstack-0-m0   Ready    ves-master   28m     v1.29.2-ves   192.168.42.68   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-m1   Ready    ves-master   28m     v1.29.2-ves   192.168.42.69   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-m2   Ready    ves-master   28m     v1.29.2-ves   192.168.42.70   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-w0   Ready    <none>       5m26s   v1.29.2-ves   192.168.42.73   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-w1   Ready    <none>       5m42s   v1.29.2-ves   192.168.42.75   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-w2   Ready    <none>       5m6s    v1.29.2-ves   192.168.42.67   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-w3   Ready    <none>       5m8s    v1.29.2-ves   192.168.42.78   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-w4   Ready    <none>       5m9s    v1.29.2-ves   192.168.42.77   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-w5   Ready    <none>       5m10s   v1.29.2-ves   192.168.42.71   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-w6   Ready    <none>       5m12s   v1.29.2-ves   192.168.42.72   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-w7   Ready    <none>       5m11s   v1.29.2-ves   192.168.42.76   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-w8   Ready    <none>       4m59s   v1.29.2-ves   192.168.42.79   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
mw-appstack-0-w9   Ready    <none>       4m41s   v1.29.2-ves   192.168.42.74   <none>        Red Hat Enterprise Linux 9.2024.11.4 (Plow)   5.14.0-427.16.1.el9_4.x86_64   cri-o://1.26.5-5.ves1.el9
```

[Lab Example with 3-node Secure Mesh site securing multi-node App Stack Cluster](lab-firewall/)
