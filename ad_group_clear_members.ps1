#The command get-adgroup has a resultset limit which we can override using ResultSetSize and ResultPageSize

#Remove Members from a Group. Don't prompt for confirmation
Get-ADGroupMember "TestGroup" | ForEach-Object {Remove-ADGroupMember "TestGroup" $_ -Confirm:$false}

#Remove members from all groups in an OU. Don't prompt for confirmation
$ALLGroups=Get-ADGroup -Filter * -SearchBase "OU=Neptune,OU=Distribution Lists,DC=PowerShellJunkie,DC=com" -ResultPageSize 1000 -ResultSetSize $null
ForEach($Group in $ALLGroups)
	{
		Get-ADGroupMember "$Group" | ForEach-Object {Remove-ADGroupMember "$Group" $_ -Confirm:$false}
	}

#This command doesn't have a limit and it's way faster
Get-ADGroup | Set-ADObject -Clear members