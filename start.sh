#!/bin/env bash

function main()
{
    local PORT
    local ALLOW_ORIGIN
    local ALLOW_ORIGIN_OPTION
    local CONFIG_OPTION
    local CONFIG
    local PUBLIC_OPTION
    local PUBLIC
    local VERBOSE
    local DIR
    local VERBOSE
    local WORD2VEC_OPTION
    local WORD2VEC

    if [[ ! -f "/etc/languagetool/params" ]]
    then
        echo "Missing params file" >&2
        exit 1
    fi

    . /etc/languagetool/params
    if [[ -z "$PORT" ]]
    then
        echo "Port is missing"
        exit 2
    fi

    if [[ -n "$ALLOW_ORIGIN" ]]
    then
        ALLOW_ORIGIN_OPTION="--allow-origin"
        ALLOW_ORIGIN="\"$ALLOW_ORIGIN\""
    fi

    if [[ -f "/etc/languagetool/languagetool.conf" ]]
    then
        CONFIG_OPTION="--config"
        CONFIG="/etc/languagetool/languagetool.conf"
    fi

    if [[ "$PUBLIC" -eq 1 ]]
    then
        PUBLIC_OPTION="--public"
    fi

    if [[ "$VERBOSE" -eq 1 ]]
    then
        VERBOSE_OPTION="--verbose"
    fi

    if [[ "$(ls -1 /var/lib/languagetool/word2vec 2>/dev/null | wc -l)" -gt 0 ]]
    then
        WORD2VEC_OPTION="--word2vecModel"
        WORD2VEC="/var/lib/languagetool/word2vec"
    fi

    if [[ "$(ls -1 /var/lib/languagetool/ngrams 2>/dev/null | wc -l)" -gt 0 ]]
    then
        LANGUAGEMODEL_OPTION="--languageModel"
        LANGUAGEMODEL="/var/lib/languagetool/ngrams"
    fi

    DIR="$(ls -rd /opt/languagetool/LanguageTool* | head -n 1)"

    eval java -cp "$DIR/languagetool-server.jar" org.languagetool.server.HTTPServer \
    --port "$PORT" \
    "$ALLOW_ORIGIN_OPTION" "$ALLOW_ORIGIN" \
    "$CONFIG_OPTION" "$CONFIG" \
    "$PUBLIC_OPTION" \
    "$VERBOSE_OPTION" \
    "$WORD2VEC_OPTION" "$WORD2VEC" \
    "$LANGUAGEMODEL_OPTION" "$LANGUAGEMODEL"
}

main