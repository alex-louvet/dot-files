-- xmonad config used by Vic Fryzel
-- Author: Vic Fryzel
-- https://github.com/vicfryzel/xmonad-config

import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.LayoutModifier
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.SpawnOnce
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map        as M


------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "alacritty"

-- The command to lock the screen or show the screensaver.
myScreensaver = "betterlockscreen -l blur"

-- The command to take a selective screenshot, where you select
-- what you'd like to capture on the screen.
mySelectScreenshot = "flameshot"

-- The command to take a fullscreen screenshot.
myScreenshot = "screenshot"

-- The command to use as a launcher, to launch commands that don't have
-- preset keybindings.
myLauncher = "dmenu_run -l 20 -fn 'JetBrainsMono Nerd Font-14' -nb '#1e1e2e' -nf '#cdd6f4' -sb '#cba6f7' -sf '#313244' -nhb '#1e1e2e' -nhf '#cba6f7' -shb '#cba6f7' -shf '#11111b'"

-- Location of your xmobar.hs / xmobarrc
myXmobarrc = "~/.config/xmobar/xmobar.hs"

myBrowser = "librewolf"

myFM = "nautilus"


------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = ["term","code","web","mail","socials","files","music", "live", "txt"]


------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "firefox"       --> doShift "web"
    , className =? "librewolf"       --> doShift "web"
    , className =? "Thunderbird"       --> doShift "mail"
    , className =? "Ferdi"       --> doShift "socials"
    , className =? "discord"       --> doShift "socials"
    , className =? "Spotify"       --> doShift "music"
    , resource  =? "desktop_window" --> doIgnore
    , className =? "Galculator"     --> doFloat
    , className =? "Steam"          --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "osu!"           --> doFloat
    , className =? "qemu"           --> doFloat
    , className =? "virt-manager"   --> doFloat
    , resource  =? "gpicview"       --> doFloat
    , className =? "MPlayer"        --> doFloat
    , className =? "stalonetray"    --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]


------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

myLayout = avoidStruts (tiled ||| threeCol ||| mirror ||| Full) ||| fullFull
  where
    tiled = mySpacing 2 $ (Tall 1 (3/100) (1/2))
    threeCol = mySpacing 2 $ (ThreeColMid 1 (3/100) (1/2))
    mirror = mySpacing 2 $ (Mirror (Tall 1 (3/100) (1/2))) 
    fullFull = noBorders (fullscreenFull Full)


------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
myNormalBorderColor  = "#1e1e2e"
myFocusedBorderColor = "#cba6f7"

-- Color of current window title in xmobar.
xmobarTitleColor = "#eba0ac"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#cba6f7"

-- Width of the window border in pixels.
myBorderWidth = 1


------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask , xK_k),
     spawn $ XMonad.terminal conf)

  -- Lock the screen using command specified by myScreensaver.
  , ((modMask, xK_l),
     spawn myScreensaver)

  -- Start web browser using command specified by myBrowser.
  , ((modMask, xK_f),
     spawn myBrowser)

  -- Start file manager using command specified by myFM.
  , ((modMask, xK_g),
     spawn myFM)

  -- Spawn the launcher using command specified by myLauncher.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_space),
     spawn myLauncher)

  -- Take a selective screenshot using the command specified by mySelectScreenshot.
  , ((modMask .|. shiftMask, xK_p),
     spawn mySelectScreenshot)

  -- Take a full screenshot using the command specified by myScreenshot.
  , ((modMask .|. controlMask .|. shiftMask, xK_p),
     spawn myScreenshot)

  -- Mute volume.
  , ((0, xF86XK_AudioMute),
     spawn "amixer -q set Master toggle")

  -- Decrease volume.
  , ((0, xF86XK_AudioLowerVolume),
     spawn "amixer -q set Master 5%-")

  -- Increase volume.
  , ((0, xF86XK_AudioRaiseVolume),
     spawn "amixer -q set Master 5%+")

  -- Mute volume.
  , ((modMask .|. controlMask, xK_m),
     spawn "amixer -q set Master toggle")

  -- Change Keyboard layout
  , ((modMask .|. controlMask ,       xK_space     ), spawn "bash ~/bin/kbswitch")
  
  -- Run freetube
  , ((modMask,       xK_Y     ), spawn "freetube")

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --
  , ((modMask , xK_q     ), kill)

  , ((modMask,               xK_Tab ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
  , ((modMask .|. shiftMask, xK_Tab ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
  , ((modMask .|. shiftMask,               xK_n     ), refresh)

    -- Move focus to the next window
  , ((modMask,               xK_Left     ), windows W.focusDown)

    -- Move focus to the previous window
  , ((modMask,               xK_Right     ), windows W.focusUp  )

    -- Move focus to the master window
  , ((modMask,               xK_Return),  windows W.swapMaster  )

    -- Swap the focused window with the next window
  , ((modMask .|. shiftMask, xK_Left     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
  , ((modMask .|. shiftMask, xK_Right     ), windows W.swapUp    )

    -- Shrink the master area
  , ((modMask .|. mod1Mask,               xK_Left     ), sendMessage Shrink)

    -- Expand the master area
  , ((modMask .|. mod1Mask,               xK_Right     ), sendMessage Expand)

    -- Push window back into tiling
  , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
  , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
  , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

      -- Quit xmonad
  , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

  -- Restart picom
  , ((modMask .|. shiftMask, xK_r), spawn "bash ~/bin/picom-restart")
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]


------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--


------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    spawnOnce "bash ~/.config/polybar/launch.sh"
    setWMName "XMonad"


------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = do
  -- xmproc <- spawnPipe ("xmobar -x 0 " ++ myXmobarrc)
  -- xmproc2 <- spawnPipe ("xmobar -x 1 /home/alexandre/.config/xmobar/xmobar2.hs")
  xmonad $ docks $ ewmh $ defaults {
      manageHook = manageDocks <+> myManageHook
  }


------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = smartBorders $ myLayout,
    manageHook         = myManageHook,
    startupHook        = myStartupHook
}
