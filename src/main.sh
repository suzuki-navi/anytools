#!/bin/bash

set -Ceu
# -C リダイレクトでファイルを上書きしない
# -e コマンドの終了コードが1つでも0以外になったら直ちに終了する
# -u 設定されていない変数が参照されたらエラー

install_opt=

while [ "$#" != 0 ]; do
    case "$1" in
        --install )
            # インストールされていなければ常にインストール
            install_opt="--install"
            ;;
        --error )
            # インストールされていなければ常にエラー
            install_opt="--error"
            ;;
        --prefix=* )
            PREFIX="${1#*=}"
            ;;
        --jdk=* )
            jdk_version="${1#*=}"
            ;;
        --jdk )
            jdk_version="last"
            ;;
        --scala=* )
            scala_version="${1#*=}"
            ;;
        --scala )
            scala_version="last"
            ;;
        --drill=* )
            drill_version="${1#*=}"
            ;;
        --drill )
            drill_version="last"
            ;;
        --maven=* )
            maven_version="${1#*=}"
            ;;
        --maven )
            maven_version="last"
            ;;
        --parquet-tools=* )
            parquet_tools_version="${1#*=}"
            ;;
        --parquet-tools )
            parquet_tools_version="last"
            ;;
        --python=* )
            python_version="${1#*=}"
            ;;
        --python )
            python_version="last"
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

if [ -z "$install_opt" ]; then
    install_opt="--install"
fi

export PREFIX="${PREFIX:-$HOME/.anytools}"

if [ "$#" = 0 ]; then
    command=""
else
    command="$1"
    shift
fi

case "$command" in
    "drill-embedded" )
        drill_version=${drill_version:-last}
        ;;
    "jar" )
        jdk_version=${jdk_version:-last}
        ;;
    "java" )
        jdk_version=${jdk_version:-last}
        ;;
    "javac" )
        jdk_version=${jdk_version:-last}
        ;;
    "javadoc" )
        jdk_version=${jdk_version:-last}
        ;;
    "javap" )
        jdk_version=${jdk_version:-last}
        ;;
    "jshell" )
        jdk_version=${jdk_version:-last}
        ;;
    "mvn" )
        maven_version=${maven_version:-last}
        ;;
    "parquet-tools" )
        parquet_tools_version=${parquet_tools_version:-last}
        ;;
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
        jdk_version=${jdk_version:-last}
        ;;
    * )
        ;;
esac

if [ -n "${scala_version:-}" ]; then
    jdk_version=${jdk_version:-last}
fi
if [ -n "${drill_version:-}" ]; then
    jdk_version=${jdk_version:-last}
fi
if [ -n "${maven_version:-}" ]; then
    jdk_version=${jdk_version:-last}
fi
if [ -n "${parquet_tools_version:-}" ]; then
    jdk_version=${jdk_version:-8}
    maven_version=${maven_version:-last}
fi

if [ -n "${jdk_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-openjdk.sh
fi
if [ -n "${scala_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-scala.sh
fi
if [ -n "${drill_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-drill.sh
fi
if [ -n "${maven_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-maven.sh
fi
if [ -n "${parquet_tools_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-parquet-tools.sh
fi
if [ -n "${python_version:-}" ]; then
    . $MULANG_SOURCE_DIR/install-python.sh
fi

if ! which "$command" >/dev/null; then
    echo "Not found: $command" >&2
    exit 1
fi

exec "$command" "$@"

