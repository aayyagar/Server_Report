
#Add all Exchange Snapins so we can run the exchange commandlets
Add-PSSnapin *EXchange*

#In this scenario we will get all groups in an OU
$GROUPS=Get-ADGroup -LDAPFilter "(&(&(&(objectCategory=group)(objectClass=group)(mail=*)(!dLMemSubmitPerms=*))))" -SearchBase "OU=Groups,OU=Castle Black,OU=Starks,DC=Winterfell,DC=com"

ForEach ($Group in $GROUPS)
{
Set-DistributionGroup -Identity $Group.DistinguishedName -AcceptMessagesOnlyFromSendersOrMembers "DLSendRights_Group" -Verbose -Confirm:$false -ForceUpgrade
}

#How do you know if this worked?
ForEach($Group in $GROUPS)
{
If ((Get-DistributionGroup $Group.DistinguishedName | Select-Object "AcceptMessagesOnlyFromSendersOrMember") -eq '$null')
	{
	Write-Host $Group.Name
	#If you dont get any results back then you are set
	}
}
}

#Another quicker way to check is

Get-DistributionGroup -OrganizationalUnit "OU=Groups,OU=Castle Black,OU=Starks,DC=Winterfell,DC=com" -ResultSize 10000 |
 Where {$_.AcceptMessagesOnlyFromSendersOrMembers -eq '$null'}