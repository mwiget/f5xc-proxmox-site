#!/bin/bash
# adjust path to downloaded qcow2 file, target template id and storage ...
qcow2=./rhel-9.2024.11-20240523024833.qcow2
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
#qm set $id --ide2 local-lvm:cloudinit # to be created via terraform ...
qm set $id --serial0 socket --vga serial0
qm template $id
