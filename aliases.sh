#!/bin/bash

alias pe='prepenv'
alias peu='pe update'
alias pet='pe tools'

c() {
    prepenv cdw ${1}
    if [ -f /tmp/prepenv-temp-result ]; then
        cd $(cat /tmp/prepenv-temp-result)
    fi
}

alias e='prepenv env'
alias n='prepenv git'
alias s='prepenv ssh'
alias x='prepenv ctx'
alias v='prepenv vsc'

alias a='aws'
alias k='kubectl'
alias h='helm'

alias av='aws-vault'

alias tf='terraform'
alias tfp='tf init && tf plan'
alias tfa='tf init && tf apply'
alias tfd='tf init && tf destroy'
alias tff='tf fmt'
alias tfg='tf graph'
alias tfo='tf output'
alias tfc='rm -rf .terraform && tf init'

alias p='reveal-md -w --port 8888 --theme night'

alias chrome="/Applications/Google\\ \\Chrome.app/Contents/MacOS/Google\\ \\Chrome"

alias py='python'
alias py3='python3'

alias ec2="aws ec2 describe-instances --query ‘Reservations[*].Instances[*].[Tags[?Key==\`Name\`].Value|[0],State.Name,PrivateIpAddress,PublicIpAddress]' --output text | column -t | sort -h"

alias m='mc -b'