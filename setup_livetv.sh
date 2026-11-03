#!/bin/bash
# 🛰️ One-Click Live TV Setup for Jio STB (FreeView-IPTV)
# Automatically installs TiviMate & provisions 500+ Indian & Malayalam Live TV playlists

set -e

STB_IP="${1:-192.168.28.36}"
ADB_CMD="adb -s $STB_IP:5555"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================================="
echo "  🛰️ FreeView-IPTV: Live TV Provisioning Tool"
echo "=========================================================="

echo "[*] Connecting to STB at $STB_IP:5555..."
adb connect "$STB_IP:5555" || true

echo "[*] 1. Checking / Installing TiviMate IPTV Player..."
if ! $ADB_CMD shell pm list packages | grep -q 'ar.tvplayer.tv'; then
    echo "[-] Downloading latest TiviMate APK..."
    curl -sL -o /tmp/tivimate.apk "https://files.tivimate.com/tivimate.apk"
    echo "[-] Installing TiviMate on STB..."
    $ADB_CMD install -r /tmp/tivimate.apk
else
    echo "[+] TiviMate is already installed on device."
fi

echo "[*] 2. Pushing Curated Playlists to STB Storage (/sdcard/)..."
$ADB_CMD push "$SCRIPT_DIR/playlists/malayalam_tv.m3u" /sdcard/malayalam_tv.m3u
$ADB_CMD push "$SCRIPT_DIR/playlists/india_tv.m3u" /sdcard/india_tv.m3u

echo "=========================================================="
echo "  [+] SUCCESS! Live TV Provisioning Complete."
echo ""
echo "  How to watch on your TV:"
echo "  1. Open TiviMate on your STB"
echo "  2. Click 'Add Playlist' -> 'M3U playlist'"
echo "  3. Choose 'Select local playlist' -> Select:"
echo "     📁 /sdcard/malayalam_tv.m3u  (Malayalam Live TV)"
echo "     📁 /sdcard/india_tv.m3u      (500+ All-India Channels)"
echo "  4. Click Next -> Done!"
echo "=========================================================="
