
install_rust () {

local version=$1
local action=$2

####################################################################################################
# バージョン管理
####################################################################################################

# https://github.com/rust-lang/rust/blob/master/RELEASES.md

if [ ${version:-last} = "last" ]; then
    version=1.37.0
fi

####################################################################################################
# インストール
####################################################################################################

toolchain_list=$(
    export RUSTUP_HOME="$PREFIX/rust"
    export CARGO_HOME="$PREFIX/rust"
    if [ -x $RUSTUP_HOME/bin/rustup ]; then
        $RUSTUP_HOME/bin/rustup toolchain list
    fi
)

if [ $action = install ] && ! ( echo "$toolchain_list" | grep "^${version}-" >/dev/null ); then (
    export RUSTUP_HOME="$PREFIX/rust"
    export CARGO_HOME="$PREFIX/rust"

    if [ -x "$RUSTUP_HOME/bin/rustup" ]; then
        "$RUSTUP_HOME/bin/rustup" self update 2>/dev/null
    else
        curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y --default-toolchain none
    fi

    if ! $RUSTUP_HOME/bin/rustup toolchain list | grep "^${version}-" >/dev/null; then
        $RUSTUP_HOME/bin/rustup toolchain install "$version"
    fi
) >&2; fi

####################################################################################################
# 実行環境設定
####################################################################################################

if [ $action = env ]; then
    echo "export RUSTUP_HOME=\"$PREFIX/rust\""
    echo "export CARGO_HOME=\"$PREFIX/rust\""

    echo "export RUSTUP_TOOLCHAIN=\"${version}\""

    echo "export PATH=\"$PREFIX/rust/bin:\$PATH\""
fi

####################################################################################################

}

