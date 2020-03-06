Set-ADUser "shamitchell" -Replace @{pwdLastSet='0'}
Get-ADUser "shamitchell" -Properties PasswordExpired | Select-Object PasswordExpired
