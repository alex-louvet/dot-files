#!/bin/bash 

# Exit menu for Sway using wofi launcher

 # Define location of config and style files
 conf="$HOME/.config/wofi/extra/exit-config"
 style="/home/alexandre/.config/wofi/style.css"   # Same as default wofi launcher 

 
 # Define the menu options 
 options=("\t🔒 Lock\n" "\t⏸ Sleep\n" "\t⏏ Logout\n" "\t🔄 Reboot\n" "\t⏻ Shutdown") 
  
 # Show the menu and get the user's choice 
 sel_option=$(echo -e "${options[@]}" | wofi --dmenu --conf=$conf --style=$style --prompt "Select an option:") 
  
 # Check if the user selected an option 
 if [[ -n $sel_option ]]; then 
     # Extract the action part without the glyph 
     action=$(echo "$sel_option" | awk '{print $NF}') 
  
     # Ask for confirmation 
     confirm=$(echo -e "Yes\nNo\n" | wofi --dmenu --conf=$conf --style=$style --prompt "Confirm $action ?") 
  
     # If the user confirmed, execute the selected option 
     if [[ $confirm == "Yes" ]]; then 
         case $action in 
             "Lock") 
                  hyprlock 
                 ;; 
             "Sleep") 
                 # mpc -q pause 
                 # amixer set Master mute 
                 systemctl suspend 
                 ;; 
             "Logout") 
                 hyprctl dispatch exit 
                 ;; 
             "Reboot") 
                 systemctl reboot 
                 ;; 
             "Shutdown") 
                 systemctl poweroff 
                 ;; 
         esac 
     fi 
 fi 
  
 # Exit the script 
 exit 0
