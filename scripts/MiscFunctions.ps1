function Kill-McAfee {
   Get-Process | where {$_.Company -like "McAfee*"} | Stop-Process
}
