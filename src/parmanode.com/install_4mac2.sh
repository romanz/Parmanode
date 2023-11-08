return 0
########################################################################################
# This is the install script kept at
# https://parmanode.com/install_4mac2.sh - the URL is easier to remember and shorter 
# than if keeping it on Github.


########################################################################################
#!/bin/sh

printf '\033[8;38;88t' && echo -e "\033[38;2;255;145;0m" 

if [ -d $HOME/parman_programs/parmanode ] ; then
clear
#update parmanode if it exists...
cd $HOME/parman_programs/parmanode && git config pull.rebase false && git pull >/dev/null 2>&1

#make desktop clickable icon...
if [ ! -e $HOME/Desktop/run_parmanode.sh ] ; then
cat > $HOME/Desktop/run_parmanode.sh << 'EOF'
#!/bin/bash
cd $HOME/parman_programs/parmanode/
./run_parmanode.sh
EOF
sudo chmod +x $HOME/Desktop/run_parmanode*
echo "New clickable desktop icon made."
fi

#no further changes needed.
echo "Parmnode already downloaded."
exit
fi

########################################################################################
#Check mac version 10.9 or later...

export MacOSVersion=$(sw_vers | grep ProductVersion | awk '{print $ 2}')
export MacOSVersion_major=$(sw_vers | grep ProductVersion | cut -d \. -f 1)
export MacOSVersion_minor=$(sw_vers | grep ProductVersion | cut -d \. -f 2)
export MacOSVersion_patch=$(sw_vers | grep ProductVersion | cut -d \. -f 3)

if [[ ($MacOSVersion -lt 10) || ($MacOSVersion == 10 && $MacOSVersion_major -lt 9) ]] ; then
clear
echo "
########################################################################################

    Sorry, you need MacOS version 10.9 or later to use Parmanode.

########################################################################################
    Hit <enter> to continue.
"
read
exit 0
fi

while true ; do #loop 1
if xcode-select -p >/dev/null 2>&1 ; then break ; fi

#Install cldts
clear
sudo -k
echo "
########################################################################################
   
   Command Line Developer Tools is needed.

   There will be a pop up question which you'll need to respond to. The install
   estimate will initially say some HOURS, but ignore that, it's wrong.

   Once Command Line Tools have successfully installed, enter your computer password,
   then <enter> to continue.

   Hit <enter> ONLY after the pop up has finished installeding, and not before, or 
   your computer will melt.
 
   If you want to abandon, you can hit <control> c now.

####################################################################################### 
"
xcode-select --install

sudo sleep 0.1break
done #ends loop 1

########################################################################################
#Installing Parmanode

mkdir -p $HOME/parman_programs >/dev/null 2>&1 
cd $HOME/parman_programs
git clone https://github.com/armantheparman/parmanode.git

#make desktop clickable icon...
cat > $HOME/Desktop/run_parmanode.sh << 'EOF'
#!/bin/bash
cd $HOME/parman_programs/parmanode/
./run_parmanode.sh
EOF
sudo chmod +x $HOME/Desktop/run_parmanode.sh >/dev/null 2>&1
clear
echo "
########################################################################################

    There should be an icon on the desktop for you, \"run_parmanode.sh\".

    If you double click it, and your Mac is configured to open a text editor instead
    of running the program, that can be overcome by typing this in Terminal:


            cd $HOME/parman_programs_parmanode       <enter>
    then
            ./run_parmanode.sh                       <enter> 


    It's case sensitive.

########################################################################################
"
exit