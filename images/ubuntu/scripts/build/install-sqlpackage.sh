#!/bin/bash -e
################################################################################
##  File:  install-sqlpackage.sh
##  Desc:  Install SqlPackage CLI to DacFx (https://docs.microsoft.com/sql/tools/sqlpackage/sqlpackage-download#get-sqlpackage-net-core-for-linux)
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/install.sh
source $HELPER_SCRIPTS/os.sh

# Install libssl1.1 dependency
if is_ubuntu22; then
    libssl_deb_path=$(download_with_retry "http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb")
    libssl_hash="df9d07d552aab0c7e5b9fbcc568913acd20d50fb8b1e34876fa348b7a0c82d48"
    use_checksum_comparison "$libssl_deb_path" "$libssl_hash"

    dpkg -i "$libssl_deb_path"
fi

# Install SqlPackage
archive_path=$(download_with_retry "https://aka.ms/sqlpackage-linux")
unzip -qq "$archive_path" -d /usr/local/sqlpackage
chmod +x /usr/local/sqlpackage/sqlpackage
ln -sf /usr/local/sqlpackage/sqlpackage /usr/local/bin

invoke_tests "Tools" "SqlPackage"
