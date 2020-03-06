<#Active Directory Domain Services uses AdminSDHolder, protected groups and Security Descriptor propagator (SD propagator or SDPROP for short) to secure privileged users and groups from unintentional modification. This functionality was introduced in the inaugural release of Active Directory in Windows 2000 Server and it's fairly well known. However, virtually all IT administrators have been negatively impacted by this functionality, and that will to continue unless they fully understand how AdminSDHolder, protected groups and SDPROP work

Simply put let's Bob is a Domain Admin
Because of this AD assigns the adminCount attribute a value of 1 which protects anyone but a Domain Admin modify Bob's account
When we remove Bob from Domain Admins group, his AD Account is still protected because the attribute is not cleared by default, we have to do it manually. That's where this script comes into place

Read more about AdminCount here https://technet.microsoft.com/en-us/magazine/2009.09.sdadminholder.aspx

This PowerShell script will perform the following actions on an Active Directory Object
1) Clear AdminCount attribute
2) Assign ownership of the Object to Domain Admins
3) Grant Domain Admin Full Permissions (In some occasions I have noticed you need to first grant Full Permissions to Domain Admins and then
restore default. Haven't seen the occurence again so couldn't investigate)
4) Restore default permissions.
#>

#Even though the commands in this script are starightforward, we will stop the script if there are any errors
$ErrorActionPreference="Stop"

#Specify the OU to search for Admin Users and Groups
$OU="OU=People,OU=Starks,OU=Castle Black,DC=Winterfell,DC=com"

#Specify the path for reports for a list of AD Objects being modified and their ACLs
$ReportPath="$env:USERPROFILE"
$AdminObjects=Get-ADObject -SearchBase $OU -Filter {adminCount -eq "1"}  | Select DistinguishedName -ExpandProperty DistinguishedName

#Export the current list as a precaution
$AdminObjects | Out-File "$ReportPath\AdminObjects.csv"

#Now lets do the magic
ForEach ($Admin in $AdminObjects) {

#Oh Wait, let's export the current ACL of these objects as a backup.
#You never know that one admin from 20 years ago could have set some weird permissions

(Get-ACL "AD:$($Admin)").access | Select @{Expression={$Admin};Label="AdminObject"},* | Export-Csv "$ReportPath\AdminObject_SecurityACL.csv" -Append -NoTypeInformation

#First clear the admincount attribute so the protection is removed
Set-ADObject "$Admin" -Clear "adminCount"

#Assign ownerhsip to Domain Admins
DSACLS "$Admin" /takeownership

#Grant Domain Admins full permissions
DSACLS "$Admin" /G '"Domain Admins":GA'

#Reset Default ACL
DSACLS "$Admin" /resetDefaultDACL

}