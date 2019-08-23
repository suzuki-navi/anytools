
[ -z "${python_version:-}" ] && . $MULANG_SOURCE_DIR/install-python.sh

install_gcpcli () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

# https://console.cloud.google.com/storage/browser/cloud-sdk-release

if [ ${version:-last} = "last" ]; then
    version=249.0.0
fi

local url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${version}-linux-x86_64.tar.gz"
local fname="google-cloud-sdk-${version}-linux-x86_64.tar.gz"

####################################################################################################
# インストール
####################################################################################################

if [ $action = install -a ! -x "$PREFIX/gcpcli-${version}/bin/gcloud" ]; then (
    install_python 2 install
    . <(install_python 2 env)

    local tmppath="$PREFIX/gcpcli-${version}-tmp-$$"
    mkdir -p $tmppath

    echo curl -Ssf -L $url \> $tmppath/$fname
    curl -Ssf -L $url > $tmppath/$fname
    echo tar xzf $tmppath/$fname -C $tmppath
    tar xzf $tmppath/$fname -C $tmppath

    echo mv "$tmppath/google-cloud-sdk" "$PREFIX/gcpcli-${version}"
    mv "$tmppath/google-cloud-sdk" "$PREFIX/gcpcli-${version}"

    rm -rf $tmppath
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    install_python 2 env

    echo "export PATH=\"$PREFIX/gcpcli-${version}/bin:\$PATH\""
fi

####################################################################################################

}

