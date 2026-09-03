#!/bin/bash
set -e

# Renkli Çıktı Tanımları
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}   KULLANICI VE MASAÜSTÜ KURULUM BETİĞİ ${NC}"
echo -e "${BLUE}=========================================${NC}"

# 1. Kullanıcı Oluşturma
echo -e "\n${BLUE}[1/3] Yeni Kullanıcı Hesabı Oluşturma${NC}"
read -p "Oluşturmak istediğiniz kullanıcı adını girin: " USERNAME

if id "$USERNAME" &>/dev/null; then
    echo -e "${YELLOW}[!] '$USERNAME' kullanıcısı zaten mevcut.${NC}"
else
    useradd -m -G wheel -s /bin/bash "$USERNAME"
    echo -e "${GREEN}[+] '$USERNAME' kullanıcısı oluşturuldu.${NC}"
    echo -e "${YELLOW}Kullanıcı için bir şifre belirleyin:${NC}"
    passwd "$USERNAME"
fi

# 2. Sudo Yetkisi Aktifleştirme (%wheel)
echo -e "\n${BLUE}[2/3] Sudo Yetkisi Etkinleştiriliyor...${NC}"
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
echo -e "${GREEN}[+] Sudo grubuna (wheel) tam yetki verildi.${NC}"

# 3. Masaüstü Ortamı Seçimi
echo -e "\n${BLUE}[3/3] Masaüstü Ortamı Seçimi${NC}"
echo "1) GNOME (Modern, Şık, Sade)"
echo "2) KDE Plasma (Özelleştirilebilir, Windows Benzeri)"
echo "3) Xfce (Hafif, Çok Hızlı, Düşük Kaynak Tüketimi)"
echo "4) Masaüstü ortamı kurma (Sadece CLI olarak bırak)"

read -p "Seçiminiz (1-4): " CHOICE

case $CHOICE in
    1)
        echo -e "\n${BLUE}[+] GNOME kuruluyor...${NC}"
        pacman -S --noconfirm gnome gnome-extra gdm
        systemctl enable gdm
        ;;
    2)
        echo -e "\n${BLUE}[+] KDE Plasma kuruluyor...${NC}"
        pacman -S --noconfirm plasma kde-applications sddm
        systemctl enable sddm
        ;;
    3)
        echo -e "\n${BLUE}[+] Xfce4 kuruluyor...${NC}"
        pacman -S --noconfirm xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
        systemctl enable lightdm
        ;;
    4)
        echo -e "\n${YELLOW}[!] Masaüstü ortamı kurulumu atlandı.${NC}"
        ;;
    *)
        echo -e "\n${YELLOW}[!] Geçersiz seçim yapıldı. Masaüstü ortamı atlanıyor.${NC}"
        ;;
esac

echo -e "\n${GREEN}=========================================${NC}"
echo -e "${GREEN}      KURULUM BAŞARIYLA TAMAMLANDI!      ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo -e "Sistemi yeniden başlatıp masaüstüne geçmek için şu komutu çalıştırın:\n"
echo -e "   ${YELLOW}reboot${NC}\n"
