
[ -z "${python_version:-}" ] && . $MULANG_SOURCE_DIR/install-python.sh

install_jupyter () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

version=last

####################################################################################################
# インストール
####################################################################################################

if [ $action = install -a ! -x "$PREFIX/jupyter-${version}/bin/jupyter" ]; then (
    [ -z "${python_version:-}" ] && install_python last install
    [ -z "${python_version:-}" ] && . <(install_python last env)
    export WORKON_HOME=$PREFIX/.venv
    #export PIPENV_VENV_IN_PROJECT=1

    local tmppath="$PREFIX/jupyter-${version}-tmp-$$"
    mkdir -p $tmppath

    mkdir -p $tmppath/anytools-jupyter
    mkdir -p $tmppath/anytools-jupyter/bin

    (
        echo "(cd $tmppath/anytools-jupyter; pipenv install jupyter)"
        cd $tmppath/anytools-jupyter
        pipenv install jupyter
    )

    (
        cd $tmppath/anytools-jupyter
        echo '#!/bin/bash'
        echo "$(pipenv --venv)/bin/jupyter \"\$@\""
    ) > $tmppath/anytools-jupyter/bin/jupyter
    chmod +x $tmppath/anytools-jupyter/bin/jupyter

    echo mv "$tmppath/anytools-jupyter" "$PREFIX/jupyter-${version}"
    mv "$tmppath/anytools-jupyter" "$PREFIX/jupyter-${version}"

    rm -rf $tmppath
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    #[ -z "${python_version:-}" ] && install_python last env

    echo "export PATH=\"$PREFIX/jupyter-${version}/bin:\$PATH\""
fi

####################################################################################################

}

