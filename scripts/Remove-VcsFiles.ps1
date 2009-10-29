## Removes all hidden Subversion folders in a folder recursively.
function Remove-SvnFiles ([string] $path = '.') {

    $folders = New-Object System.Collections.ArrayList

    Get-ChildItem $path -force -recurse | %{
        if ($_.PSIsContainer -and ($_.Name -eq '.svn' -or $_.Name -eq '_svn')) {
            [void] $folders.Add($_.FullName)
        }
    }

    foreach ($item in $folders) {
        Remove-Item $item -force -recurse
    }
}

## Removes all hidden Harvest signature files in a folder recursively.
function Remove-HarvestFiles([string] $path = '.') {

    $versionfiles = New-Object System.Collections.ArrayList

    Get-ChildItem $path -force -recurse | %{
        if ($_.Name -eq 'harvest.sig') {
            [void] $versionfiles.Add($_.FullName)
        }
    }

    foreach ($item in $versionfiles) {
        Remove-Item $item -force
    }
}
