# ---------------------------------------------------------------------------
# Author:           Ruiyi Zhang
# Desc:             Personal PowerShell profile
# Last Modified:    09/14/2008
# Usage:            Source this file from the default PowerShell profile.
#
#                   ". $env:HOME\_profile.ps1"
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Set the $HOME variable for our use and make PowerShell recognize ~\ as
# $HOME in paths.
# ---------------------------------------------------------------------------
Set-Variable -name HOME -value (Resolve-Path $env:USERPROFILE) -force
(Get-PsProvider FileSystem).Home = $HOME

$PORTABLE_APPS      = "C:\PortableApps"
$APPS               = "C:\Apps"
$SCRIPTS            = "$HOME\scripts"

function script:Append-Path {
   $env:PATH += ';' + $args
}

& "$SCRIPTS\Set-DotNetEnv.ps1"

Append-Path $PORTABLE_APPS
Append-Path "$PORTABLE_APPS\Vim\vim72"
Append-Path "$PORTABLE_APPS\Notepad2"
Append-Path "$PORTABLE_APPS\Windows Resource Kit\Tools"
Append-Path "$PORTABLE_APPS\Sysinternals"
Append-Path "$PORTABLE_APPS\Reflector"
Append-Path "$PORTABLE_APPS\PuTTY"
Append-Path "$PORTABLE_APPS\PortableGit\cmd"

Append-Path $APPS
Append-Path "$APPS\IronPython26"

# ---------------------------------------------------------------------------
# Define Environment Variables
# ---------------------------------------------------------------------------
$env:GIT_SSH = "$PORTABLE_APPS\PuTTY\plink.exe"

# ---------------------------------------------------------------------------
# Define our prompt. Show '~' instead of $HOME (Gotten from tomasr)
# ---------------------------------------------------------------------------
function Shorten-Path([string] $path) {
   $loc = $path.Replace($HOME, '~')
   # remove prefix for UNC paths
   $loc = $loc -replace '^[^:]+::', ''
   # make path shorter like tabs in Vim,
   # handle paths starting with \\ and . correctly
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2')
}

function prompt {
   # our theme
   $cdelim = [ConsoleColor]::DarkCyan
   $chost = [ConsoleColor]::Green
   $cloc = [ConsoleColor]::Cyan

   write-host "$([char]0x0A7) " -n -f $cloc
   write-host ([net.dns]::GetHostName()) -n -f $chost
   write-host ' {' -n -f $cdelim
   write-host (shorten-path (pwd).Path) -n -f $cloc
   write-host '}' -n -f $cdelim
   return ' '
}

# ---------------------------------------------------------------------------
# Other helper functions
# ---------------------------------------------------------------------------
## Open the location in an Explorer window
function Open([string] $loc = '.') {
    explorer $loc
}

## Kicks off a garbage collection
function Run-GC() {
    [void]([System.GC]::Collect())
}

## Generate UUID
function Generate-UUID {
    [guid]::NewGuid().ToString('d')
}

function e([string] $path) {
    gvim $path
}

function n([string] $path) {
    Notepad2 $path
}

function u { cd .. }
function uu { cd ..\.. }
function uuu { cd ..\..\.. }
function uuuu { cd ..\..\..\.. }
function uuuuu { cd ..\..\..\..\.. }
function uuuuuu { cd ..\..\..\..\..\.. }

function ll { Get-ChildItem | Format-Wide -Column 5 }

. "$SCRIPTS\Get-Sysinternals.ps1"
. "$SCRIPTS\Remove-VcsFiles.ps1"
. "$SCRIPTS\Copy-Profile.ps1"
. "$SCRIPTS\MiscFunctions.ps1"

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
Set-Alias grep Select-String

# ---------------------------------------------------------------------------
# Set startup folder to home folder
# ---------------------------------------------------------------------------
Set-Location $HOME

