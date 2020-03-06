<#
IMPORTANT: Someone gave this script to me at some point long long time ago and I haven't really vetted it. Use with caution and always test in your lab first.
##Info
This script might be usefull when you need to make significant changes into infrastructure addressing scheme and want to to find out which computers would not be affected by DHCP changes. It uses Get-ADComputer Cmdlet with LDAPFilter, which can be easily replaced into something different, providing list of computer names.
#> 
param ( 
    [string]$LDAPFilter = '(name=*)', 
    [switch]$Verbose 
) 
Get-ADComputer -LDAPFilter $LDAPFilter | 
% ` 
{  
    $name = $_.DNSHostName; 
    if ($Verbose.IsPresent) 
      { Write-Host -ForegroundColor Yellow "Connecting to $name..." }  
    $ints = Get-WmiObject -ErrorAction SilentlyContinue -ComputerName $name ` 
      -Query "select IPAddress, DefaultIPGateway from Win32_NetworkAdapterConfiguration where IPEnabled=TRUE and DHCPEnabled=FALSE"; 
    if ($ints -ne $null) 
        { 
            foreach ($int in $ints) 
            { 
                foreach ($addr in $int.IPAddress) 
                { 
                    $ip = $null 
                    if ($addr -match "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}") 
                    { 
                        $ip = $addr 
                        $gw = $null 
                        foreach ($gw_addr in $int.DefaultIPGateway) 
                        { 
                            if ($gw_addr -match "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}") 
                            { 
                                $gw = $gw_addr 
                                break 
                            } 
                        } 
                        if ($ip -ne $null) 
                        { 
                            $info = New-Object PSObject -Property ` 
                            @{ 
                                Name = $name 
                                IP = $ip 
                                Gateway = $gw 
                            } 
                            $info 
                            if ($Verbose.IsPresent) 
                                { Write-Host -ForegroundColor Yellow $info } 
                        } 
                    } 
                } 
            } 
        } 
} | 
Select-Object Name, IP, Gateway

#Usage Examples:
#Returns all domain computers
.\ComputersWithStaticIP.ps1 '(name=*)' 

#Stores all computers with name, contining "dc" into variable and displays progress output
$computersInfo = .\ComputersWithStaticIP.ps1 '(name="*dc*")' -Verbose 