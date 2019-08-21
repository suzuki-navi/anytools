#!/bin/bash

set -Ceu
# -C リダイレクトでファイルを上書きしない
# -e コマンドの終了コードが1つでも0以外になったら直ちに終了する
# -u 設定されていない変数が参照されたらエラー

install_opt=

while [ "$#" != 0 ]; do
    case "$1" in
#        --install )
#            # インストールされていなければ常にインストール
#            install_opt="--install"
#            ;;
#        --error )
#            # インストールされていなければ常にエラー
#            install_opt="--error"
#            ;;
        --prefix=* )
            PREFIX="${1#*=}"
            ;;
        --openjdk=* )
            openjdk_version="${1#*=}"
            ;;
        --openjdk )
            openjdk_version="last"
            ;;
        --scala=* )
            scala_version="${1#*=}"
            ;;
        --scala )
            scala_version="last"
            ;;
        --maven=* )
            maven_version="${1#*=}"
            ;;
        --maven )
            maven_version="last"
            ;;
#        --drill=* )
#            drill_version="${1#*=}"
#            ;;
#        --drill )
#            drill_version="last"
#            ;;
#        --parquet-tools=* )
#            parquet_tools_version="${1#*=}"
#            ;;
#        --parquet-tools )
#            parquet_tools_version="last"
#            ;;
        --python=* )
            python_version="${1#*=}"
            ;;
        --python )
            python_version="last"
            ;;
        --awscli )
            awscli_version="last"
            ;;
        --jq=* )
            jq_version="${1#*=}"
            ;;
        --jq )
            jq_version="last"
            ;;
        --* )
            echo "Option \`${1}\` is not supported." >&1
            exit 1
            ;;
        * )
            break
    esac
    shift
done

#if [ -z "$install_opt" ]; then
#    install_opt="--install"
#fi

export PREFIX="${PREFIX:-$HOME/.anytools}"

if [ "$#" = 0 ]; then
    command=""
else
    command="$1"
    shift
fi

case "$command" in
    "aws" )
        awscli_version=${awscli_version:-last}
        ;;
#    "drill-embedded" )
#        drill_version=${drill_version:-last}
#        ;;
    "jar" )
        openjdk_version=${openjdk_version:-last}
        ;;
    "java" )
        openjdk_version=${openjdk_version:-last}
        ;;
    "javac" )
        openjdk_version=${openjdk_version:-last}
        ;;
    "javadoc" )
        openjdk_version=${openjdk_version:-last}
        ;;
    "javap" )
        openjdk_version=${openjdk_version:-last}
        ;;
    "jq" )
        jq_version=${jq_version:-last}
        ;;
    "jshell" )
        openjdk_version=${openjdk_version:-last}
        ;;
    "mvn" )
        maven_version=${maven_version:-last}
        ;;
#    "parquet-tools" )
#        parquet_tools_version=${parquet_tools_version:-last}
#        ;;
    "python" )
        python_version=${python_version:-last}
        ;;
    "pipenv" )
        python_version=${python_version:-last}
        ;;
    "scala" )
        scala_version=${scala_version:-last}
        ;;
    "serialver" )
        openjdk_version=${openjdk_version:-last}
        ;;
    * )
        ;;
esac

#if [ -n "${drill_version:-}" ]; then
#    openjdk_version=${openjdk_version:-last}
#fi
#if [ -n "${parquet_tools_version:-}" ]; then
#    openjdk_version=${openjdk_version:-8}
#    maven_version=${maven_version:-last}
#fi

if [ -n "${openjdk_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-openjdk.sh
    install_openjdk $openjdk_version install
    . <(install_openjdk $openjdk_version env)
fi
if [ -n "${scala_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-scala.sh
    install_scala $scala_version install
    . <(install_scala $scala_version env)
fi
if [ -n "${maven_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-maven.sh
    install_maven $maven_version install
    . <(install_maven $maven_version env)
fi
#if [ -n "${drill_version:-}" ]; then
#    . $MULANG_SOURCE_DIR/install-drill.sh
#fi
#if [ -n "${parquet_tools_version:-}" ]; then
#    . $MULANG_SOURCE_DIR/install-parquet-tools.sh
#fi
if [ -n "${python_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-python.sh
    install_python $python_version install
    . <(install_python $python_version env)
fi
if [ -n "${awscli_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-awscli.sh
    install_awscli $awscli_version install
    . <(install_awscli $awscli_version env)
fi
if [ -n "${jq_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-jq.sh
    install_jq $jq_version install
    . <(install_jq $jq_version env)
fi

if ! which "$command" >/dev/null; then
    echo "Not found: $command" >&2
    exit 1
fi

exec "$command" "$@"

