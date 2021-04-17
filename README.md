# languagetool-installer-systemd

This script installs a LanguageTool server locally.
It additionnaly provides a systemd unit and a start script
to daemonize it or run it as user with custom parameters.

See INSTALL.md for installation

## TL;DR

```text
$ ./languagetool-installer-systemd.sh --help
This script must be run as root !
Usage:  [--port=<port>] [--allow-origin=<origin>] [--public] [--verbose] [--help|-h]
  --port=<port> : Change default port (default: 8081)
  --allow-origin: Change default allow-origin (default *)
                  To disable this option use --allow-origin=
  --public      : Set server public
  --verbose     : Enable verbose log for server (not for this script)
  --help -h     : Show this and exit
```
