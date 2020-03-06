#This LDAP filter can be used to chain match a org heirarchy of a User within Active Directory
#For instance it can help in pulling information for everyone under a leader's Org
#You can use this filter in a script to build Automated AD Groups

#This rule is limited to filters that apply to the DN. This is a special "extended" match operator that walks the chain of ancestry in objects all the way to the root until it finds a match.

Get-ADUser -LDAPFilter "(&(objectCategory=person)(objectClass=user)(manager:1.2.840.113556.1.4.1941:=CN=Satya Cannister,OU=Delhi,DC=dev,DC=lab,DC=com))"