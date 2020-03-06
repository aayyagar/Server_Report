#After the migration completes we still need to verify if its completes successfully.
Get-ADDomain | fl Name,DomainMode