#! /bin/bash
# Script by Joel Cressy (https://github.com/jtcressy)
if [ "$2" = "private" ]
then
    private="true"
else
    private="false"
fi
postdata='{"name":"'$1'", "private": '$private' }'
GITHUB_TOKEN_FILE=~/.ssh/github_token
if [ -f $GITHUB_TOKEN_FILE ]; then
    JSON=$(curl -s \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -H "Authorization: token $(cat $GITHUB_TOKEN_FILE)" \
        -X POST --data "$postdata" "https://api.github.com/user/repos")
    error=$(echo $JSON | grep error)
    if [ "$error" = "" ]; then
        ssh_url=$(echo $JSON | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["ssh_url"]')
        full_name=$(echo $JSON | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["full_name"]')
        html_url=$(echo $JSON | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["html_url"]')
        private=$(echo $JSON | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["private"]')
        git clone $ssh_url
        cd $1
        echo "New Repo Name: " $full_name
        echo "Private: " $private
        echo "Web Address: " $html_url
    else
    message=$(echo $JSON | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["errors"][0]["message"]')
    echo $message
    fi
else
    echo "Error: No github auth token."
    echo "Go to https://github.com/settings/tokens and generate a new token and place it in $GITHUB_TOKEN_FILE"
    echo "e.g. $ echo 'API_TOKEN' > $GITHUB_TOKEN_FILE"
    echo "Replace API_TOKEN with your actual API Token."
fi
