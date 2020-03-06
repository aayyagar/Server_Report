#This script will import a list of users fom a CSV file and compare te list against a given AD Group. Then it will 
# 1) Add anyone who is the CSV but not in the AD group
# 2) Remove anyone in the AD Group but not in the CSV

Import-Module ActiveDirectory
#We will use Quest commandlets to simplify data pull from AD Group as Get-ADGroupMember has a size limit
Add-PSSnapin Quest.ActiveRoles.ADManagement
Set-QADPSSnapinSettings -DefaultPageSize 1000 -DefaultSizeLimit 0

$GroupName="TRUMP CABINET"
$NewMembers=Import-Csv "C:\temp\TrumpCabinetMembers.csv" -Header "SamAccountName" | Where-Object { $_.PSObject.Properties.Value -ne $null}
$ExistingMembers=Get-QADGroupMember -Identity $GroupName | Select-Object SamAccountName -ExpandProperty SamAccountName | Out-String -Stream

#Remove user from AD Group if they are not in the CSV
ForEach($Member in $ExistingMembers)
{If($NewMembers -notcontains $Member){
Remove-ADGroupMember -Identity $GroupName -Member $Member -Confirm:$false}}

#Add the user to the group if they are not a member
foreach ($NewMember in $NewMembers) {
If($NewMember -notin $ExistingMembers){
Try{Add-ADGroupMember -Identity $GroupName -Member $NewMember.SamAccountName | Out-String -Stream }
Catch{"Add-ADGroupMember : Cannot find an object with identity" > $null

#Export the username if not found in AD
$NewMember | Export-Csv C:\temp\UserNotFound_.csv -Append -NoClobber -NoTypeInformation > $null
}}}