#!/bin/bash
set -x  # Hata ayıklama modu

# Kullanıcıdan IP listesini içeren dosya adını al
read -p "IP adreslerini içeren dosyanın adını girin: " IP_FILE

# Dosyanın var olup olmadığını kontrol et
if [[ ! -f "$IP_FILE" ]]; then
    echo "Hata: '$IP_FILE' bulunamadı!"
    exit 1
fi

# Kullanıcı adı ve parola
USERNAME="Administrator"
PASSWORD="Aa123456789."

# Dosyanın tamamını bir diziye yükle
mapfile -t IP_LIST < "$IP_FILE"

# Tüm subnetleri sırayla işle
for subnet in "${IP_LIST[@]}"; do
    [[ -z "$subnet" ]] && continue  # Boş satırları atla

    echo -e "\n[+] İşleniyor: $subnet"

    # Anonim giriş denemesi
    echo "[+] Anonim erişim deneniyor: $subnet"
    timeout 120s netexec smb "$subnet" --shares || echo "[!] $subnet için anonim işlem başarısız!"

    # Paylaşım yetkilerini kontrol etme (smbmap kullanarak)
    echo "[+] SMB paylaşım yetkileri kontrol ediliyor: $subnet"
    smbmap -H "$subnet" -u "$USERNAME" -p "$PASSWORD"

    # Kullanıcı adı ve parola ile giriş denemesi
    echo "[+] Kimlik doğrulama ile erişim deneniyor: $subnet"
    timeout 120s netexec smb "$subnet" -u "$USERNAME" -p "$PASSWORD" --local-auth --shares || echo "[!] $subnet için kimlik doğrulama başarısız!"

    echo "[+] Bekleniyor... (1 saniye)"
    sleep 1
done

set +x  # Hata ayıklama modunu kapat

echo -e "\nİşlem tamamlandı!"
