Import-module activedirectory
$Users=Import-csv c:\Server\ADU.csv
ForEach($User in $Users)
      {
$Password = (ConvertTo-SecureString -AsPlainText $user.password -Force)


      $Parameters = @{
      'SamAccountName'        = $user.SamAccountName
      'UserPrincipalName'     = $User.UserPrincipalName
      'name'                  = $user.Name
      'Company'               = $user.Company
      'OfficePhone'           = $user.OfficePhone
      'EmailAddress'          = $user.Emailaddress
      'GivenName'             = $User.GivenName
      'Surname'               = $User.Surname  
      'AccountPassword'       = $password 
      'Enabled'               = $true 
      'Path'                  = $user.path
      'Description'           = $user.Description
      'Department'            = $user.Department
      'EmployeeID'            = $user.EmployeeID
      'city'                  = $user.city 
      'title'                 = $user.title
      'displayname'           = $Displayname
      
       }

       New-ADUser @Parameters
       }

              $list = Import-Csv "c:\Server\ADU.csv" | % {
$User = $_.sAMAccountName
$ID = $_.manager
Set-ADUser $User -manager $ID
}