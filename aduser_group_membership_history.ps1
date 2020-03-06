#requires -version 3.0
# Show a user's group memberships and the dates they were added to those groups.

Import-Module ActiveDirectory

$username = "jsnow"
$userobj  = Get-ADUser $username
$DC = (Get-ADDomainController -Discover | Select-Object HostName -ExpandProperty HostName)
Get-ADUser $userobj.DistinguishedName -Properties memberOf |
 Select-Object -ExpandProperty memberOf |
 ForEach-Object {
    Get-ADReplicationAttributeMetadata $_ -Server $DC -ShowAllLinkedValues | 
      Where-Object {$_.AttributeName -eq 'member' -and 
      $_.AttributeValue -eq $userobj.DistinguishedName} |
      Select-Object FirstOriginatingCreateTime, Object, AttributeValue
    } | Sort-Object FirstOriginatingCreateTime -Descending | Out-GridView

###############################################################################
# Here are some one-liners for exploring:
#Get-ADUser 'CN=jsnow,OU=Migrated,DC=CohoVineyard,DC=com' -Properties memberOf
#Get-ADGroup 'CN=Legal,OU=Groups,DC=CohoVineyard,DC=com' -Properties member, members, memberOf
#Get-ADReplicationAttributeMetadata 'CN=Legal,OU=Groups,DC=CohoVineyard,DC=com' -Server $DC -ShowAllLinkedValues | Out-GridView
###############################################################################
# This works at the cmd line but not in PS console.
# However, it does not include the date data.
#Repadmin.exe /showobjmeta localhost "CN=Legal,OU=Migrated,DC=CohoVineyard,DC=com" | find /i "jsnow"
###############################################################################
