#!/bin/bash

# Get default route interface
if=$(route -n get 0.0.0.0 2>/dev/null | awk '/interface: / {print $2}')
if [ -n "$if" ]; then
    echo "Default route is through interface $if"
else
    echo "No default route found"
fi

# Get IP of the default route interface
IP=$( ipconfig getifaddr $if )

# Find an available port
PORTMIN=8000
PORTMAX=8009
PORT=$PORTMIN
while true; do
    PORTINUSE=$( lsof -i tcp:$PORT )
    if [ -z "$PORTINUSE" ]; then
        break;
    fi
    echo "$IP:$PORT already in use"

    PORT=$((PORT+1))
    if [ "$PORT" -gt "$PORTMAX" ]; then
        echo "No available port found between $PORTMIN and $PORTMAX."
        exit 1
    fi
done


# Main
case "$1" in

github)
    OUT_PATH="$HOME/Sites/cnl-naturopathie/site-web-v4/"
    # rm -rf $OUT_PATH # !! Ne pas effacer le répertoire .git !!
    echo "Génération des fichiers GitHub"

    pushd $OUT_PATH
    git rm -rf "*"
    popd

    hugo                                                                \
        --destination=$OUT_PATH                                         \
        --baseURL="https://cnl-naturopathie.ch/"

    pushd $OUT_PATH
    find . -name "*" -size 0 -not -path "./.git/*" -delete
    popd

    cp README.md $OUT_PATH
    if [ -z "$2" ]

    then
        echo "##########"
        echo "site généré à $OUT_PATH"
        COMMENT="Pas de commit sans commentaires !"

    else
        COMMENT=$2
        echo -e "\n### Mise à jour du dépôt “site-web-v4-hugosource”"
        git add .
        git commit -m "$COMMENT"
        git push
        echo -e "\n### Mise à jour du dépôt “site-web-v4”"
        cd $OUT_PATH
        git add .
        git commit -m "$COMMENT"
        git push
    fi
    echo -e "\n### COMMENTAIRE = $COMMENT"
    ;;

hostpapa)
    OUT_PATH="$HOME/Sites/cnl-naturopathie/cnl-spirit-hostpapa/"
    rm -rf $OUT_PATH
    echo "Génération des fichiers Hostpapa"
    hugo                                                                \
        --destination=$OUT_PATH                                         \
        --baseURL="http://pausenaturo.com/cnl-spirit/"
    ;;

s3)
    OUT_PATH="$HOME/Sites/cnl-naturopathie/cnl-spirit-s3/"
    rm -rf $OUT_PATH
    echo "Génération des fichiers S3"
    hugo                                                                \
        --destination=$OUT_PATH                                         \
        --baseURL="http://nicocnl.s3-website-eu-west-1.amazonaws.com/"
    ;;

fenix)
    OUT_PATH="$HOME/Sites/cnl-naturopathie/cnl-spirit-github/"
    hugo                                        \
        --baseURL="http://192.168.1.124:8080/"  \
        --theme cnl-spirit                      \
        --destination=$OUT_PATH
    ;;

*)
    echo "IP = $IP"
    echo "PORT = $PORT"
    hugo server                 \
        --baseURL="http://$IP/" \
        --bind=$IP              \
        --port=$PORT            \
        --appendPort=true       \
        --theme cnl-spirit
    ;;

esac

exit 0
