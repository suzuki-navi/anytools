
####################################################################################################
# バージョン管理
####################################################################################################

# http://ftp.riken.jp/net/apache/maven/maven-3/

LAST_MAVEN_VERSION=3.6.1

if [ $maven_version = "last" ]; then
    maven_version=$LAST_MAVEN_VERSION
fi

url="http://ftp.riken.jp/net/apache/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz"
fname="apache-maven-${maven_version}.tar.gz"

####################################################################################################
# インストール
####################################################################################################

(
    if [ ! -x "$PREFIX/maven-${maven_version}/bin/mvn" -a $install_opt = "--install" ]; then

        tmppath="$PREFIX/maven-${maven_version}-tmp-$$"
        mkdir -p $tmppath

        echo "curl -Ssf -L $url > $tmppath/$fname"
        curl -Ssf -L $url > $tmppath/$fname
        echo "tar xzf $tmppath/$fname -C $tmppath"
        tar xzf $tmppath/$fname -C $tmppath

        echo mv "$tmppath/apache-maven-$maven_version" "$PREFIX/maven-${maven_version}"
        mv "$tmppath/apache-maven-$maven_version" "$PREFIX/maven-${maven_version}"

        rm -rf $tmppath
    fi
) >&2

####################################################################################################
# 実行環境設定
####################################################################################################

export PATH="$PREFIX/maven-${maven_version}/bin:$PATH"

####################################################################################################
