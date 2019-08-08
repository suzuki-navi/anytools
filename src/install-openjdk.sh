
####################################################################################################
# バージョン管理
####################################################################################################

# https://jdk.java.net/archive/

LAST_JDK_VERSION=12

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

if [ $jdk_version = "last" ]; then
    jdk_version=$LAST_JDK_VERSION
fi

if [ $jdk_version = 11 ]; then
    jdk_version=11.0.2
elif [ $jdk_version = 12 ]; then
    jdk_version=12.0.0
fi

if [ $jdk_version = 11.0.2 ]; then
    url="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_${os_name}-x64_bin.tar.gz"
    fname="openjdk-${jdk_version}_${os_name}-x64_bin.tar.gz"
    tardirname=jdk-11
elif [ $jdk_version = 12.0.0 ]; then
    url="https://download.java.net/java/GA/jdk12/33/GPL/openjdk-12_${os_name}-x64_bin.tar.gz"
    fname="openjdk-${jdk_version}_${os_name}-x64_bin.tar.gz"
    tardirname=jdk-12
else
    echo "Unknown jdk_version: $jdk_version"
    exit 1
fi

####################################################################################################
# インストール
####################################################################################################

(
    if [ ! -x "$PREFIX/jdk-${jdk_version}/bin/java" -a $install_opt = "--install" ]; then

        tmppath="$PREFIX/jdk-${jdk_version}-tmp-$$"
        mkdir -p $tmppath

        echo "curl -Ssf -L $url > $tmppath/$fname"
        curl -Ssf -L $url > $tmppath/$fname
        echo "tar xzf $tmppath/$fname -C $tmppath"
        tar xzf $tmppath/$fname -C $tmppath

        if [ $os_name = "osx" ]; then
            echo mv $tmppath/$tardirname.jdk "$PREFIX/jdk-${jdk_version}"
            mv $tmppath/$tardirname.jdk "$PREFIX/jdk-${jdk_version}"
        else
            echo mv $tmppath/$tardirname "$PREFIX/jdk-${jdk_version}"
            mv $tmppath/$tardirname "$PREFIX/jdk-${jdk_version}"
        fi
        rm -rf $tmppath
    fi
) >&2

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $os_name = "osx" ]; then
    export JAVA_HOME="$PREFIX/jdk-${jdk_version}/Contents/Home"
else
    export JAVA_HOME="$PREFIX/jdk-${jdk_version}"
fi

export PATH="$JAVA_HOME/bin:$PATH"

####################################################################################################
