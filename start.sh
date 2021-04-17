#!/bin/bash
if [[ ! -f "/opt/languagetool/params" ]]
then
    echo "Missing params file" >&2
    exit 1
fi

. /opt/languagetool/params
if [[ -z "$PORT" ]]
then
    echo "Port is missing"
    exit 2
fi

if [[ -n "$ALLOW_ORIGIN" ]]
then
    ALLOW_ORIGIN_OPTION="--allow-origin"
fi

DIR="$(ls -rd /opt/languagetool/LanguageTool* | head -n 1)"

java -cp "$DIR/languagetool-server.jar" org.languagetool.server.HTTPServer --port "$PORT" "$ALLOW_ORIGIN_OPTION" "$ALLOW_ORIGIN"
