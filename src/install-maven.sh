
[ -z "${openjdk_version:-}" ] && . $MULANG_SOURCE_DIR/install-openjdk.sh

install_maven () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

# http://ftp.riken.jp/net/apache/maven/maven-3/

if [ ${version:-last} = "last" ]; then
    version=3.6.1
fi

local url="http://ftp.riken.jp/net/apache/maven/maven-3/${version}/binaries/apache-maven-${version}-bin.tar.gz"
local fname="apache-maven-${version}.tar.gz"

####################################################################################################
# インストール
####################################################################################################

if [ $action = install -a ! -x "$PREFIX/maven-${version}/bin/mvn" ]; then (
    [ -z "${openjdk_version:-}" ] && install_openjdk last install

    local tmppath="$PREFIX/maven-${version}-tmp-$$"
    mkdir -p $tmppath

    echo "curl -Ssf -L $url > $tmppath/$fname"
    curl -Ssf -L $url > $tmppath/$fname
    echo "tar xzf $tmppath/$fname -C $tmppath"
    tar xzf $tmppath/$fname -C $tmppath

    echo mv "$tmppath/apache-maven-$version" "$PREFIX/maven-${version}"
    mv "$tmppath/apache-maven-$version" "$PREFIX/maven-${version}"

    rm -rf $tmppath
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    [ -z "${openjdk_version:-}" ] && install_openjdk last env

    echo "export PATH=\"$PREFIX/maven-${version}/bin:\$PATH\""
fi

####################################################################################################

}

