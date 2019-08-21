
install_openjdk () {

local version=$1
local action=$2

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

local uname=$(uname)
local os_name=
if [ "$uname" = "Darwin" ]; then
    os_name='osx'
elif [ "$uname" = "Linux" ]; then
    os_name='linux'
else
    echo "Unknown OS: $uname"
    exit 1
fi

if [ ${version:-last} = "last" ]; then
    version=12
fi

if [ $version = 8 ]; then
    version=8.0.40
elif [ $version = 11 ]; then
    version=11.0.2
elif [ $version = 12 ]; then
    version=12.0.0
fi

local url=
local fname=
local tardirname=
if [ $action = install ]; then
    if [ $version = 8.0.40 ]; then
        url="https://download.java.net/openjdk/jdk8u40/ri/openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz"
        fname="openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz"
        tardirname=java-se-8u40-ri
    elif [ $version = 11.0.2 ]; then
        url="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_${os_name}-x64_bin.tar.gz"
        fname="openjdk-${version}_${os_name}-x64_bin.tar.gz"
        tardirname=jdk-11.0.2
    elif [ $version = 12.0.0 ]; then
        url="https://download.java.net/java/GA/jdk12/33/GPL/openjdk-12_${os_name}-x64_bin.tar.gz"
        fname="openjdk-${version}_${os_name}-x64_bin.tar.gz"
        tardirname=jdk-12
    else
        echo "Unknown version: $version"
        exit 1
    fi
fi

####################################################################################################
# インストール
####################################################################################################

if [ $action = install -a ! -x "$PREFIX/openjdk-${version}/bin/java" ]; then (
    local tmppath="$PREFIX/openjdk-${version}-tmp-$$"
    mkdir -p $tmppath

    echo "curl -f -L $url > $tmppath/$fname"
    curl -f -L $url > $tmppath/$fname
    echo "tar xzf $tmppath/$fname -C $tmppath"
    tar xzf $tmppath/$fname -C $tmppath

    if [ $os_name = "osx" ]; then
        echo mv $tmppath/$tardirname.jdk "$PREFIX/openjdk-${version}"
        mv $tmppath/$tardirname.jdk "$PREFIX/openjdk-${version}"
    else
        echo mv $tmppath/$tardirname "$PREFIX/openjdk-${version}"
        mv $tmppath/$tardirname "$PREFIX/openjdk-${version}"
    fi
    rm -rf $tmppath
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    if [ $os_name = "osx" ]; then
        echo "export JAVA_HOME=\"$PREFIX/openjdk-${version}/Contents/Home\""
    else
        echo "export JAVA_HOME=\"$PREFIX/openjdk-${version}\""
    fi

    echo "export PATH=\"\$JAVA_HOME/bin:\$PATH\""
fi

####################################################################################################

}

