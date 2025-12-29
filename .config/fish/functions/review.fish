function review
  echo [$argv]
  set continueedit true
  while $continueedit
    csvlook csv/$argv.csv && evince pdf/$argv.pdf
    read -l -P "Edit [y/n]" edit
    switch $edit
      case y
        v csv/$argv.csv
    case '*'
        set continueedit false
    end
  end
  read -l -P "Conform? [y/n/a]" reply
    switch $reply
      case n
        mv csv/$argv.csv uncat/csv/
        mv pdf/$argv.pdf uncat/pdf/
        mv html/$argv.html uncat/html/
      case a
        pass
      case '*'
        mv csv/$argv.csv parsed/csv/
        mv pdf/$argv.pdf parsed/pdf/
        mv html/$argv.html parsed/html/
    end
end
