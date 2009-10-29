function IsVista {
    [System.Environment]::OSVersion.Version.Major -ge 6
}

# 
# creates the links in $HOME to our dotfiles repo
# requires linkd.exe from the Windows Server 2003 RK
#
function Copy-Profile ([string] $path = '.') {
    Get-ChildItem $path | %{
        if ( !($_.Name.Equals('others') -and $_.PSIsContainer) -and !$_.Name.Equals('.git') ) {
            if ( test-path "~\$($_.Name)" ) {
                if ( $_.PSIsContainer ) {
                    # unlink first
                    linkd.exe "$HOME\$($_.Name)" /d
                } else {
                    rm -r -force "~\$($_.Name)"
                }
            }

            if ( $_.PSIsContainer ) {
                linkd.exe "$HOME\$($_.Name)" $_.FullName
            } else {
                #if ( IsVista ) {
                #    New-Symlink "$HOME\$($_.Name)" $_.FullName
                #} else {
                    #fsutil hardlink create "$HOME\$($_.Name)" $_.FullName
                    Copy-Item $_.FullName "$HOME\$($_.Name)"
                #}
            }

            # set softlinks to folders invisible
            Set-ItemProperty "$HOME\$($_.Name)" -Name Attributes -Value "Hidden"
        }
    }
}

