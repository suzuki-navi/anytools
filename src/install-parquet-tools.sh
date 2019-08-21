# 
# ####################################################################################################
# # バージョン管理
# ####################################################################################################
# 
# # https://github.com/apache/parquet-mr/releases
# # 1.11.0 はコンパイルできなかった
# 
# LAST_PARQUET_TOOLS_VERSION=1.8.3
# 
# if [ $parquet_tools_version = "last" ]; then
#     parquet_tools_version=$LAST_PARQUET_TOOLS_VERSION
# fi
# 
# ####################################################################################################
# # インストール
# ####################################################################################################
# 
# (
#     if [ ! -x "$PREFIX/parquet-tools-${parquet_tools_version}/bin/parquet-tools" -a $install_opt = "--install" ]; then
#         maven_version=${maven_version:-last}
#         . $MULANG_SOURCE_DIR/install-maven.sh
# 
#         tmppath="$PREFIX/parquet-tools-${parquet_tools_version}-tmp-$$"
#         mkdir -p $tmppath
# 
#         echo cd $tmppath
#         cd $tmppath
#         echo git clone https://github.com/apache/parquet-mr.git .
#         git clone https://github.com/apache/parquet-mr.git .
#         echo git checkout apache-parquet-${parquet_tools_version}
#         git checkout apache-parquet-${parquet_tools_version}
# 
#         echo cd parquet-tools
#         cd parquet-tools
#         echo mvn clean package -Plocal -DskipTests
#         mvn clean package -Plocal -DskipTests
# 
#         mkdir bin
#         (
#             echo '#!/bin/bash'
#             echo "exec java -jar $PREFIX/parquet-tools-${parquet_tools_version}/target/parquet-tools-${parquet_tools_version}.jar \"\$@\""
#         ) > bin/parquet-tools.tmp
#         chmod +x bin/parquet-tools.tmp
#         mv bin/parquet-tools.tmp bin/parquet-tools
# 
#         echo cd ..
#         cd ..
#         echo mv parquet-tools "$PREFIX/parquet-tools-${parquet_tools_version}"
#         mv parquet-tools "$PREFIX/parquet-tools-${parquet_tools_version}"
# 
#         rm -rf $tmppath
#     fi
# ) >&2
# 
# ####################################################################################################
# # 実行環境設定
# ####################################################################################################
# 
# export PATH="$PREFIX/parquet-tools-${parquet_tools_version}/bin:$PATH"
# 
# ####################################################################################################
#
