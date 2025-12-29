function update --wraps='sudo apt update && sudo apt upgrade && snap refresh && sudo bash /home/allouvet/Downloads/zen.sh --install' --description 'alias update=sudo apt update && sudo apt upgrade && sudo snap refresh && sudo bash /home/allouvet/Downloads/zen.sh --install'
  sudo apt update && sudo apt upgrade && sudo snap refresh && uv tool upgrade --all $argv
        
end
