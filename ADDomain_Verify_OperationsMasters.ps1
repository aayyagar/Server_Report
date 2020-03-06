#Have you ever wanted to verify which server in your Domain holds the FSMO roles? 

#Wait no further and use this script to verify the FSMO , Schema and Domain Naming masters in your environment

Get-ADDomain | Select-Object InfrastructureMaster, RIDMaster, PDCEmulator

Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster

Get-ADDomainController -Filter * |

     Select-Object Name, Domain, Forest, OperationMasterRoles |

     Where-Object {$_.OperationMasterRoles} |

     Format-Table -AutoSize

#From here you can export the info or pipe it to automate or monitor things.

#hop you find it useful