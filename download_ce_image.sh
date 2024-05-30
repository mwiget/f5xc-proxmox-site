#!/bin/bash
image=$(curl -s https://docs.cloud.f5.com/docs/images/node-cert-hw-kvm-images|grep qcow2\"| cut -d\" -f2)
if test -z $image; then
  echo "can't find qcow2 image from download url. Check https://docs.cloud.f5.com/docs/images/node-cert-hw-kvm-images"
  exit 1
fi
if ! -f $image; then
  echo "downloading $image ..."
  wget $image
fi
