#!/bin/bash

# Get the file including IP addresses
read -p "IP adreslerini içeren dosyanın adını girin: " IP_FILE

# Check whether the file exist or not
if [[ ! -f "$IP_FILE" ]]; then
    echo "Hata: '$IP_FILE' bulunamadı!"
    exit 1
fi

# Provide user:pass for SMB user
USERNAME="Administrator"
PASSWORD="Password2025"

# Upload entire file to the array
mapfile -t IP_LIST < "$IP_FILE"

# Processing all subnets
for subnet in "${IP_LIST[@]}"; do
    [[ -z "$subnet" ]] && continue  # Boş satırları atla

    echo -e "\n[+] İşleniyor: $subnet"

    # Increased Timeout Delay (+60 seconds)
    timeout 120s crackmapexec smb "$subnet" -u "$USERNAME" -p "$PASSWORD" --local-auth || echo "[!] $subnet için işlem başarısız!"

    echo "[+] Bekleniyor... (10 saniye)"
    sleep 10
done

echo -e "\nİşlem tamamlandı!"
