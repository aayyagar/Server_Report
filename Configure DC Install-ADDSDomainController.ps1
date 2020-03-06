#After successful role service Installation, next step is to configure the domain controller. It can be done using following PowerShell command. 
 
Install-ADDSDomainController
-CreateDnsDelegation:$false
-InstallDns:$true
-DomainName "rebeladmin.com"
-SiteName "Default-First-Site-Name"
-ReplicationSourceDC "REBEL-WIN-DC01.rebeladmin.com"
-DatabasePath "C:\Windows\NTDS"
-LogPath "C:\Windows\NTDS"
-SysvolPath "C:\Windows\SYSVOL"
-Force:$true 