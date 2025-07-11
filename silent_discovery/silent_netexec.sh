#!/bin/bash

# Retrieve subnetlist from user
read -p "Subnet listesini içeren dosya adını girin: " SUBNET_FILE

# Dosya kontrolü
if [[ ! -f "$SUBNET_FILE" ]]; then
    echo "Hata: '$SUBNET_FILE' bulunamadı!"
    exit 1
fi

USERNAME="Administrator"
PASSWORD="Password1."

# Upload file to array
mapfile -t SUBNETS < "$SUBNET_FILE"

for subnet in "${SUBNETS[@]}"; do
    [[ -z "$subnet" ]] && continue
    echo -e "\n[+] Taranıyor: $subnet"

    timeout 180s netexec smb "$subnet" -u "$USERNAME" -p "$PASSWORD" --local-auth --shares || echo "[!] $subnet taraması başarısız oldu!"

    # Stealth mod: wait randomly between 3-10 seconds.
    SLEEP_TIME=$((RANDOM % 7 + 3))
    echo "[+] Bekleniyor... ($SLEEP_TIME saniye)"
    sleep "$SLEEP_TIME"
done

echo -e "\nTüm subnetler tarandı."
