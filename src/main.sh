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
            JDK_VERSION="${1#*=}"
            ;;
        --jdk )
            JDK_VERSION="last"
            ;;
        --scala=* )
            SCALA_VERSION="${1#*=}"
            ;;
        --scala )
            SCALA_VERSION="last"
            ;;
        --drill=* )
            DRILL_VERSION="${1#*=}"
            ;;
        --drill )
            DRILL_VERSION="last"
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

export PREFIX

if [ "$#" = 0 ]; then
    command=""
else
    command="$1"
    shift
fi

case "$command" in
    "drill-embedded" )
        DRILL_VERSION=${DRILL_VERSION:-last}
        ;;
    "jar" )
        JDK_VERSION=${JDK_VERSION:-last}
        ;;
    "java" )
        JDK_VERSION=${JDK_VERSION:-last}
        ;;
    "javac" )
        JDK_VERSION=${JDK_VERSION:-last}
        ;;
    "javadoc" )
        JDK_VERSION=${JDK_VERSION:-last}
        ;;
    "javap" )
        JDK_VERSION=${JDK_VERSION:-last}
        ;;
    "jshell" )
        JDK_VERSION=${JDK_VERSION:-last}
        ;;
    "scala" )
        SCALA_VERSION=${SCALA_VERSION:-last}
        ;;
    "serialver" )
        JDK_VERSION=${JDK_VERSION:-last}
        ;;
    * )
        break
esac

if [ -n "${SCALA_VERSION:-}" ]; then
    JDK_VERSION=${JDK_VERSION:-last}
fi
if [ -n "${DRILL_VERSION:-}" ]; then
    JDK_VERSION=${JDK_VERSION:-last}
fi

if [ -n "${JDK_VERSION:-}" ]; then
    . <(bash $MULANG_SOURCE_DIR/install-openjdk.sh $install_opt $JDK_VERSION)
fi
if [ -n "${SCALA_VERSION:-}" ]; then
    . <(bash $MULANG_SOURCE_DIR/install-scala.sh $install_opt $SCALA_VERSION)
fi
if [ -n "${DRILL_VERSION:-}" ]; then
    . <(bash $MULANG_SOURCE_DIR/install-drill.sh $install_opt $DRILL_VERSION)
fi

if ! which "$command" >/dev/null; then
    echo "Not found: $command" >&2
    exit 1
fi

exec "$command" "$@"

