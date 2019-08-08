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

# https://jdk.java.net/archive/

LAST_VERSION=12

# version
#   11
#   11.0.2
#   12
#   12.0.0

uname=$(uname)
if [ "$uname" = "Darwin" ]; then
    os_name='osx'
elif [ "$uname" = "Linux" ]; then
    os_name='linux'
else
    echo "Unknown OS: $uname"
    exit 1
fi

if [ $version = "last" ]; then
    version=$LAST_VERSION
fi

if [ $version = 11 ]; then
    version=11.0.2
elif [ $version = 12 ]; then
    version=12.0.0
fi

if [ $version = 11.0.2 ]; then
    url="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_${os_name}-x64_bin.tar.gz"
    fname="openjdk-${version}_${os_name}-x64_bin.tar.gz"
    tardirname=jdk-11
elif [ $version = 12.0.0 ]; then
    url="https://download.java.net/java/GA/jdk12/33/GPL/openjdk-12_${os_name}-x64_bin.tar.gz"
    fname="openjdk-${version}_${os_name}-x64_bin.tar.gz"
    tardirname=jdk-12
else
    echo "Unknown version: $version"
    exit 1
fi

####################################################################################################
# インストール
####################################################################################################

(
    if [ ! -x "$PREFIX/jdk-${version}/bin/java" -a $install_opt = "--install" ]; then

        tmppath="$PREFIX/jdk-${version}-tmp-$$"
        mkdir -p $tmppath

        echo "curl -Ssf -L $url > $tmppath/$fname"
        curl -Ssf -L $url > $tmppath/$fname
        echo "tar xzf $tmppath/$fname -C $tmppath"
        tar xzf $tmppath/$fname -C $tmppath

        if [ $os_name = "osx" ]; then
            echo mv $tmppath/$tardirname.jdk "$PREFIX/jdk-${version}"
            mv $tmppath/$tardirname.jdk "$PREFIX/jdk-${version}"
        else
            echo mv $tmppath/$tardirname "$PREFIX/jdk-${version}"
            mv $tmppath/$tardirname "$PREFIX/jdk-${version}"
        fi
        rm -rf $tmppath
    fi
) >&2

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $os_name = "osx" ]; then
    echo "export JAVA_HOME=\"$PREFIX/jdk-${version}/Contents/Home\""
else
    echo "export JAVA_HOME=\"$PREFIX/jdk-${version}\""
fi

echo "export PATH=\"\$JAVA_HOME/bin:\$PATH\""

####################################################################################################
