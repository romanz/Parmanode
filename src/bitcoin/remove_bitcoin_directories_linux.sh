function remove_bitcoin_directories_linux {

#Remove Parmanode/bitcoin directory (installation files)
sudo rm -rf $HOME/parmanode/bitcoin /dev/null 2>&1 

#check if data directory on external drive or internal drive
source $HOME/.parmanode/parmanode.conf   # gets drive choice

#check external drive first - mounted and unmounted conditions.

if [[ $drive == "external" && -d /media/$(whoami)/parmanode/.bitcoin ]] ; then #drive would have to be mounted to be true 
while true ; do
set_terminal
echo "
########################################################################################

    It appears there is a Bitcoin data directory on the external drive. Would like 
    to delete that data or leave it be (skip) ?

                            d)          delete

                            s)          skip

########################################################################################
"
choose "xq" ; read choice 
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "s" ]] ; then break ; fi
if [[ $choice == "d" ]] ; then 
    cd ; rm -rf /media/$(whoami)/parmanode/.bitcoin >/dev/null 2>&1 \
    || debug_point "Error deleting .bitcoin directory. Continuing." ;  break ; fi 
    
invalid #if all above if statements not true, then invalid choice and loop.
done
fi #end checking external drive for data directory

if [[ $drive == "external" && ! -d /media/$(whoami)/parmanode/.bitcoin ]] ; then        #potentially unmounted
    set_terminal ; echo "
########################################################################################

    Your settings indicate that you use an external drive for Bitcoin Core with
    the Parmanode software, however, a Bitcoin data directory has not been detected
    at the expected location.

    The directory may not exist, or the drive may not be connected.

    There is nothing you need to do to continue uninstalling Bitcoin, however, you
    will need to manually delete the data if you want to get rid of it. Or you
    can just format the drive by installing Bitcoin again with Parmanode.

########################################################################################
"
enter_continue
fi # ends response to drive=external but no directory found 

#check internal drive for data directory existance 
if [[ -d $HOME/.bitcoin && ! -L $HOME/.bitcoin ]] ; then    #checks for directory, and not a symlink
while true ; do
echo "
########################################################################################

    It appears there is a Bitcoin data directory on the internal drive at:
    
                            $HOME/.bitcoin

    Would like to delete that data or leave it be (skip) ?

                            d)          delete

                            s)          skip 
                                
    If skipping, and you have chosen an external drive, it will be renamed 
    to .bitcoin_backup0 in order to created a symlink to the external drive of the
    same name.

########################################################################################
"
choose "xq" ; read choice 
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "s" ]] ; then 
            if [[ $drive == "external" ]] ; then make_backup_dot_bitcoin ; fi
            break ; fi
if [[ $choice == "d" ]] ; then 
    cd ; rm -rf $HOME/.bitcoin >/dev/null 2>&1 \
    || debug_point "Error deleting .bitcoin directory. Continuing." ; break ; fi 
    
invalid #if all above if statements not true, then invalid choice and loop.
done
fi #end checking internal drive for .bitoin directory

#Remove symlink to drive
if [[ -L "$HOME/.bitcoin" ]] 2>/dev/null ; then rm $HOME/.bitcoin ; fi      #symlink deleted if it exists

return 0
}