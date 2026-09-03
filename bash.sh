#!/bin/bash
set -e

DISK="/dev/nvme0n1"

echo "[1/4] Disk sıfırlanıyor ve GPT bölüm tablosu oluşturuluyor..."
parted -s "$DISK" mklabel gpt

echo "[2/4] 1 GB EFI ve kalan alan için Root bölümü ayrılıyor..."
parted -s "$DISK" mkpart "EFI" fat32 1MiB 1024MiB
parted -s "$DISK" set 1 esp on
parted -s "$DISK" mkpart "Root" ext4 1024MiB 100%

echo "[3/4] Bölümler biçimlendiriliyor (FAT32 & ext4)..."
mkfs.fat -F32 "${DISK}p1"
mkfs.ext4 -F "${DISK}p2"

echo "[4/4] Bölümler /mnt dizinine bağlanıyor (Mount)..."
mount "${DISK}p2" /mnt
mkdir -p /mnt/boot
mount "${DISK}p1" /mnt/boot

echo "--- Bölümleme İşlemi Tamamlandı! ---"
lsblk "$DISK"
