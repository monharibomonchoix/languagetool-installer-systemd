#!/bin/env sh
set -e
function _usage()
{
    echo "This script must be run as root!"
    echo "Usage: $SCRIPT_NAME [--port=<port>] [--allow-origin=<origin>] [--help|-h]"
    echo "  --port=<port> : Change default port (default: 8081)"
    echo "  --allow-origin: Change default allow-origin (default *)"
    echo "                  To disable this option use --allow-origin="
    echo "  --help -h     : Show this and exit"
}

function usage()
{
    _usage >&2
}

function is_port()
{
    case "$1" in
        ''|*[!0-9]*)
            echo 1
            ;;
        *)
            if [[ "$1" -gt 65535 ]]
            then
                echo 1
            else
                echo 0
            fi
            ;;
    esac
}

function install()
{
    local TEMP_DIR="$(mktemp -d)"
    local DEST_DIR="/opt/languagetool"
    local SYSTEMD_FILE="/etc/systemd/system/languagetool.service"
    echo "Downloading latest LanguageTool.zip"
    wget "https://languagetool.org/download/LanguageTool-stable.zip" -O "$TEMP_DIR/LanguageTool-stable.zip"  -q --show-progress || true
    if [[ ! -f "$TEMP_DIR/LanguageTool-stable.zip" ]]
    then
        echo "Error downloading LanguageTool-stable.zip"
        exit 3
    fi
    echo "Downloading OK"
    echo "Unzipping (no progress)"
    rm -rf "$DEST_DIR"
    mkdir "$DEST_DIR"
    unzip -q "$TEMP_DIR/LanguageTool-stable.zip" -d "$DEST_DIR"
    echo "Unzip done"
    echo "Copying system files"
    rm -rf "$TEMP_DIR"
    cp start.sh "$DEST_DIR"
    chmod a+x "$DEST_DIR/start.sh"
    cp languagetool.service "$SYSTEMD_FILE"
    systemctl daemon-reload
    echo "System files copied"
}

function set_params()
{
    echo "Creating params file"
    local PORT="$1"
    local ALLOW_ORIGIN="\"$(echo "$2" | sed 's/"/\\"/g')\""

    echo "PORT=$PORT" > "$3"
    echo "ALLOW_ORIGIN=$ALLOW_ORIGIN" >> $3
    echo "Param file created"
}

function main()
{
    local PORT=8081
    local ALLOW_ORIGIN='"*"'
    local PARAM_FILE="/opt/languagetool/params"
    if [[ -f "$PARAM_FILE" ]]
    then
        . /opt/languagetool/params
    fi

    while [[ ! -z "$1" ]]
    do
        case "$1" in
            --port=*)
                if [[ "$(is_port "${1/--port=/}")" -ne 0 ]]
                then
                    echo "Port is invalid" >&2
                    usage
                    exit 2
                fi
                PORT="${1/--port=/}"
                ;;
            --allow-origin=*)
                ALLOW_ORIGIN="${1/--allow-origin=/}"
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                usage
                exit 1
                ;;
        esac
        shift
    done

    install
    set_params "$PORT" "$ALLOW_ORIGIN" "$PARAM_FILE"
}

if [[ ($(id -u) -ne 0) ]]
then
  usage
  exit 1
fi

SCRIPT_NAME="$(basename "$0")"

main "$@"