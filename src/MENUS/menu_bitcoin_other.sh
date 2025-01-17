function menu_bitcoin_other {
while true
do
set_terminal
source ~/.parmanode/parmanode.conf >/dev/null #get drive variable

unset running output1 output2 
if [[ $OS == Mac ]] ; then
    if pgrep Bitcoin-Q >/dev/null ; then running=true ; else running=false ; fi
else
    if ! ps -x | grep bitcoind | grep -q "bitcoin.conf" >/dev/null 2>&1 ; then running=false ; fi
    if tail -n 1 $HOME/.bitcoin/debug.log | grep -q  "Shutdown: done" ; then running=false ; fi 2>/dev/null
    if pgrep bitcoind >/dev/null 2>&1 ; then running=true ; fi
fi


if [[ $bitcoinrunning != false ]] ; then running=true ; fi

if [[ $bitcoinrunning == true ]] ; then
output1="                   Bitcoin is$pink RUNNING$orange-- see log menu for progress"

output2="                         (Syncing to the $drive drive)"
else
output1="                   Bitcoin is$pink NOT running$orange -- choose \"start\" to run"

output2="                         (Will sync to the $drive drive)"
fi                         

echo -e "
########################################################################################
                            ${cyan}Bitcoin Core Menu - OTHER ${orange}                               
########################################################################################
"
echo -e "$output1"
echo ""
echo -e "$output2"
echo ""
echo -e "


      (cd)       Change syncing drive internal vs external

      (mp)       Modify Pruning

      (c)        How to connect your wallet...........(Otherwise no point to this)

      (dd)       Backup/Restore data directory.................(Instructions only)
       
      (r)        Errors? Try --reindex blockchain

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal

case $choice in
m|M) back2main ;;

cd|CD|Cd)
change_bitcoin_drive
return 0
;;

mp|MP)
modify_prune
;;

c|C)
connect_wallet_info
continue
;;

dd|DD)
echo "
########################################################################################
    
                          BACKUP BITCOIN DATA DIRECTORY    

    If you have a spare drive, it is a good idea to make a copy of the bitcoin data 
    directory from time to time. This could save you waiting a long time if you were 
    ever to experience data corruption and needed to resync the blockchain.

    It is VITAL that you stop bitcoind before copying the data, otherwise it will not 
    work correctly when it comes time toRU|Ru)
    umbrel_import_reverse
    ;; use the backed up data, and it's likely the 
    directory will become corrupted. You have been warned.

    You can copy the entire bitcoin_data directory.

    You could also just copy the chainstate directory, which is a lot smaller, and 
    this could be all that you need should there be a chainstate error one day. This 
    directory is smaller and it's more feasible to back it up frequently. I would 
    suggest doing it every 100,000 blocks or so, in addition to having a full copy 
    backed up if you have drive space somewhere.

    To copy the data, use your usual computer skills to copy files. The directory is 
    located either on the internal drive:

                        $HOME/.bitcoin

    or external drive:

                LINUX :   /media/$(whoami)/parmanode/.bitcoin 
                MAC   :   /Volumes/parmanode/.bitcoin

    Note that if you have an external drive for Parmanode, the internal directory 
    $HOME/.bitcoin is actually a symlink (shortcut) to the external 
    directory.

########################################################################################
"
enter_continue
continue
;;

r|R|reindex)
reindex_bitcoin
return 0
;;

p|P)
return 1
;;

q|Q|Quit|QUIT)
exit 0
;;

*)
invalid
continue
;;

esac

done
return 0
}

