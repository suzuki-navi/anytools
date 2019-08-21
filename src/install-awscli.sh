
[ -z "${python_version:-}" ] && . $MULANG_SOURCE_DIR/install-python.sh

install_awscli () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

version=last

####################################################################################################
# インストール
####################################################################################################

if [ $action = install -a ! -x "$PREFIX/awscli-${version}/bin/aws" ]; then (
    [ -z "${python_version:-}" ] && install_python last install
    [ -z "${python_version:-}" ] && . <(install_python last env)
    export WORKON_HOME=$PREFIX/.venv
    #export PIPENV_VENV_IN_PROJECT=1

    local tmppath="$PREFIX/awscli-${version}-tmp-$$"
    mkdir -p $tmppath

    mkdir -p $tmppath/anytools-awscli
    mkdir -p $tmppath/anytools-awscli/bin

    (
        echo "(cd $tmppath/anytools-awscli; pipenv install awscli)"
        cd $tmppath/anytools-awscli
        pipenv install awscli
    )

    (
        cd $tmppath/anytools-awscli
        echo '#!/bin/bash'
        echo "$(pipenv --venv)/bin/aws \"\$@\""
    ) > $tmppath/anytools-awscli/bin/aws
    chmod +x $tmppath/anytools-awscli/bin/aws

    echo mv "$tmppath/anytools-awscli" "$PREFIX/awscli-${version}"
    mv "$tmppath/anytools-awscli" "$PREFIX/awscli-${version}"

    rm -rf $tmppath
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    #[ -z "${python_version:-}" ] && install_python last env

    echo "export PATH=\"$PREFIX/awscli-${version}/bin:\$PATH\""
fi

####################################################################################################

}

