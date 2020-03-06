#Rename files or folders to lowercase letters
Get-ChildItem -Path "C:\Users\khaleesi\*.txt" -Recurse | % { if ($_.Name -cne $_.Name.ToLower()) { ren $_.FullName $_.Name.ToLower() } }