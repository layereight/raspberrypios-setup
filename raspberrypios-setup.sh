#!/usr/bin/env sh

set -e

ZIPPED_IMAGE="${1}"
HOSTNAME="${2}"
WORK_DIR=$(dirname "${ZIPPED_IMAGE}")
IMAGE_FILE=$(basename "${ZIPPED_IMAGE}")
IMAGE_FILE=$(basename "${IMAGE_FILE}" .xz)

echo "Zipped image: ${ZIPPED_IMAGE}"
echo "Working directory: ${WORK_DIR}"

echo "Unzipping..."
xz -k -f -vv -d "${ZIPPED_IMAGE}"
echo "Unzipped image file: ${WORK_DIR}/${IMAGE_FILE}"

FDISK=$(fdisk -l "${WORK_DIR}/${IMAGE_FILE}")

#
# retrieve image sector size
#
SECTOR_SIZE=$(echo "${FDISK}" | grep "Units" | cut -d " " -f 8)
echo "Image sector size: ${SECTOR_SIZE} bytes"

#
# find partition start points
#
BOOT_PARTITION_START=$(echo "${FDISK}" | tr -s " " | grep "${IMAGE_FILE}1" | cut -d " " -f 2)
BOOT_PARTITION_START=$((BOOT_PARTITION_START * SECTOR_SIZE))
ROOT_PARTITION_START=$(echo "${FDISK}" | tr -s " " | grep "${IMAGE_FILE}2" | cut -d " " -f 2)
ROOT_PARTITION_START=$((ROOT_PARTITION_START * SECTOR_SIZE))
echo "Boot partition start at: ${BOOT_PARTITION_START} bytes"
echo "Root partition start at: ${ROOT_PARTITION_START} bytes"

#
# create temp dir for mounting partitions of the image
#
MOUNT_DIR=$(mktemp -d)
echo "Temp image mounting directory: ${MOUNT_DIR}"

#
# touch ssh in boot partition
#
sudo mount -o offset=${BOOT_PARTITION_START} "${WORK_DIR}/${IMAGE_FILE}" "${MOUNT_DIR}"
echo "Create /ssh in boot partition"
sudo touch "${MOUNT_DIR}/ssh"
sudo umount "${MOUNT_DIR}"

#
# change hostname on filesystem
#
sudo mount -o offset=${ROOT_PARTITION_START} "${WORK_DIR}/${IMAGE_FILE}" "${MOUNT_DIR}"
echo "${HOSTNAME}" | sudo tee "${MOUNT_DIR}/etc/hostname" > /dev/null
sudo sed -i "s/raspberrypi/${HOSTNAME}/g" "${MOUNT_DIR}/etc/hosts"
echo
echo "Contents of /etc/hostname in root partition:"
cat "${MOUNT_DIR}/etc/hostname"
echo
echo "Contents of /etc/hosts in root partition:"
cat "${MOUNT_DIR}/etc/hosts"
sudo umount "${MOUNT_DIR}"

echo
echo "DONE. Your prepared image file is in ${WORK_DIR}/${IMAGE_FILE}"
