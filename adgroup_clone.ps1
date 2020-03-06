#This script will clone the Group membership of one user to another

#Get groups of the source user
$SrouceUser="CN=John Snow (jsnow),OU=People,OU=Starks,OU=Castle Black,DC=Winterfell,DC=com"

#Get the user to whom you will be cloning groups to
$DestinationUser=Get-ADUser "CN=Tyrion Lannister,OU=People,OU=Lannisters,OU=Casterly Rock,DC=Winterfell,DC=com"

$Groups=Get-ADUser $SourceUser -Properties Memberof | Select-Object Memberof -ExpandProperty Memberof | Out-String -Stream

#Add the Destination user to these groups
ForEach($Group in $Groups)
    {
        Add-ADGroupMember -Identity $Group -Members $DestinationUser
    }