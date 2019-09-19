
# Ubuntuでは以下のパッケージが必要
# libreadline-dev

install_ruby () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

# https://github.com/rbenv/ruby-build/tree/master/share/ruby-build

if [ ${version:-last} = "last" ]; then
    version=2.6.4
fi

####################################################################################################
# インストール
####################################################################################################

local rbenv_root=$HOME/.rbenv

if [ $action = install -a ! -x "$rbenv_root/versions/$version/bin/rbenv" ]; then (
    export RBENV_ROOT="$rbenv_root"

    if [ -e $rbenv_root/bin/rbenv ]; then
        : #(cd $rbenv_root; git pull -q)
    else
        git clone https://github.com/rbenv/rbenv.git $rbenv_root
    fi
    if [ -e $rbenv_root/plugins/ruby-build/bin/rbenv-install ]; then
        : #(cd $rbenv_root/plugins/ruby-build; git pull -q)
    else
        git clone https://github.com/rbenv/ruby-build.git $rbenv_root/plugins/ruby-build
    fi

    if [ ! -e $rbenv_root/versions/$version/bin/ruby ]; then
        $rbenv_root/bin/rbenv install --skip-existing --verbose $version
    fi

#    export RBENV_VERSION="$version"

#    if [ ! -e $rbenv_root/versions/$version/bin/pipenv ]; then
        
#        $rbenv_root/versions/$version/bin/pip install --upgrade pip
#        $rbenv_root/versions/$version/bin/pip install pipenv
#    fi
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    echo "export RBENV_ROOT=\"$rbenv_root\""
    echo "export BUNDLE_PATH=vendor/bundle/ruby/$version"
    echo "export PATH=\"\$RBENV_ROOT/bin:\$PATH\""
    echo "export PATH=\"\$RBENV_ROOT/versions/$version/bin:\$PATH\""
fi

####################################################################################################

}

