
####################################################################################################
# バージョン管理
####################################################################################################

# https://github.com/pyenv/pyenv/tree/master/plugins/python-build/share/python-build

LAST_PYTHON_VERSION=3.7.4

if [ $python_version = "last" ]; then
    python_version=$LAST_PYTHON_VERSION
fi

####################################################################################################
# インストールと実行環境設定
####################################################################################################

export PYENV_ROOT=$HOME/.pyenv

(
    if [ -e $PYENV_ROOT/bin/pyenv ]; then
        (cd $PYENV_ROOT; git pull -q)
    else
        git clone git://github.com/yyuu/pyenv.git $PYENV_ROOT
    fi

    if [ ! -e $PYENV_ROOT/versions/$python_version/bin/python ]; then
        $PYENV_ROOT/bin/pyenv install -s -v $python_version
    fi
    if [ ! -e $PYENV_ROOT/versions/$python_version/bin/pipenv ]; then
        $PYENV_ROOT/versions/$python_version/bin/pip install --upgrade pip
        $PYENV_ROOT/versions/$python_version/bin/pip install pipenv
    fi
) >&2

export PATH="$PYENV_ROOT/versions/$python_version/bin:$PATH"

#export PYENV_VERSION=$python_version
#export PATH="$PYENV_ROOT/shims:$PATH"

####################################################################################################
