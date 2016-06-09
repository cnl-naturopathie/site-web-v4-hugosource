#!/bin/bash

echo -e "\nVérifier l’adresse IP en cas de problème !!!\n"

case "$1" in

github)
    OUT_PATH="$HOME/Sites/cnl-naturopathie/site-web-v4/"
    # rm -rf $OUT_PATH # !! Ne pas effacer le répertoire .git !!
    echo "Génération des fichiers GitHub"
    hugo                                                                \
        --destination=$OUT_PATH                                         \
        --baseURL="http://cnl-naturopathie.ch/"
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
    IP=192.168.1.124
    hugo server                 \
        --baseURL="http://$IP/" \
        --bind=$IP              \
        --port=8080             \
        --appendPort=true       \
        --theme cnl-spirit
    ;;

esac

exit 0
