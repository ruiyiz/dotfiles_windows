# 
# From http://blogs.microsoft.co.il/blogs/scriptfanatic/archive/2008/06/29/powershell-at-the-tip-of-your-browser.aspx
#
function Get-SysInternals {
    param ( $sysIntDir="C:\Utils\Sysinternals\" )
    
    if (!$sysIntDir.endsWith("\")) 
    {
        $sysIntDir+="\"
    }

    $log = Join-Path $sysIntDir "changes.log"
    Add-Content -force $log -value "`n`n[$(get-date)]SysInternals sync has started"

    dir \\live.sysinternals.com\tools -recurse | %{ 

        $fileName = $_.name
        $localFile = Join-Path $sysIntDir $_.name                  
        $exist = Test-Path $localFile
        
        $msgNew = "new utility found: $fileName , downloading..."
        $msgUpdate = "file : $fileName  is newer, updating..."
        $msgNoChange = "nothing changed for: $fileName"
        
        if ($exist) {
            if ($_.lastWriteTime -gt (Get-Item $localFile).lastWriteTime) {
                Copy-Item $_.fullname $sysIntDir -force
                Write-Host $msgUpdate -fore yellow
                Add-Content -force $log -value $msgUpdate
            } else {
                Add-Content $log -force -value $msgNoChange
                Write-Host $msgNoChange
            }
        } else {
            if($_.extension -eq ".exe") {
                Write-Host $msgNew -fore green
                Add-Content -force $log -value $msgNew
            } 

            Copy-Item $_.fullname $sysIntDir -force 
        }
    }
}

