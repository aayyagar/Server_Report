#Have you ever been asked to export members from multipe groups.
#Back in the day you would export them using ADExport or some manual tool
#Today you can do that with powershell. But wait, what if you could export all groups and members to the same CSV file without having to VLOOKUP in Excel? 
#Wait no more, use the powershell script below to easily export AD group members and map them to their respective group

Add-PSSnapin Quest.ActiveRoles.ADManagement;Set-QADPSSnapinSettings -DefaultPageSize 100 -DefaultSizeLimit 0

#Get all groups in an OU
$Groups=Get-QADGroup -SearchRoot "OU=Groups,OU=Castle Black,OU=Starks,DC=Winterfell,DC=com" | Select Name,DN

#If you want to focus on just one group and it's nested groups\
$Groups=Get-QADGroupMember "LannisterOrganization" -Indirect -Type group | Select Name,DN

Foreach ($Group in $Groups)
{
Get-QADGroupMember -Identity $Group.DN | Get-QADObject -Properties name,mail,samaccountname |
Select @{Label="GroupName";Expression={$Group.Name}},name,mail,samaccountname |
Export-Csv c:\temp\LannisterGroupsMapping.csv -Append -NoTypeInformation
}