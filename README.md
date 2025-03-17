# macOS DNS Setter

This is a simple tool to automatically set secure and privacy-focused DNS servers on macOS. It ensures your Mac consistently uses DNS servers you choose, automatically applying them whenever network interfaces change or connect.

## What it Does

- Automatically sets DNS servers to:

  - `185.228.168.168`
  - `185.228.169.168`

- Ensures settings persist across reboots and network changes.

## How to Install

1. **Download** or copy the `deploy_dns_setter.sh` script.

2. Open Terminal and navigate to the directory containing the script.

3. Run the script with administrative privileges:

   ```bash
   sudo bash deploy_dns_setter.sh
   ```

4. Enter your macOS administrator password when prompted.

That's it! The DNS settings will now be automatically enforced.

## Checking the Logs

DNS setting logs are stored at:

```bash
/var/log/dnssetter.log
```

You can check the logs by running:

```bash
cat /var/log/dnssetter.log
```

## Compatibility

- Tested on macOS.
- Should work on all recent macOS versions.

## Uninstallation

To uninstall, run:

```bash
sudo launchctl unload /Library/LaunchDaemons/com.custom.dnssetter.plist
sudo rm /Library/LaunchDaemons/com.custom.dnssetter.plist
sudo rm /usr/local/bin/set_dns.sh
```

---

Enjoy secure DNS browsing!
