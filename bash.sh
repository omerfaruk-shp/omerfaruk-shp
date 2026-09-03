#!/bin/bash
set -e

# Renkli Çıktı Tanımları
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}   ARCH LINUX HIZLI KURULUM BETİĞİ      ${NC}"
echo -e "${BLUE}=========================================${NC}"

# 1. İşlemci Tespiti (Microcode Seçimi)
CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
UCODE=""

if [ "$CPU_VENDOR" == "GenuineIntel" ]; then
    echo -e "${GREEN}[+] Intel işlemci tespit edildi. 'intel-ucode' eklenecek.${NC}"
    UCODE="intel-ucode"
elif [ "$CPU_VENDOR" == "AuthenticAMD" ]; then
    echo -e "${GREEN}[+] AMD işlemci tespit edildi. 'amd-ucode' eklenecek.${NC}"
    UCODE="amd-ucode"
else
    echo -e "${YELLOW}[!] Bilinmeyen işlemci mimarisi. Microcode atlanıyor.${NC}"
fi

# 2. Temel Paketlerin Kurulması (Pacstrap)
echo -e "\n${BLUE}[1/3] Temel sistem ve paketler yükleniyor (pacstrap)...${NC}"
pacstrap -K /mnt base base-devel linux linux-firmware nano networkmanager sudo grub efibootmgr $UCODE

# 3. fstab Tablosunun Oluşturulması
echo -e "\n${BLUE}[2/3] Disk bağlama tablosu (fstab) oluşturuluyor...${NC}"
genfstab -U /mnt >> /mnt/etc/fstab

# 4. Saat Dilimi ve Zaman Ayarı (timedatectl)
echo -e "\n${BLUE}[3/3] Saat ve zaman senkronizasyonu yapılıyor...${NC}"
timedatectl set-ntp true || true

echo -e "\n${GREEN}=========================================${NC}"
echo -e "${GREEN}  TEMEL SİSTEM YÜKLEMESİ TAMAMLANDI!     ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo -e "Şimdi yeni sisteme geçmek için şu komutu çalıştırın:\n"
echo -e "   ${YELLOW}arch-chroot /mnt${NC}\n"
