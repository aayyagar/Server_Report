#Haven't had time to include error handling yet but some day I will I promise :)

#Using PowerShell and ADSI
$DomainName = "Get-ADDomain | Select dnsroot -ExpandProperty dnsroot"
$ComputerName = "Server1"
$UserName = "username"
$AdminGroup = [ADSI]"WinNT://$ComputerName/Administrators,group"
$User = [ADSI]"WinNT://$DomainName/$UserName,user"
$AdminGroup.Add($User.Path)

#Using PSEXEC and CMD
psexec \\ComputerName net localgroup Administrators "DomainName\UserName" /add

#Add user to multiple computers
$ErrorActionPreference="SilentlyContinue"
$DomainName=Get-ADDomain | Select dnsroot -ExpandProperty dnsroot
$Computers="Server1","Server2","Server3"
$UserName ="username"
#Try both username and domain\username. It will work based on if the account is local or AD object

$User = [ADSI]"WinNT://$DomainName/$UserName,user"
ForEach($Computer in $Computers){
$AdminGroup = [ADSI]"WinNT://$Computer/Administrators,group"
 $AdminGroup.Add($User.Path)
 }