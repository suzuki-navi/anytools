
[ -z "${openjdk_version:-}" ] && . $MULANG_SOURCE_DIR/install-openjdk.sh

install_sbt () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

# https://www.scala-sbt.org/download.html

if [ ${version:-last} = "last" ]; then
    version=1.2.8
fi

local url="https://piccolo.link/sbt-${version}.tgz"
local fname="sbt-${version}.tgz"

####################################################################################################
# インストール
####################################################################################################

if [ $action = install -a ! -x "$PREFIX/sbt-${version}/bin/sbt" ]; then (
    [ -z "${openjdk_version:-}" ] && install_openjdk last install

    local tmppath="$PREFIX/sbt-${version}-tmp-$$"
    mkdir -p $tmppath

    echo "curl -Ssf -L $url > $tmppath/$fname"
    curl -Ssf -L $url > $tmppath/$fname
    echo "tar xzf $tmppath/$fname -C $tmppath"
    tar xzf $tmppath/$fname -C $tmppath

    echo mv "$tmppath/sbt" "$PREFIX/sbt-${version}"
    mv "$tmppath/sbt" "$PREFIX/sbt-${version}"

    rm -rf $tmppath
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    [ -z "${JAVA_HOME:-}" ] && install_openjdk last env

    echo "export PATH=\"$PREFIX/sbt-${version}/bin:\$PATH\""
fi

####################################################################################################

}

