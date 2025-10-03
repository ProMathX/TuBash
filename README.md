# TU Wien VPN Connector (Bash Script)

Ein einfaches Bash-Skript zur Verbindung mit dem VPN der TU Wien über OpenConnect.

---

## Hinweise

- Falls es Probleme mit L2TP-Verbindungen gibt, kann statt `vpn.tuwien.ac.at` auch die IPv4-Adresse `128.131.240.4` verwendet werden.
- Das Skript nutzt OpenConnect in Verbindung mit dem NetworkManager unter Linux.

---

## Voraussetzungen

Die OpenConnect-Erweiterung für den NetworkManager muss installiert sein.

### Installation je nach Distribution

**Debian based:**
```bash
sudo apt install openconnect network-manager-openconnect network-manager-openconnect-gnome
```
**Fedora:**
```bash
sudo dnf install openconnect NetworkManager-openconnect plasma-nm-openconnect -y
```
**Arch:**
```bash
sudo pacman -S networkmanager-openconnect openconnect webkit2gtk-4.1 gcr
```
**Gentoo:**
```bash
sudo emerge -av net-vpn/openconnect net-vpn/networkmanager-openconnect net-libs/webkit-gtk gnome-extra/nm-applet
```
**NixOS:**
```bash
nix-env -iA nixos.openconnect
nix-env -iA nixos.networkmanager-openconnect
nix-env -iA nixos.webkitgtk_6_0
```
[Quelle](https://wiki.fsinf.at/wiki/TU-VPN)
