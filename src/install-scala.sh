
[ -z "${openjdk_version:-}" ] && . $MULANG_SOURCE_DIR/install-openjdk.sh

install_scala () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

# https://www.scala-lang.org/download/all.html

if [ ${version:-last} = "last" ]; then
    version=2.13.0
fi

local url="https://downloads.lightbend.com/scala/${version}/scala-${version}.tgz"
local fname="scala-${version}.tgz"

####################################################################################################
# インストール
####################################################################################################

if [ $action = install -a ! -x "$PREFIX/scala-${version}/bin/scala" ]; then (
    [ -z "${openjdk_version:-}" ] && install_openjdk last install

    local tmppath="$PREFIX/scala-${version}-tmp-$$"
    mkdir -p $tmppath

    echo "curl -Ssf -L $url > $tmppath/$fname"
    curl -Ssf -L $url > $tmppath/$fname
    echo "tar xzf $tmppath/$fname -C $tmppath"
    tar xzf $tmppath/$fname -C $tmppath

    echo mv $tmppath/scala-$version "$PREFIX/scala-${version}"
    mv $tmppath/scala-$version "$PREFIX/scala-${version}"

    rm -rf $tmppath
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    [ -z "${openjdk_version:-}" ] && install_openjdk last env

    echo "export SCALA_HOME=\"$PREFIX/scala-${version}\""
    echo "export PATH=\"\$SCALA_HOME/bin:\$PATH\""
fi

####################################################################################################

}

