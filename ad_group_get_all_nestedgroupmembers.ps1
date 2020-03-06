#This script is basically going through a group's members and if the member is a group, then it will go through that group's members and continue until it doesn't find any nested groups
function Get-ADNestedGroupMembers {
[cmdletbinding()]
param (
[String] $GroupName
)            

import-module activedirectory
$Members = Get-ADGroupMember -Identity $GroupName
$members | % {
    if($_.ObjectClass -eq "group") {
        Get-ADNestedGroupMembers -GroupName $_.distinguishedName
    } else {
        return $_.distinguishedname
    }
}            
}

Get-ADNestedGroupMembers -GroupName "Khaleesi_Friends"

#Test code for future
#(Get-ADGroup -Filter {Name -eq $GroupName} -Properties Members -ResultPageSize 100 -ResultSetSize $null | Select Members).Members