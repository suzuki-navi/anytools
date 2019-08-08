#!/bin/bash

set -Ceu
# -C リダイレクトでファイルを上書きしない
# -e コマンドの終了コードが1つでも0以外になったら直ちに終了する
# -u 設定されていない変数が参照されたらエラー

install_opt=$1
version=$2

####################################################################################################
# バージョン管理
####################################################################################################

# https://www.scala-lang.org/download/all.html

LAST_VERSION=1.16.0

if [ $version = "last" ]; then
    version=$LAST_VERSION
fi

url="http://www.apache.org/dyn/closer.lua?filename=drill/drill-$version/apache-drill-$version.tar.gz&action=download"
fname="apache-drill-$version.tar.gz"

####################################################################################################
# インストール
####################################################################################################

(
    if [ ! -x "$PREFIX/drill-${version}/bin/drill-embedded" -a $install_opt = "--install" ]; then

        tmppath="$PREFIX/drill-${version}-tmp-$$"
        mkdir -p $tmppath

        echo "curl -Ssf -L $url > $tmppath/$fname"
        curl -Ssf -L $url > $tmppath/$fname
        echo "tar xzf $tmppath/$fname -C $tmppath"
        tar xzf $tmppath/$fname -C $tmppath

        echo mv "$tmppath/apache-drill-${version}" "$PREFIX/drill-${version}"
        mv "$tmppath/apache-drill-${version}" "$PREFIX/drill-${version}"

    fi
) >&2

####################################################################################################
# 実行環境設定
####################################################################################################

echo "export DRILL_MAX_DIRECT_MEMORY=${DRILL_MAX_DIRECT_MEMORY:-"1G"}"
echo "export DRILL_HEAP=${DRILL_HEAP:-"1G"}"
echo "export DRILLBIT_CODE_CACHE_SIZE=${DRILLBIT_CODE_CACHE_SIZE:-"1G"}"

echo "export PATH=\"$PREFIX/drill-${version}/bin:\$PATH\""

####################################################################################################
