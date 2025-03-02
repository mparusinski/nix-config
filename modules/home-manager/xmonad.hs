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
import XMonad.Layout.NoBorders ( noBorders, smartBorders )

import System.Process
import GHC.IO.Handle
import Text.Read (readMaybe)

data DPI = HiDPI | LowDPI

myStartupHook = do
    spawnOnce "picom --vsync -b"

myBorderWidth HiDPI  = 5
myBorderWidth LowDPI = 3
myFocusedBorderColor = "#E69875"
myNormalBorderColor  = "#9DA9A0"

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
  , ("C-'",                     spawn "~/.local/bin/switch-dpi.sh; killall xmobar; xmonad --restart")
  ]

myLayout = avoidStruts $ spacing 7 $ smartBorders tiled ||| smartBorders (Mirror tiled) ||| noBorders Full
-- myLayout = avoidStruts $ spacing 7 $ tiled ||| (Mirror tiled) ||| Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    delta   = 3 / 100
    ratio   = 1 / 2

mySB num dpi = statusBarProp ( "xmobar -x " ++ show num ++ dpiConf dpi) (pure myXmobarPP)
  where dpiConf LowDPI = " ~/.config/xmobar/xmobarrc.lowdpi"
        dpiConf HiDPI  = " ~/.config/xmobar/xmobarrc.hidpi"

fetchDPI :: IO DPI
fetchDPI = do
  (_, maybeOutH, _, _) <- createProcess shellCmd { std_out = CreatePipe }
  maybe (return HiDPI) processOut maybeOutH
  where shellCmd = shell "~/.local/bin/what-dpi.sh"
        processOut :: Handle -> IO DPI
        processOut h = do
          output <- hGetLine h
          let currDpi = readMaybe output :: Maybe Int
          return $ maybe HiDPI intToDPIEnum currDpi
          where intToDPIEnum x = if x == 96 then LowDPI else HiDPI

main :: IO ()
main = do
  dpi <- fetchDPI
  xmonadMain dpi
  where xmonadMain dpi = xmonad
                       . ewmhFullscreen
                       . ewmh
                       . withEasySB (mySB 0 dpi) toggleStrutsKey
                       . withEasySB (mySB 1 dpi) toggleStrutsKey
                       $ myConfig dpi
                       where toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
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

myConfig dpi = def
  { modMask            = myModMask
  , terminal           = myTerminal
  , layoutHook         = myLayout
  , borderWidth        = myBorderWidth dpi
  , startupHook        = myStartupHook
  , workspaces         = myWorkspaces
  , focusedBorderColor = myFocusedBorderColor
  , normalBorderColor  = myNormalBorderColor
  }
  `additionalKeysP` myKeys
