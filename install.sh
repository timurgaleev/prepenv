#!/bin/bash

USERNAME="timurgaleev"
REPONAME="prepenv"

VERSION=${1}

################################################################################

command -v tput > /dev/null && TPUT=true

_echo() {
    if [ "${TPUT}" != "" ] && [ "$2" != "" ]; then
        echo -e "$(tput setaf $2)$1$(tput sgr0)"
    else
        echo -e "$1"
    fi
}

_result() {
    _echo "# $@" 4
}

_success() {
    _echo "+ $@" 2
    exit 0
}

_error() {
    _echo "- $@" 1
    exit 1
}

################################################################################

_prepare() {
    mkdir -p ~/.aws
    mkdir -p ~/.ssh

    # ssh config
    if [ ! -f ~/.ssh/config ]; then
cat <<EOF > ~/.ssh/config
Host *
    StrictHostKeyChecking no
EOF
    fi
    chmod 400 ~/.ssh/config
}

_install() {
    if [ -z ${VERSION} ]; then
        VERSION=$(curl -s https://api.github.com/repos/${USERNAME}/${REPONAME}/releases/latest | grep tag_name | cut -d'"' -f4)

    fi

    _result "version: ${VERSION}"

    if [ -z "${VERSION}" ]; then
        _error "Version not Found."
    fi

    # prepenv
    DIST=/tmp/prepenv-${VERSION}
    rm -rf ${DIST}

    # download
    curl -sL -o ${DIST} https://github.com/${USERNAME}/${REPONAME}/releases/download/${VERSION}/prepenv
    chmod +x ${DIST}

    # copy
    COPY_PATH=/usr/local/bin
    if [ ! -z "$HOME" ]; then
        COUNT=$(echo "$PATH" | grep "$HOME/.local/bin" | wc -l | xargs)
        if [ "x${COUNT}" != "x0" ]; then
            COPY_PATH=$HOME/.local/bin
        else
            COUNT=$(echo "$PATH" | grep "$HOME/bin" | wc -l | xargs)
            if [ "x${COUNT}" != "x0" ]; then
                COPY_PATH=$HOME/bin
            fi
        fi
    fi

    mkdir -p ${COPY_PATH}
    mv -f ${DIST} ${COPY_PATH}/prepenv
}

_aliases() {
    TARGET=${HOME}/${1}

    ALIASES="${HOME}/.prepenv_aliases"

    curl -sL -o ${ALIASES} https://github.com/${USERNAME}/${REPONAME}/releases/download/${VERSION}/aliases

    if [ -f "${ALIASES}" ]; then
        touch ${TARGET}
        HAS_ALIAS="$(cat ${TARGET} | grep prepenv_aliases | wc -l | xargs)"

        if [ "x${HAS_ALIAS}" == "x0" ]; then
            echo "if [ -f ~/.prepenv_aliases ]; then" >> ${TARGET}
            echo "  source ~/.prepenv_aliases" >> ${TARGET}
            echo "fi" >> ${TARGET}
            echo "" >> ${TARGET}
            echo "if [ -d /opt/homebrew/bin ]; then" >> ${TARGET}
            echo "  export PATH=\"/opt/homebrew/bin:$PATH\"" >> ${TARGET}
            echo "fi" >> ${TARGET}
        fi

        source ${ALIASES}
    fi
}

################################################################################

_prepare

_install

_aliases ".bashrc"
_aliases ".zshrc"
