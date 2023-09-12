# Functions...
    # which_os
    # Linux_distro
    # check_if_win7
    # get_ip_address
    # IP_address
    # get_linux_version_codename 
    # check_chip

function which_os {
# This function just extracts and stores the operating system name

if [[ "$(uname -s)" == "Darwin" ]] #uname gives useful info about the system.
then
    export OS="Mac"
    if [[ -e $HOME/.parmanode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >/dev/null ; fi
    # This is adding the variable to a configuration file.
    # Parmanode_conf_add takes an argument (the text after it is called) and addes that to 
    # The parmanode.conf file
    # I later realised this is unncessary if I just "export" the variable, making it always available
    # I'll clean up the code later.
    return 0 
fi

if [[ "$(uname -s)" == "Linux" ]]
then
    export OS="Linux"
    if [[ -e $HOME/.parmnode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >/dev/null ; fi
    return 0
fi

if [[ "$(uname -s)" == "MINGW32_NT" || "$(uname -s)" == "MINGW64_NT" ]]
then
    check_if_win7
    if [[ -e $HOME/.parmanode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >/dev/null ; fi
    exit 1
fi
exit 1
}
function Linux_distro {
    
if [[ $OS == "Linux" ]] ; then

    if [ -f /etc/debian_version ]; then
    parmanode_conf_add "Linux=Debian"

    elif [ -f /etc/lsb-release ]; then
    parmanode_conf_add "Linux=Ubuntu"

    else
    parmanode_conf_add "Linux=Unknown"

    fi

else
    return 1
fi

return 0
}



function check_if_win7 {
# will return win7+, linux, or not_win string.
if [[ $(uname -s) == MINGW* ]] ; then
    version=$(wmic os get version | grep -oE "[0-9]+.[0-9]+")
    if (( $(echo "$version >= 6.1" | bc -l) )) ; then
        OS="Win"
    else
        OS="Win_old"
    fi
else
    OS="Not_Win"
fi
return 0
}

function get_ip_address {
if [[ $OS == "Linux" ]] ; then export IP=$( ip a | grep "inet " | grep -v 127.0.0.1 | grep -v 172.1 | awk '{print $2}' | cut -d '/' -f 1 | head -n1 ) ; fi
if [[ $OS == "Mac" ]] ; then export IP=$( ifconfig | grep "inet " | grep -v 127.0.0.1 | grep -v 172.1 | awk '{print $2}' | head -n1 ) ; fi
# Through a series of searches (grep), the results being passed by the | symbol to the right and being
# searched on again, the results are narrowed down.
# awk is used to print out a field (like selecting a column in an excel row), and cut
# can split text according to a delimeter (-d) and choosing a resulting field (-f)
}

function IP_address {
#IP variable is printed for the user.
clear
echo "
########################################################################################


    Your computer's IP address is:                                $IP



    Your computer's "self" IP address should be:                  127.0.0.1



    For reference, every computer's default self IP address is    127.0.0.1 
                                                            or    localhost


########################################################################################
"
enter_continue
return 0
}

function get_linux_version_codename {
. /etc/os-release && VC=$VERSION_CODENAME
. $HOME/.parmanode/parmanode.conf #(fix ID variable)



# Linux Mint has Ubunta equivalents for this purpose
if [[ $VC == "vera" ]] ; then VCequivalent="jammy" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "vanessa" ]] ; then VCequivalent="jammy" ; parmanode_conf_add "VCequivalent=$VCequivalent"  
elif [[ $VC == "una" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "uma" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent" 

elif [[ $VC == "ulyssa" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent"  
elif [[ $VC == "ulyana" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "tricia" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent"
elif [[ $VC == "tina" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent"  
elif [[ $VC == "tessa" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "tara" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "elsie" ]] ; then VCequivalent="bullseye" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
#new 

elif [[ $VC == "victoria" ]] ; then VCequivalent="jammy" ; parmanode_conf_add "VCequivalent=$VCequivalent"  

else
VCequivalent=$VC
fi
parmanode_conf_add "VCequivalent=$VCequivalent"

}

function check_chip {

#Expected resulting options
    # x86_64, arm64, aarch64, armv6l, armv7l


export chip="$(uname -m)" >/dev/null 2>&1

parmanode_conf_add "chip=$chip"

}