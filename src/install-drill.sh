
####################################################################################################
# バージョン管理
####################################################################################################

# https://www.scala-lang.org/download/all.html

LAST_DRILL_VERSION=1.16.0

if [ $drill_version = "last" ]; then
    drill_version=$LAST_DRILL_VERSION
fi

url="http://www.apache.org/dyn/closer.lua?filename=drill/drill-$drill_version/apache-drill-$drill_version.tar.gz&action=download"
fname="apache-drill-$drill_version.tar.gz"

####################################################################################################
# インストール
####################################################################################################

(
    if [ ! -x "$PREFIX/drill-${drill_version}/bin/drill-embedded" -a $install_opt = "--install" ]; then

        tmppath="$PREFIX/drill-${drill_version}-tmp-$$"
        mkdir -p $tmppath

        echo "curl -Ssf -L $url > $tmppath/$fname"
        curl -Ssf -L $url > $tmppath/$fname
        echo "tar xzf $tmppath/$fname -C $tmppath"
        tar xzf $tmppath/$fname -C $tmppath

        echo mv "$tmppath/apache-drill-${drill_version}" "$PREFIX/drill-${drill_version}"
        mv "$tmppath/apache-drill-${drill_version}" "$PREFIX/drill-${drill_version}"

    fi
) >&2

####################################################################################################
# 実行環境設定
####################################################################################################

export DRILL_MAX_DIRECT_MEMORY=${DRILL_MAX_DIRECT_MEMORY:-"1G"}
export DRILL_HEAP=${DRILL_HEAP:-"1G"}
export DRILLBIT_CODE_CACHE_SIZE=${DRILLBIT_CODE_CACHE_SIZE:-"1G"}

export PATH="$PREFIX/drill-${drill_version}/bin:$PATH"

####################################################################################################
