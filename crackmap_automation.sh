#!/bin/bash

# Kullanıcıdan IP listesini içeren dosya adını al
read -p "IP adreslerini içeren dosyanın adını girin: " IP_FILE

# Dosyanın var olup olmadığını kontrol et
if [[ ! -f "$IP_FILE" ]]; then
    echo "Hata: '$IP_FILE' bulunamadı!"
    exit 1
fi

# Kullanıcı adı ve parola
USERNAME="Administrator"
PASSWORD=""

# Dosyanın tamamını bir diziye yükle
mapfile -t IP_LIST < "$IP_FILE"

# Tüm subnetleri sırayla işle
for subnet in "${IP_LIST[@]}"; do
    [[ -z "$subnet" ]] && continue  # Boş satırları atla

    echo -e "\n[+] İşleniyor: $subnet"

    # Timeout süresi artırıldı (60 saniye)
    timeout 120s crackmapexec smb "$subnet" -u "$USERNAME" -p "$PASSWORD" --local-auth || echo "[!] $subnet için işlem başarısız!"

    echo "[+] Bekleniyor... (1 saniye)"
    sleep 1
done

echo -e "\nİşlem tamamlandı!"
