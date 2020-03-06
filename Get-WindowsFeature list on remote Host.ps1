Get-WindowsFeature -ComputerName dc01 | Where-Object {$_. installstate -eq "installed"} | Format-List Name,Installstate | more
