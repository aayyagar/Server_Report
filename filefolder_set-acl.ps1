#Enter the path where you need to set the permissions
$Path="D:\Test"

#Get the current permissions of the folder
$ACL=Get-Acl -Path $Path

#Create a new access rule system object with permission rules. 
#Winterfell is the AD Domain and jsnow is the AD User, just in case you were wondering
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("winterfell\jsnow", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")

#Create ACL Rule
$Acl.SetAccessRule($Ar)

#Set the permissions
Set-ACL -Path $Path -AclObject $ACL

#Assign ownership to BUILTIN\Administrators
takeown.exe /A /F $Path