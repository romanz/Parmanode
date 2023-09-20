function menu_main {
while true ; do
set_terminal_bit_higher #custom function to resize the window

# if statements in the menu printout makes the menu dynamic, ie changes accoring to the
# tests performed. Variables are set to assit logic in the menu choice excution part
# of the code at the bottom.
echo "
########################################################################################
#                                                                                      #
#    P A R M A N O D E -- Main Menu                                                    #
#                                                                                      #
########################################################################################
#                                                                                      #"
if ! grep -q "parmanode" $HOME/.parmanode/installed.conf >/dev/null 2>&1 ; then parmanodemain=1
echo "#    (i)                  Install Parmanode          [DO THIS FIRST!!]                 #"
else parmanodemain=0
echo "#    (add)                Add more programs (Install menu)                             #
#                                                                                      #
#    (u)                  Use programs (Apps menu)........(Bitcoin, Sparrow, etc)      #
#                                                                                      #" ; fi

echo "#--------------------------------------------------------------------------------------#
#                                                                                      #
#    (remove)             Remove (uninstall) programs                                  #
#                                                                                      #
#    (l)                  See logs and configuration files                             #
#                                                                                      #
#    (e)                  Education                                                    #
#                                                                                      #
#    (t)                  Tools                                                        #
#                                                                                      #
#    (d)                  Donate ;)                                                    #
#                                                                                      #
#    (uninstall)          Uninstall Parmanode ..........(Who'd do such a thing?)       #
#                                                                                      #
#    (update)             Update Parmanode                                             #
#                                                                                      #
#    (ap)                 About Parmanode                                              #
#                                                                                      #
########################################################################################
"
choose "xq" # custom fuction to print a prompt. Different argumens give different messages
# "xq" means add a prompt about choosing and one about how to quit.
echo "
(Note, <enter> is the same as <return>)"
read choice #whatever the user chooses, it gets put into the choice variable used below.
set_terminal

case $choice in #the variable choice is tested through each of the case-choices below.
# these end in a closing bracked, have some code, and end with a ;;
# once there is a match, the case block is exited (after the esac point below). Then
# it repeats because case is inside a while loop.
i|I)
    if [[ $parmanodemain == 1 ]] ; then # this variable makes install_parmanode only available to execute if
    # parmanodemain is set to 1, otherwise, the function can't run even if the user types "i".
    install_parmanode 
    fi
    ;;
add|Add| ADD)
    if [[ $parmanodemain == 0 ]] ; then # with parmanodemain set to 0, it's possible to add programs
    menu_add_programs
    fi
    ;;
use|USE|Use|u|U)
    if [[ $parmanodemain == 0 ]] ; then
    menu_programs 
    fi 
    ;;
remove|REMOVE)
    remove_programs ;;
l|L) 
    menu_log_config ;;
e|E)
    education ;;
t|T)
    menu_tools ;;
d|D)
    donations ;;
uninstall|UNINSTALL)
    uninstall_parmanode ;;
update|UPDATE|Update)
    update_parmanode ;;
ap|AP|Ap|aP)
    about ;;
q | Q | quit)
    exit 0 ;;
*)
    invalid ;;
esac ; done ; return 0
}