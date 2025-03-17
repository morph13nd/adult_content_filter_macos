#!/bin/bash

# Ensure running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

# Backup /usr/local/bin if it's incorrectly a file instead of a directory
if [ -f /usr/local/bin ]; then
    echo "/usr/local/bin is a file, moving to /usr/local/bin.backup"
    mv /usr/local/bin /usr/local/bin.backup
fi

# Ensure /usr/local/bin directory exists
mkdir -p /usr/local/bin

# Create the DNS-setting script
cat << 'EOF' > /usr/local/bin/set_dns.sh
#!/bin/bash
sleep 2
for i in $(networksetup -listallnetworkservices | grep -v "*"); do
    networksetup -setdnsservers "$i" 185.228.168.168 185.228.169.168
done
EOF

# Make the script executable
chmod +x /usr/local/bin/set_dns.sh

# Create LaunchDaemon plist
cat << 'EOF' > /Library/LaunchDaemons/com.custom.dnssetter.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.custom.dnssetter</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/usr/local/bin/set_dns.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>WatchPaths</key>
    <array>
        <string>/Library/Preferences/SystemConfiguration/NetworkInterfaces.plist</string>
        <string>/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist</string>
    </array>
    <key>StandardOutPath</key>
    <string>/var/log/dnssetter.log</string>
    <key>StandardErrorPath</key>
    <string>/var/log/dnssetter.log</string>
</dict>
</plist>
EOF

# Set permissions for LaunchDaemon plist
chmod 644 /Library/LaunchDaemons/com.custom.dnssetter.plist

# Load LaunchDaemon
launchctl load -w /Library/LaunchDaemons/com.custom.dnssetter.plist

echo "DNS Setter deployment complete."
