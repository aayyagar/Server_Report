#Here is a quick and dirty way to remove all user defined variables.

#Helpful when you want to restart the script from scratch and don't want any existing values

$ScriptContent    = Get-Content "C:\Users\JohnCena\Bodypump.ps1"
$SplitContent     = $ScriptContent -split '[^\w$]'
$Variables        = $SplitContent | ? {$_ -like "$*"} | Sort-Object | Get-unique
$Variables

# remove some variables
Get-Variable * -Scope global | &{process{
if (!$_.Description -and !$_.Option -and !$_.Attributes) {
Remove-Variable $_.Name -Scope global -ErrorAction SilentlyContinue
}
}}

# up to you
$Error.Clear()