# Defined via `source`
function wiki --wraps='nvim /home/alexandre/vimwiki/index.md' --description 'alias wiki nvim /home/alexandre/vimwiki/index.md'
  cd /home/alexandre/Dropbox/wiki/ && nvim index.md; 
end
