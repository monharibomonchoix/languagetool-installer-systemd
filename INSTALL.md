# Install LanguageTool server

## Prequisite

Warning: Your system __MUST__ be configured with systemd, not sysV !

Before installing the server be sure to have these prequisites installed

- `sh` or `bash` (should be installed by default)
- `unzip`
- `wget`
- (optional) `git`
- openjava jvm (minimum version: 1.8)

You can run these commands to install prequisites

Debian based distribution (Ubuntu, Linux Mint):

```bash
sudo apt install unzip wget default-jre #add "git" if you want to use "git clone"
```

Redhat based distribution:

```bash
sudo dnf install unzip wget java-latest-openjdk.x86_64 #add "git" if you want to use "git clone"
# You can also install java-1.11.0-openjdk or java-1.8.0-openjdk instead of java-latest-openjdk.x86_64
```

## Install

To install using default options, use one of these scripts:

Git based installation:

```bash
git clone https://github.com/monharibomonchoix/languagetool-installer-systemd.git
cd languagetool-installer-systemd
sudo ./languagetool-installer-systemd.sh
```

Zip based installation:

```bash
wget "https://github.com/monharibomonchoix/languagetool-installer-systemd/archive/refs/heads/master.zip" -O master.zip
unzip master.zip
cd languagetool-installer-systemd
sudo ./languagetool-installer-systemd.sh
```

## Run as user

Run this script to start server using your defined options

```bash
/opt/languagetool/start.sh
```

## Run as service

Start the service:

```bash
sudo systemctl start languagetool.service
```

Enable the service on startup:

```bash
sudo systemctl enable languagetool.service
```

You can enable and start the service in one command:

```bash
sudo systemctl enable --now languagetool.service
```

## Script options

There are 2 options you can change when installing the script:

```text
This script must be run as root!
Usage:  [--port=<port>] [--allow-origin=<origin>] [--help|-h]
  --port=<port> : Change default port (default: 8081)
  --allow-origin: Change default allow-origin (default *)
                  To disable this option use --allow-origin=
  --help -h     : Show this and exit
```
