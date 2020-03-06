#We can migrate all five FSMO roles to the New domain controller using following powershell DomainNamingMaster == domaincontroller

Move-ADDirectoryServerOperationMasterRole -Identity DomainNamingMaster -OperationMasterRole SchemaMaster, DomainNamingMaster, PDCEmulator, RIDMaster, InfrastructureMaster