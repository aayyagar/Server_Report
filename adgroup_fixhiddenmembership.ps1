#Use this sample script as a fix if you ever find yourself in a situation where membership of a DL is hidden and it is causing issues with your inhouse DL management tools or with Office 365 (because currently, O365 does not support hidden membership)
#This is mainly cuased because when this attribute was used in Exchange 2007 and prior, it made an explicit deny ACL entry for Everyone

#Enter the DL name
$DLName="PentagonSecurityLeads"
$DLdn=Get-ADGroup $DLName | Select -Property distinguishedname -ExpandProperty DistinguishedName

#Export members as a backup:
$Users=Get-ADGroupMember "$DLDn"
$Users | Export-Csv C:\Temp\$DLName.csv -NoTypeInformation

dsacls "$DLdn" /G Everyone:GR
Set-ADGroup "$DLdn" -Clear hideDLMembership

#Optionally move the Object somewhere else like a parent OU for DLs
Move-ADObject "$DLdn" -TargetPath "OU=Distribution Lists,DC=Washington,DC=Pentagon,DC=lab,DC=com"