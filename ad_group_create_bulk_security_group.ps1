$SGPath = "OU=Security Groups,OU=Starks,OU=Castle Black,DC=Winterfell,DC=com"
$SG = Import-Csv C:\Temp\SG.csv -Header @("Name","DisplayName","Description")
foreach ($line in $SG)
{
Write-Host $line
New-ADGroup -Name $line.name -DisplayName $line.DisplayName -Description $line.Description -GroupCategory Security -GroupScope Universal -Path $SGPath
}