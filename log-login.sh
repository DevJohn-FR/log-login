#!/bin/sh

#
# title             : ssh_notify
# description       : Notification lors d'une connexion ssh.
# author            : TutoRapide
# date              : 08-01-2021
# version           : 0.1.0
# usage             : placer dans /etc/profile.d/ssh-notify.sh
#===============================================================================

# Config {

        BOTNAME=John-SSH-Login #Nom du webhook
        AVATAR_URL="https://icons.iconarchive.com/icons/blackvariant/button-ui-system-apps/512/Terminal-icon.png"
        WEBHOOK="https://discord.com/api/webhooks/977275800573321306/j0rCIj67VRqhZM2zwErjgPWsX1VztRk5UEG-78foAIsZq6eU-2tD33gBfwrUMzXB5EB4"
        DATE=$(date +"%d-%m-%Y-%H:%M:%S") #Date + heure

        TMPFILE=$(mktemp) #Creation d'un fichier temporaire dans /tmp

#~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ }

    IP=`echo $SSH_CLIENT | awk '{ ip = $1 } END { print ip }'`

    curl -s "https://ipapi.co/${IP}/json/" > $TMPFILE

    #On recupére l'opérateur. On supprimer un espace {sed s/' '//g}  est ajoute les double quote {sed s/'"'//g}

    ISP=`cat $TMPFILE | jq .org | sed s/' '//g | sed s/'"'//g`

    #On recupére le pays
    PAYS=`cat $TMPFILE | jq -r .country_name`

    #On recupére la ville
    VILLE=`cat $TMPFILE | jq -r .city`

    # On récupère le timestamp actuel
    getCurrentTimestamp() { date -u --iso-8601=seconds; };

        curl -i --silent \
        -H "Accept: application/json" \
        -H "Content-Type:application/json" \
        -X POST \
        --data  '{
            "username": "'"$BOTNAME"'",
            "avatar_url": "'"$AVATAR_URL"'",
            "embeds": [{
                "color": 12976176,
                "thumbnail": { "url": "'"$AVATAR_URL"'" },
                "author": { "name": "Nouvelle connection", "icon_url": "'"$AVATAR_URL"'" },
                "description": "**Détails**\n \\👤 Utilisateur: '\`$(whoami)\`' \n \\🖥️ Host: '\`$(hostname)\`' \n \\🕐 Connexion: '\`$DATE\`' \n\n **Adresse IP**\n \\📡 IP: '\`${IP}\`' \n \\🌎 Pays: '\`$PAYS\`' \n \\🏙️ Ville: '\`$VILLE\`' \n \\📠 ISP: '\`${ISP}\`'",
                "timestamp": "'$(getCurrentTimestamp)'"
            }]
        }' $WEBHOOK > /dev/null

# On vient verifier que le fichier temporaire est bien présent puis on le supprime {

checkdir() {
    if [ -e $TMPFILE ]; then
        rm -fr $TMPFILE
    else
        echo "le fichier $TMPFILE n'existe pas"
    fi
}
checkdir

#~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ }
