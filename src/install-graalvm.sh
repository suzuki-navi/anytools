
install_graalvm () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

# https://github.com/oracle/graal/releases

if [ ${version:-last} = "last" ]; then
    version=19.0.2
fi

local uname=$(uname)
local os_name=
if [ "$uname" = "Darwin" ]; then
    os_name='darwin'
elif [ "$uname" = "Linux" ]; then
    os_name='linux'
else
    echo "Unknown OS: $uname"
    exit 1
fi

local url="https://github.com/oracle/graal/releases/download/vm-${version}/graalvm-ce-${os_name}-amd64-${version}.tar.gz"
local fname="graalvm-ce-${os_name}-amd64-${version}.tar.gz"

####################################################################################################
# インストール
####################################################################################################

if [ $action = install -a ! -x "$PREFIX/graalvm-${version}/bin/java" ]; then (
    local tmppath="$PREFIX/graalvm-${version}-tmp-$$"
    mkdir -p $tmppath

    echo "curl -Ssf -L $url > $tmppath/$fname"
    curl -Ssf -L $url > $tmppath/$fname
    echo "tar xzf $tmppath/$fname -C $tmppath"
    tar xzf $tmppath/$fname -C $tmppath

    echo $tmppath/graalvm-ce-${version}/bin/gu install native-image
    $tmppath/graalvm-ce-${version}/bin/gu install native-image

    echo mv "$tmppath/graalvm-ce-${version}" "$PREFIX/graalvm-${version}"
    mv "$tmppath/graalvm-ce-${version}" "$PREFIX/graalvm-${version}"

    rm -rf $tmppath
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    echo "export JAVA_HOME=\"$PREFIX/graalvm-${version}\""
    echo "export PATH=\"\$JAVA_HOME/bin:\$PATH\""
fi

####################################################################################################

}

