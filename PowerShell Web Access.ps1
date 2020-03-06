#PowerShell Web Access
Install-Windowsfeature WindowsPowerShellWebaccess -IncludeManagementTools
 
Install-PswaWebApplication -UseTestCertificate
 
Add-PswaAuthorizationRule -UserName * -ComputerName * -ConfigurationName *