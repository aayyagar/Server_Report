#How to allow anyone (internal or external to be able to email a Distribution Group (List)
#Not restricting Distribution Groups to accept messages from specific external senders only

$ErrorActionPreference="Stop"
Import-Module ActiveDirectory
Add-PSSnapin "*Exchange*"

#Get all groups that you need to set the value to false
#You could also use Exchange commandlet Get-DistributionGroup with the OrganizationalUnit parameter
$Groups=Get-ADGroup -SearchBase "CN=Starks,OU=Groups,OU=Castle Black,OU=Starks,DC=Winterfell,DC=com" -ResultPageSize 10 -ResultSetSize $null -LdapFilter "(&(mail=*))"

ForEach ($Group in $Groups)
{Set-DistributionGroup -IgnoreNamingPolicy:$true -Identity $Group.Name -RequireSenderAuthenticationEnabled:$false -ForceUpgrade -BypassSecurityGroupManagerCheck}

$NestedGroups=Get-ADGroupMember -Recursive $Group.Name | Where-Object {$_.objectClass -eq "group"}
ForEach ($NGroup in $NestedGroups)
{Set-DistributionGroup -IgnoreNamingPolicy:$true -Identity $NGroup.Name -RequireSenderAuthenticationEnabled:$false -ForceUpgrade -BypassSecurityGroupManagerCheck}

#To check if this worked
#Get-DistributionGroup -Identity $Group.Name | Select RequireSenderAuthenticationEnabled
