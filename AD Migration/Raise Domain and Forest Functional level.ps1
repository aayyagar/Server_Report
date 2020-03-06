#Raise Domain and Forest Functional level
Set-ADDomainMode –identity <DomainName> -DomainMode Windows2016Domain
Set-ADForestMode -Identity <DomainName> -ForestMode Windows2016Forest