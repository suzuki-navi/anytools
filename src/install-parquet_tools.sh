
[ -z "${openjdk_version:-}" ] && . $MULANG_SOURCE_DIR/install-openjdk.sh
[ -z "${maven_version:-}" ] && . $MULANG_SOURCE_DIR/install-maven.sh

install_parquet_tools () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

# https://github.com/apache/parquet-mr/releases
# 1.11.0 はコンパイルできなかった

LAST_PARQUET_TOOLS_VERSION=1.8.3

if [ $version = "last" ]; then
    version=1.8.3
fi

local default_openjdk_version=8
local default_openjdk_version2=last
local default_maven_version=last

####################################################################################################
# インストール
####################################################################################################

if [ $action = install -a ! -x "$PREFIX/parquet-tools-${version}/bin/parquet-tools" ]; then (
    install_openjdk $default_openjdk_version install
    install_openjdk $default_openjdk_version2 install
    install_maven $default_maven_version install

    tmppath="$PREFIX/parquet-tools-${version}-tmp-$$"
    mkdir -p $tmppath

    echo cd $tmppath
    cd $tmppath
    echo git clone https://github.com/apache/parquet-mr.git .
    git clone https://github.com/apache/parquet-mr.git .
    echo git checkout apache-parquet-${version}
    git checkout apache-parquet-${version}

    echo cd parquet-tools
    cd parquet-tools
    (
        # 依存ライブラリのダウンロードのみ最新のJavaにて実行
        # 古いJavaだとSSLでエラーになるため
        . <(install_openjdk $default_openjdk_version2 env)
        . <(install_maven $default_maven_version env)
        echo mvn dependency:copy-dependencies
        mvn dependency:copy-dependencies
    )
    (
        # Java8 でないとコンパイルエラーになってしまうため
        . <(install_openjdk $default_openjdk_version env)
        . <(install_maven $default_maven_version env)
        echo mvn package -Plocal -DskipTests
        mvn package -Plocal -DskipTests
    )

    mkdir bin
    (
        echo '#!/bin/bash'
        echo "exec java -jar $PREFIX/parquet-tools-${version}/target/parquet-tools-${version}.jar \"\$@\""
    ) > bin/parquet-tools.tmp
    chmod +x bin/parquet-tools.tmp
    mv bin/parquet-tools.tmp bin/parquet-tools

    echo cd ..
    cd ..
    echo mv parquet-tools "$PREFIX/parquet-tools-${version}"
    mv parquet-tools "$PREFIX/parquet-tools-${version}"

    rm -rf $tmppath
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    # Java8 でないと実行時にwarningが発生してしまう
    install_openjdk $default_openjdk_version env

    echo "export PATH=\"$PREFIX/parquet-tools-${version}/bin:\$PATH\""
fi

####################################################################################################

}

