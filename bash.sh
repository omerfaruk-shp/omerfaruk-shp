#!/bin/bash
set -e

# Renkli Çıktı Tanımları
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}   ARCH LINUX SİSTEM YAPILANDIRMASI     ${NC}"
echo -e "${BLUE}=========================================${NC}"

# 1. Saat Dilimi ve Zaman Ayarı
echo -e "\n${BLUE}[1/5] Saat dilimi Istanbul olarak ayarlanıyor...${NC}"
ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
hwclock --systohc

# 2. Hostname (Bilgisayar Adı)
echo -e "\n${BLUE}[2/5] Bilgisayar adı 'archlinux' olarak atanıyor...${NC}"
echo "archlinux" > /etc/hostname

# 3. GRUB Önyükleyici Kurulumu
echo -e "\n${BLUE}[3/5] GRUB önyükleyici kuruluyor ve yapılandırılıyor...${NC}"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# 4. İnternet Servisini Etkinleştirme
echo -e "\n${BLUE}[4/5] NetworkManager servisi etkinleştiriliyor...${NC}"
systemctl enable NetworkManager

# 5. Root Şifresi Belirleme
echo -e "\n${BLUE}[5/5] Root kullanıcısı için şifre belirleyin:${NC}"
echo -e "${YELLOW}Lütfen ekrana yazacağınız yeni şifrenizi girin:${NC}"
passwd

echo -e "\n${GREEN}=========================================${NC}"
echo -e "${GREEN}    YAPILANDIRMA BAŞARIYLA TAMAMLANDI!   ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo -e "Sistemden çıkıp yeniden başlatmak için sırasıyla şu komutları çalıştırın:\n"
echo -e "   1. ${YELLOW}exit${NC}"
echo -e "   2. ${YELLOW}umount -R /mnt${NC}"
echo -e "   3. ${YELLOW}reboot${NC}\n"
