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
import XMonad.Actions.SpawnOn
import XMonad.Layout
import XMonad.Layout.Spacing
-- import XMonad.Layout.NoBorders ( noBorders, smartBorders )

myStartupHook = do
    spawnOnce "picom --vsync -b"

myBorderWidth        = 5
myFocusedBorderColor = "#7FBBB3"
myNormalBorderColor  = "#A7C080"


myWorkspaces = map show [1..9]

myModMask  = mod4Mask
myTerminal = "kitty"
myKeys     = 
  [ ("M-v",                     toggleSmartSpacing)
  , ("<XF86MonBrightnessUp>",   spawn "light -A 5")
  , ("<XF86MonBrightnessDown>", spawn "light -U 5")
  , ("<XF86AudioRaiseVolume>",  raiseVolume 3 >> return ())
  , ("<XF86AudioLowerVolume>",  lowerVolume 3 >> return ())
  , ("<XF86AudioMute>",         toggleMute >> return ())
  , ("C-<Print>",               spawn "scrot -s")
  ]

-- myLayout = avoidStruts $ spacing 7 $ smartBorders tiled ||| smartBorders (Mirror tiled) ||| noBorders Full
myLayout = avoidStruts $ spacing 7 $ tiled ||| (Mirror tiled) ||| Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    delta   = 3 / 100
    ratio   = 1 / 2

mySB num = statusBarProp ( "xmobar -x " ++ show num ++ " ~/.config/xmobar/.xmobarrc") (pure myXmobarPP)

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
  { ppSep             = " | " 
  , ppCurrent         = xmobarColor "#7FBBB3" "" . wrap "[" "]"
  , ppVisible         = xmobarColor "#A7C080" "" . wrap "[" "]"
  , ppHidden          = xmobarColor "#E67E80" "" . wrap "(" ")"
  , ppHiddenNoWindows = xmobarColor "#D3C6AA" "" . wrap " " " "
  , ppTitle           = xmobarColor "#D3C6AA" "" . shorten 60
  , ppTitleSanitize   = xmobarStrip
  }

myConfig = def
  { modMask            = myModMask
  , terminal           = myTerminal
  , layoutHook         = myLayout
  , borderWidth        = myBorderWidth
  , startupHook        = myStartupHook
  , workspaces         = myWorkspaces
  , focusedBorderColor = myFocusedBorderColor
  , normalBorderColor  = myNormalBorderColor
  }
  `additionalKeysP` myKeys
