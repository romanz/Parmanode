function verify_bitcoin {
cd $HOME/parmanode/bitcoin

if ! sha256sum --ignore-missing --check SHA256SUMS ; then debug "Checksum failed. Aborting." ; exit 1 ; fi
sleep 3
echo ""
echo " Please wait a moment for gpg verification..."

#keys from : https://github.com/bitcoin-core/guix.sigs/tree/main/builder-keys
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys E777299FC265DD04793070EB944D35F9AC3DB76A >/dev/null 2>&1
curl https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/laanwj.gpg | gpg --import >/dev/null 2>&1
curl https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/Emzy.gpg | gpg --import >/dev/null 2>&1

    if gpg --verify SHA256SUMS.asc 2>&1 | grep "Good"  # it is vital for the "2>&1" to remain for this function to work
    then
        echo ""
        echo "GPG verification of the SHA256SUMS file passed. "
        echo ""
        enter_continue
    else 
        echo ""
        echo "GPG verification failed. Aborting." 
        enter_continue
        return 1 
    fi
}