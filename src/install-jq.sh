
install_jq () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

# https://stedolan.github.io/jq/download/

if [ ${version:-last} = "last" ]; then
    version=1.6
fi

local url="https://github.com/stedolan/jq/releases/download/jq-${version}/jq-linux64"

####################################################################################################
# インストール
####################################################################################################

if [ $action = install -a ! -x "$PREFIX/jq-${version}/bin/jq" ]; then (
    local tmppath="$PREFIX/jq-${version}-tmp-$$"
    mkdir -p $tmppath

    mkdir -p $tmppath/target/bin

    echo "curl -f -L $url > $tmppath/target/bin/jq"
    curl -f -L $url > $tmppath/target/bin/jq
    echo "chmod +x $tmppath/target/bin/jq"
    chmod +x $tmppath/target/bin/jq

    echo mv "$tmppath/target" "$PREFIX/jq-${version}"
    mv "$tmppath/target" "$PREFIX/jq-${version}"

    rm -rf $tmppath
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    echo "export PATH=\"$PREFIX/jq-${version}/bin:\$PATH\""
fi

####################################################################################################

}

