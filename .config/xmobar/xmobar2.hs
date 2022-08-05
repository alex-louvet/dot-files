-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- https://github.com/vicfryzel/xmonad-config

-- This xmobar config is for a single 4k display (3840x2160) and meant to be
-- used with the stalonetrayrc-single config.
--
-- If you're using a single display with a different resolution, adjust the
-- position argument below using the given calculation.
Config {
    -- Position xmobar along the top, with a stalonetray in the top right.
    -- Add right padding to xmobar to ensure stalonetray and xmobar don't
    -- overlap. stalonetrayrc-single is configured for 12 icons, each 23px
    -- wide. 
    -- right_padding = num_icons * icon_size
    -- right_padding = 15 * 28 = 420
    -- Example: position = TopP 0 420
    position = TopP 0 0,
    font = "xft:JetBrainsMono Nerd Font-14",
    bgColor = "#1e1e2e",
    fgColor = "#cdd6f4",
    lowerOnStart = False,
    overrideRedirect = False,
    allDesktops = True,
    persistent = True,
    commands = [ Run StdinReader
        , Run Weather "LFPV" ["-t","<tempC>C <weather>","-L","10","-H","20","-n","#a6e3a1","-h","#f38ba8","-l","#89b4fa"] 36000
        , Run Weather "LFPO" ["-t","<tempC>C <weather>","-L","10","-H","20","-n","#a6e3a1","-h","#f38ba8","-l","#89b4fa"] 36000
        , Run Memory ["-t","Mem: <usedratio>%","-H","16000","-L","4096","-h","#f38ba8","-l","#89b4fa","-n","#a6e3a1"] 10
        , Run Cpu ["-L","3","-H","50","--normal","#a6e3a1","--high","#f38ba8"] 10
        , Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#f38ba8","-l","#89b4fa","-n","#a6e3a1"] 10
        , Run Network "enp42s0" ["-t","Net: D:<rx>/U:<tx>","-H","1000000","-L","1000","-h","#f38ba8","-l","#89b4fa","-n","#a6e3a1"] 10
        , Run Date "%a %b %_d %l:%M" "date" 10
        , Run Com "/home/alexandre/bin/volume" [] "volumelevel" 10
        , Run Kbd            [ ("fr" , "FR")
                             , ("us", "US")
                             ]
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "  %StdinReader% }{ <fc=#6c7086>||</fc> %cpu% %memory% %enp42s0% <fc=#6c7086>|</fc> <fc=#fab387>%kbd%</fc>  <fc=#94e2d5>Vol: %volumelevel%</fc> <fc=#6c7086>|</fc> <fc=#cba6f7>%date%</fc> "
}
