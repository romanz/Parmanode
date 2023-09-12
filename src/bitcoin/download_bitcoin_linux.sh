function download_bitcoin_linux {
cd $HOME/parmanode/bitcoin

set_terminal_high
echo "
########################################################################################
    
    The current version of Bitcoin Core that will be installed is 25.0

    The pgp key that will be used to verify the SHA256 file list is:

                Michael Ford: E777299FC265DD04793070EB944D35F9AC3DB76A 
    
    The downloaded file will then be hased (SHA256) and compared to the hash result 
    provided by Michael Ford (Bitcoin Developer).
    
    You may wish to learn how to do this yourself...

            - The file containing the hashes can be found at 
              /home/$(whoami)/parmanode/bitcoin/SHA256SUMS. 
            - The corresponding signature of that file is called SHA256SUMS.asc
            - You can then hash the bitcoin .tar.gz file using this command:
                   
                   shasum -a 256 bitcoin-24.0.1-x86_64-linux-gnu.tar.gz

            - After a few seconds you'll get a hash. Compare it to the one listed 
              by Michael Ford.
            


    Hit <enter> to keep reading.

########################################################################################
"
read ; set_terminal_high
echo "
########################################################################################
    
            - Next, if you don't feel like trusting Michael Ford is sufficiently 
              safe, you can import the public keys of anyone else who has signed the 
              file. I will add more signature verifications later.

    What actually do these signers do?

    They take the code, written in programming language, and compile it (convert it
    to machine code, ie binary) then zip the result. This produces one file that they 
    hash. If there is any tampering of the code, the hash produced will change. If many
    people who read the code are providing the same hash, we can be confident sure 
    there hasn't been any funny business between the time they check to when you got 
    your hands on a copy.

    They then digitally sign the document that contains the hash that they vouch for. 
    The way digital signatures work is fascinating and worth learning about. You don't 
    have to be a cryptogrphy PhD to get the gist of it. It is the basis of how Bitcoin
    transactions work, and how nodes verify transactions.

    For more information on PGP, I have detailed guides:

    https://armantheparman.com/gpg-articles/

########################################################################################

Hit <enter> to continue." # don't change
echo ""
#    Do not use "enter_continue" here. See next lines for explanation.

read #using custom function "enter_continue" here produced a strange error I don't 
     #understand. Somehow the read command inside the function was reciving input, I
     #think from the calling function, maybe, and the code proceeds to download (next
     #line) without any user input to continue."

set_terminal ; echo "Downloading Bitcoin files to $HOME/parmanode/bitcoin ..."

curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/SHA256SUMS 
curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/SHA256SUMS.asc 

# ARM Pi4 support. If not, checks for 64 bit x86.

	    if [[ $chip == "armv7l" || $chip == "armv8l" ]] ; then 		#32 bit Pi4
		curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0-arm-linux-gnueabihf.tar.gz ; fi

	    if [[ $chip == "aarch64" ]] ; then 				#64 bit Pi4 (same file as 32 bit)
		curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0-arm-linux-gnueabihf.tar.gz ; fi
		
	    if [[ $chip == "x86_64" ]] ; then 
		curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0-x86_64-linux-gnu.tar.gz ; fi


if ! sha256sum --ignore-missing --check SHA256SUMS ; then debug "Checksum failed. Aborting." ; exit 1 ; fi
enter_continue
set_terminal

#gpg check
echo " Please wait a moment for gpg verification..."
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys E777299FC265DD04793070EB944D35F9AC3DB76A

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
        exit 1
    fi
#unpack Bitcoin core:
set_terminal
mkdir $HOME/.parmanode/temp/ >/dev/null 2>&1
tar -xf bitcoin-* -C $HOME/.parmanode/temp/ >/dev/null 2>&1

# Move bitcoin program files to new directory.
# All binaries go to $HOME/parmanode/bitcoin.
mv $HOME/.parmanode/temp/b*/* $HOME/parmanode/bitcoin/

#delete sample bitcoin.conf to avoid confusion.
rm $HOME/parmanode/bitcoin/bitcoin.conf 

# "installs" bitcoin and sets to writing to only root for security. Read/execute for group and others. 
# makes target directories if they don't exist
# "install" is just a glorified copy command
sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/bitcoin/bin/*

sudo rm -rf $HOME/parmanode/bitcoin/bin
return 0     
}