import XMonad

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce

import XMonad.Actions.Volume
import XMonad.Layout
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders ( noBorders, smartBorders )

myStartupHook = do
  spawnOnce "xset r rate 150 40"
  spawnOnce "setxkbmap -option caps:super -option compose:ralt"
  spawnOnce "picom --vsync -b"

myModMask  = mod4Mask
myTerminal = "kitty"
myKeys     = 
  [ ("M-u",                     spawn "firefox")
  , ("M-v",                     toggleSmartSpacing)
  , ("<XF86MonBrightnessUp>",   spawn "light -A 5")
  , ("<XF86MonBrightnessDown>", spawn "light -U 5")
  , ("<XF86AudioRaiseVolume>",  raiseVolume 3 >> return ())
  , ("<XF86AudioLowerVolume>",  lowerVolume 3 >> return ())
  , ("<XF86AudioMute>",         toggleMute >> return ())
  ]

myLayout = avoidStruts $ spacing 5 $ smartBorders tiled ||| smartBorders (Mirror tiled) ||| noBorders Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    delta   = 3 / 100
    ratio   = 1 / 2

-- mySB num = statusBarProp ( "xmobar -x " ++ show num ++ " ~/.config/xmobar/xmobarrc") (pure myXmobarPP)
mySB num = statusBarProp ( "xmobar" ) (pure myXmobarPP)

main :: IO ()
main = xmonad 
     . ewmhFullscreen 
     . ewmh
     . withEasySB (mySB 0) toggleStrutsKey
     . withEasySB (mySB 1) toggleStrutsKey
     $ myConfig
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig { modMask = myModMask } = (myModMask, xK_b)

myXmobarPP :: PP
myXmobarPP = def
  { ppSep = xmobarColor "#ff79c6" "" " . " 
  , ppTitleSanitize = xmobarStrip
  }

myConfig = def
  { modMask     = myModMask
  , terminal    = myTerminal
  , layoutHook  = myLayout
  , startupHook = myStartupHook
  }
  `additionalKeysP` myKeys  
