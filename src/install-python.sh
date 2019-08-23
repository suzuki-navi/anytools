
install_python () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

# https://github.com/pyenv/pyenv/tree/master/plugins/python-build/share/python-build

if [ ${version:-last} = "last" ]; then
    version=3.7.4
elif [ ${version:-last} = 2 ]; then
    version=2.7.16
fi

####################################################################################################
# インストール
####################################################################################################

local pyenv_root=$HOME/.pyenv

if [ $action = install -a ! -x "$pyenv_root/versions/$version/bin/pipenv" ]; then (
    if [ -e $pyenv_root/bin/pyenv ]; then
        (cd $pyenv_root; git pull -q)
    else
        git clone git://github.com/yyuu/pyenv.git $pyenv_root
    fi

    if [ ! -e $pyenv_root/versions/$version/bin/python ]; then
        $pyenv_root/bin/pyenv install -s -v $version
    fi
    if [ ! -e $pyenv_root/versions/$version/bin/pipenv ]; then
        $pyenv_root/versions/$version/bin/pip install --upgrade pip
        $pyenv_root/versions/$version/bin/pip install pipenv
    fi
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    echo "export PYENV_ROOT=\"$pyenv_root\""
    echo "export PATH=\"\$PYENV_ROOT/versions/$version/bin:\$PATH\""
fi

####################################################################################################

}

