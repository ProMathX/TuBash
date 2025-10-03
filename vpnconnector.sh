#!/usr/bin/env bash
set -euo pipefail

# Farben
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
NC="\e[0m"

buildver="0.0.5"
echo -e "${CYAN}version: $buildver${NC}"
echo
echo -e "${GREEN}░▀▀█▀▀░▒█░▒█░░░▒█░░▒█░▀█▀░▒█▀▀▀░▒█▄░▒█░░░▒█░░▒█░▒█▀▀█░▒█▄░▒█${NC}"
echo -e "${GREEN}░░▒█░░░▒█░▒█░░░▒█▒█▒█░▒█░░▒█▀▀▀░▒█▒█▒█░░░░▒█▒█░░▒█▄▄█░▒█▒█▒█${NC}"
echo -e "${GREEN}░░▒█░░░░▀▄▄▀░░░▒▀▄▀▄▀░▄█▄░▒█▄▄▄░▒█░░▀█░░░░░▀▄▀░░▒█░░░░▒█░░▀█${NC}"
echo

# Matrikelnummer
read -rp "[?] Bitte gib deine 8-stellige Matrikelnummer ein (z. B. 12345678): " matrikel
if [[ ! $matrikel =~ ^[0-9]{8}$ ]]; then
  echo -e "${RED}[!] Ungültige Matrikelnummer. Beenden.${NC}"
  exit 1
fi
VPN_USER="e${matrikel}@student.tuwien.ac.at"

# Auth-Gruppe
echo
echo -e "${CYAN}[?] Welche VPN-Gruppe möchtest du verwenden?${NC}"
echo "    1) 1_TU_getunnelt"
echo "    2) 2_Alles_getunnelt"
read -rp "Gib 1 oder 2 ein: " grp_choice

case "$grp_choice" in
  1) AUTHGROUP="1_TU_getunnelt" ;;
  2) AUTHGROUP="2_Alles_getunnelt" ;;
  *) echo -e "${RED}[!] Ungültige Wahl, Standard ist 2_Alles_getunnelt${NC}"; AUTHGROUP="2_Alles_getunnelt" ;;
esac

echo

# Spinner-Funktion
spinner() {
    local msg="$1"
    local delay=0.1
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0

    printf "%b" "${YELLOW}[*] $msg ${NC}"
    while true; do
        i=$(( (i+1) % ${#spin} ))
        printf "\b${CYAN}%s${NC}" "${spin:$i:1}"
        sleep "$delay"
    done
}

# Starte Spinner im Hintergrund
spinner "Verbindung wird vorbereitet" &
SPINNER_PID=$!

# Warten für Spinner-Effekt
sleep 2

# Spinner beenden
kill "$SPINNER_PID" >/dev/null 2>&1 || true
wait "$SPINNER_PID" 2>/dev/null || true
printf "\r%-60s\r" " "  # Zeile leeren

# Hinweis
echo -e "${YELLOW}[*] Starte VPN-Verbindung für ${CYAN}${VPN_USER}${NC} mit Gruppe ${CYAN}${AUTHGROUP}${NC}"
echo -e "${CYAN}Hinweis: Du wirst jetzt nach deinem TU-Passwort gefragt (E-Mail-Passwort).${NC}\n"

# openconnect im Vordergrund — wichtig für interaktive Passwort-Eingabe!
sudo openconnect \
  --user="$VPN_USER" \
  --authgroup="$AUTHGROUP" \
  vpn.tuwien.ac.at

status=$?

# Ergebnis anzeigen
if [[ $status -eq 0 ]]; then
  echo -e "\n${GREEN}[✓] VPN-Verbindung erfolgreich hergestellt.${NC}"
else
  echo -e "\n${RED}[✗] VPN-Verbindung fehlgeschlagen (Exit $status).${NC}"
  echo -e "${YELLOW}Mögliche Ursachen:${NC}"
  echo " • Falsches Passwort"
  echo " • Falsche VPN-Gruppe"
  echo " • Kein Zugriff auf VPN (Account-Problem)"
fi
