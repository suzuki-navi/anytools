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

LAST_VERSION=2.13.0

if [ $version = "last" ]; then
    version=$LAST_VERSION
fi

url="https://downloads.lightbend.com/scala/${version}/scala-${version}.tgz"
fname="scala-${version}.tgz"

####################################################################################################
# インストール
####################################################################################################

(
    if [ ! -x "$PREFIX/scala-${version}/bin/scala" -a $install_opt = "--install" ]; then

        tmppath="$PREFIX/scala-${version}-tmp-$$"
        mkdir -p $tmppath

        echo "curl -Ssf -L $url > $tmppath/$fname"
        curl -Ssf -L $url > $tmppath/$fname
        echo "tar xzf $tmppath/$fname -C $tmppath"
        tar xzf $tmppath/$fname -C $tmppath

        echo mv $tmppath/scala-$version "$PREFIX/scala-${version}"
        mv $tmppath/scala-$version "$PREFIX/scala-${version}"

        rm -rf $tmppath
    fi
) >&2

####################################################################################################
# 実行環境設定
####################################################################################################

echo "export SCALA_HOME=\"$PREFIX/scala-${version}\""
echo "export PATH=\"\$SCALA_HOME/bin:\$PATH\""

####################################################################################################
