
openjdk_version=$1
action=$2

####################################################################################################
# バージョン管理
####################################################################################################

# https://jdk.java.net/archive/

# version
#   8
#   8.0.40
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

if [ ${openjdk_version:-last} = "last" ]; then
    openjdk_version=12
fi

if [ $openjdk_version = 8 ]; then
    openjdk_version=8.0.40
elif [ $openjdk_version = 11 ]; then
    openjdk_version=11.0.2
elif [ $openjdk_version = 12 ]; then
    openjdk_version=12.0.0
fi

if [ $action = install ]; then
    if [ $openjdk_version = 8.0.40 ]; then
        url="https://download.java.net/openjdk/jdk8u40/ri/openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz"
        fname="openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz"
        tardirname=java-se-8u40-ri
    elif [ $openjdk_version = 11.0.2 ]; then
        url="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_${os_name}-x64_bin.tar.gz"
        fname="openjdk-${openjdk_version}_${os_name}-x64_bin.tar.gz"
        tardirname=jdk-11.0.2
    elif [ $openjdk_version = 12.0.0 ]; then
        url="https://download.java.net/java/GA/jdk12/33/GPL/openjdk-12_${os_name}-x64_bin.tar.gz"
        fname="openjdk-${openjdk_version}_${os_name}-x64_bin.tar.gz"
        tardirname=jdk-12
    else
        echo "Unknown openjdk_version: $openjdk_version"
        exit 1
    fi
fi

####################################################################################################
# インストール
####################################################################################################

if [ $action = install ]; then (
    if [ ! -x "$PREFIX/openjdk-${openjdk_version}/bin/java" ]; then

        tmppath="$PREFIX/openjdk-${openjdk_version}-tmp-$$"
        mkdir -p $tmppath

        echo "curl -f -L $url > $tmppath/$fname"
        curl -f -L $url > $tmppath/$fname
        echo "tar xzf $tmppath/$fname -C $tmppath"
        tar xzf $tmppath/$fname -C $tmppath

        if [ $os_name = "osx" ]; then
            echo mv $tmppath/$tardirname.jdk "$PREFIX/openjdk-${openjdk_version}"
            mv $tmppath/$tardirname.jdk "$PREFIX/openjdk-${openjdk_version}"
        else
            echo mv $tmppath/$tardirname "$PREFIX/openjdk-${openjdk_version}"
            mv $tmppath/$tardirname "$PREFIX/openjdk-${openjdk_version}"
        fi
        rm -rf $tmppath
    fi
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    if [ $os_name = "osx" ]; then
        export JAVA_HOME="$PREFIX/openjdk-${openjdk_version}/Contents/Home"
    else
        export JAVA_HOME="$PREFIX/openjdk-${openjdk_version}"
    fi

    export PATH="$JAVA_HOME/bin:$PATH"
fi

####################################################################################################
