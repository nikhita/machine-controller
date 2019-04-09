#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail


COREOS_IMAGE_NAME=${COREOS_IMAGE_NAME:-"machine-controller-coreos"}
UBUNTU_IMAGE_NAME=${UBUNTU_IMAGE_NAME:-"machine-controller-ubuntu"}
CENTOS_IMAGE_NAME=${CENTOS_IMAGE_NAME:-"machine-controller-centos"}

echo "Downloading Ubuntu 18.04 image from upstream..."
curl -L -o ubuntu.img http://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
echo "Uploading Ubuntu 18.04 image to OpenStack..."
openstack image create \
  --container-format bare \
  --disk-format qcow2 \
  --file ubuntu.img \
  ${UBUNTU_IMAGE_NAME}
rm ubuntu.img
echo "Successfully uploaded ${UBUNTU_IMAGE_NAME} to OpenStack..."

echo "Downloading CoreOS image from upstream..."
curl -L -o coreos.img.bz2 https://stable.release.core-os.net/amd64-usr/current/coreos_production_openstack_image.img.bz2
bunzip2 coreos.img.bz2
echo "Uploading CoreOS image to OpenStack..."
openstack image create \
  --container-format bare \
  --disk-format qcow2 \
  --file coreos.img \
  ${COREOS_IMAGE_NAME}
rm coreos.img
echo "Successfully uploaded ${COREOS_IMAGE_NAME} to OpenStack..."

echo "Downloading CentOS 7 image from upstream..."
curl -L -o centos.qcow2 http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
echo "Uploading CentOS 7 image to OpenStack..."
openstack image create \
  --disk-format qcow2 \
  --container-format bare \
  --file centos.qcow2 \
  ${CENTOS_IMAGE_NAME}
rm centos.qcow2
echo "Successfully uploaded ${CENTOS_IMAGE_NAME} to OpenStack..."
