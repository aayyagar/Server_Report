Import-Module ActiveDirectory
Get-ADObject -LDAPFilter "(objectCategory=msExchDynamicDistributionList)" -Properties * | Select-Object {$_.Name},{$_.mail},{$_.DisplayName},{$_.msExchDynamicDLFilter},{$_.msExchQueryFilter},{$_.proxyAddresses} | Export-Csv c:\temp\Query_Based_groups.CSv -Append -NoTypeInformation
