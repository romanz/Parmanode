function uninstall_fulcrum_docker {
set_terminal ; while true ; do
echo "
########################################################################################

    This will uninstall Fulcrum only. If you want to uninstall Docker as well, you 
    can do that afterwards from within the Docker application.

########################################################################################        
"
choose "epq" ; read choice
case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; 
"") break ;;
*) invalid ;; esac ; done

#uninstall....
please_wait

if ! grep -q "fulcrum" $HOME/.parmanode/installed.conf >/dev/null 2>&1 ; then
    set_terminal 
    echo "Fulcrum is not installed. You can skip uninstallation."
    enter_continue
    return 1 
    fi

rm -rf $HOME/parmanode/fulcrum >/dev/null 2>&1 
rm -rf $HOME/parmmanode/fulcrum_db >/dev/null 2>&1 
rm -rf /Volumes/parmanode/fulcrum_db >/dev/null 2>&1

stop_and_remove_docker_containers_and_images_fulcrum

delete_line "$HOME/.parmanode/parmanode.conf" "fulcrum"
delete_line "$HOME/.parmanode/installed.conf" "fulcrum"

return 0

}

function stop_and_remove_docker_containers_and_images_fulcrum {

docker stop fulcrum >/dev/null 2>&1 && log "fulcrum" "fulcrum container stopped"
docker rm fulcrum >/dev/null 2>&1 && log "fulcrum" "fulcrum container deleted"
docker rmi fulcrum >/dev/null 2>&1 && log "fulcrum" "fulcrum image deleted "

}