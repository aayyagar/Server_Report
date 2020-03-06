#Typically LDAP timestamps come in this weird long number format.
#This may be the case specifically when exporting AD Object information like Whencreated, lastChanged, PwdLastSet etc
#This time stamp though can easily be changed to a human readable format

#Lets consider the following example
$LDAPTimeStamp="131188565190084028"

#Now convert the time format
[datetime]::FromFileTime($LDAPTimeStamp).ToShortDateString()

#Boom, thats it, there is nothing more to do. Your job is done.