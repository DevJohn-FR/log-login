        BOTNAME=John-SSH-Log
        AVATAR_URL="https://icons.iconarchive.com/icons/blackvariant/button-ui-system-apps/512/Terminal-icon.png"
        WEBHOOK="https://discord.com/api/webhooks/977275800573321306/j0rCIj67VRqhZM2zwErjgPWsX1VztRk5UEG-78foAIsZq6eU-2tD33gBfwrUMzXB5EB4"
        DATE=$(date +"%d-%m-%Y-%H:%M:%S")

        TMPFILE=$(mktemp)

    IP=`echo $SSH_CLIENT | awk '{ ip = $1 } END { print ip }'`

    curl -s "https://ipapi.co/${IP}/json/" > $TMPFILE


    ISP=`cat $TMPFILE | jq .org | sed s/' '//g | sed s/'"'//g`

    PAYS=`cat $TMPFILE | jq -r .country_name`

    VILLE=`cat $TMPFILE | jq -r .city`

    getCurrentTimestamp() { date -u --iso-8601=seconds; };

        curl -i --silent \
        -H "Accept: application/json" \
        -H "Content-Type:application/json" \
        -X POST \
        --data  '{
            "username": "'"$BOTNAME"'",
            "avatar_url": "'"$AVATAR_URL"'",
            "embeds": [{
                "color": black,
                "title": "Nouvelle connection",
                "thumbnail": { "url": "'"$AVATAR_URL"'" },
                "author": { "name": "'"$BOTNAME"'", "icon_url": "'"$AVATAR_URL"'" },
                "description": "**Détails**\n \\👤 Utilisateur: '\`$(whoami)\`' \n \\🖥️ Host: '\`$(hostname)\`' \n \\🕐 Connexion: '\`$DATE\`' \n\n **Adresse IP**\n \\📡 IP: '\`${IP}\`' \n \\🌎 Pays: '\`$PAYS\`' \n \\🏙️ Ville: '\`$VILLE\`' \n \\📠 ISP: '\`${ISP}\`'",
                "timestamp": "'$(getCurrentTimestamp)'"
            }]
        }' $WEBHOOK > /dev/null

checkdir() {
    if [ -e $TMPFILE ]; then
        rm -fr $TMPFILE
    else
        echo "le fichier $TMPFILE n'existe pas"
    fi
}
checkdir
