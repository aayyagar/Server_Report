Get-WindowsFeature | Where-Object {$_. installstate -eq "installed"} | Format-List Name,Installstate | more
