import XMonad
import XMonad.Layout
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig (additionalKeysP)

-- Stuff for xmobar
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

myTerminal = "kitty"
myModMask  = mod4Mask -- Rebind Mod to the Super key

myConfig = def
    { modMask    = myModMask
    , terminal   = myTerminal
    } 
  `additionalKeysP`
  [ ("M-y", spawn "firefox" )
  , ("M-u", spawn "keepassxc" )
  ]
  
main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . xmobarProp $ myConfig
