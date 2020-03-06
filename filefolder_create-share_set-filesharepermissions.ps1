#Version1. Version2 will contain parameters for Share name. I got a few errors when trying to work around that and then didnt have time

# Configures the folders to have necessary SHARE permissions
# Set the folder path of the share

$Server = "FileServer001"
$SharedFolder = "C:\TESTEST"

# Assign the Share Permissions

# User Name/Group to give permissions to
$trustee = ([wmiclass]'Win32_trustee').psbase.CreateInstance()
$trustee.Domain = "winterfell.com"
$trustee.Name = "Cersei Lannister"

$trustee2 = ([wmiclass]'Win32_trustee').psbase.CreateInstance()
$trustee2.Domain = "winterfell.com"
$trustee2.Name = "Tyrion Lannister"

# Access mask values
$fullcontrol = 2032127
$change = 1245631
$read = 1179785

# Create access-list for trustee
$ace = ([wmiclass]'Win32_ACE').psbase.CreateInstance()
$ace.AccessMask = $fullcontrol
$ace.AceFlags = 3
$ace.AceType = 0
$ace.Trustee = $trustee

# Create access-list for trustee2
$ace2 = ([wmiclass]'Win32_ACE').psbase.CreateInstance()
$ace2.AccessMask = $Read
$ace2.AceFlags = 3
$ace2.AceType = 0
$ace2.Trustee = $trustee2

# Security descriptor containing access
$sd = ([wmiclass]'Win32_SecurityDescriptor').psbase.CreateInstance()
$sd.ControlFlags = 4
$sd.DACL = $ace, $ace2
$sd.group = $trustee
$sd.owner = $trustee

$share = Get-WmiObject Win32_Share -List -ComputerName "$Server"
$share.create("$SharedFolder", "TESTEST$", 0, 100, "SHARE_NAME", "", $sd)