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

        #PARSER-OPTION

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
    #PARSER-COMMAND
    * )
        ;;
esac

#PARSER-LOAD

if ! which "$command" >/dev/null; then
    echo "Not found: $command" >&2
    exit 1
fi

exec "$command" "$@"

