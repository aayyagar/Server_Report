#Get Distributed File System (DFS) Group Member Servers
$GroupName = "DragonEmporer"
$Server_List = get-DfsrMember -Groupname $GroupName | Sort-Object ComputerName | Select-Object -Property DNSName 

#From here you can either just export the list or do a ForEach and perform some actions