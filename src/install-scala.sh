
####################################################################################################
# バージョン管理
####################################################################################################

# https://www.scala-lang.org/download/all.html

LAST_SCALA_VERSION=2.13.0

if [ $scala_version = "last" ]; then
    scala_version=$LAST_SCALA_VERSION
fi

url="https://downloads.lightbend.com/scala/${scala_version}/scala-${scala_version}.tgz"
fname="scala-${scala_version}.tgz"

####################################################################################################
# インストール
####################################################################################################

(
    if [ ! -x "$PREFIX/scala-${scala_version}/bin/scala" -a $install_opt = "--install" ]; then

        tmppath="$PREFIX/scala-${scala_version}-tmp-$$"
        mkdir -p $tmppath

        echo "curl -Ssf -L $url > $tmppath/$fname"
        curl -Ssf -L $url > $tmppath/$fname
        echo "tar xzf $tmppath/$fname -C $tmppath"
        tar xzf $tmppath/$fname -C $tmppath

        echo mv $tmppath/scala-$scala_version "$PREFIX/scala-${scala_version}"
        mv $tmppath/scala-$scala_version "$PREFIX/scala-${scala_version}"

        rm -rf $tmppath
    fi
) >&2

####################################################################################################
# 実行環境設定
####################################################################################################

export SCALA_HOME="$PREFIX/scala-${scala_version}"
export PATH="$SCALA_HOME/bin:$PATH"

####################################################################################################
