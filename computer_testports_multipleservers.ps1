#Remotely Test Ports for multiple computers
#requires -Version 2
$ComputerList = Get-Content -Path $env:USERPROFILE\Documents\PC-List.txt | Sort-Object
$IPAddress = '10.1.1.71'
$Port = 1688
$ErrorActionPreference = 'Stop'

Function Test-SocketConnection 
{ 
    <#
            .SYNOPSIS
            Opens a socket connection to a remote system to test if the port is open.

            .DESCRIPTION
            Tests the connection from a remote system to another remote systme over a specified port.
            This is useful to test if the port has been opened through the firewall.

            .EXAMPLE
            Test-SocketConnection -ComputerName Server01 -Destination Server02 -PortNumber 80
            
            Tests a connection from Server01 to Server02 on port 80. 

            .EXAMPLE
            Test-SocketConnection -ComputerName Server01 -Destination 10.1.1.71 -PortNumber 1688

            Tests a connection from Server01 to 10.1.1.71 over port 1688.

            .EXAMPLE
            Test-SocketConnection -Destination SQLServer2 -PortNumber 1433
             
            Creates a test connection from the local PC (where script runs) to SQLServer2 on port 1433.

            .PARAMETER ComputerName
            The name of the computer where the socket connection is initiated. Defaults to the local PC. Accepts an array of names as well.

            .PARAMETER Destination
            This is the target system to open the socket connection to. Hostname or IP are accepted.

            .PARAMETER PortNumber
            The port number that the socket connection will be opened through. Should be opened through the firewall on both sides.
    #>
    [cmdletbinding()]
	
    Param(
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [Parameter(Mandatory = $true)][string]$Destination,
        [Parameter(Mandatory = $true)][Int]$PortNumber
    )

    $code = 
    {
        [CmdletBinding()]
        Param(
            [String]$Destination,
            [int]$PortNumber
        )

        Try
        { 
            $socket = New-Object -TypeName net.sockets.tcpclient -ArgumentList ($Destination, $PortNumber) -Verbose
            $output = New-Object -TypeName PSObject -Property @{
                ComputerName = $env:COMPUTERNAME
                Connected    = $socket.Connected
            }
            $socket.Dispose()
        }
        Catch 
        {
            $output = New-Object -TypeName PSObject -Property @{
                ComputerName = $env:COMPUTERNAME
                Connected    = $false
            }
        }
        Finally 
        {
            Write-Output -InputObject $output
        }
    }

    $out = @()
   
    Write-Verbose 'ComputerName   Connected'
    foreach ($PC in $ComputerName)
    {
        try 
        { 
            $output = Invoke-Command -ComputerName $PC -ScriptBlock $code -ArgumentList $Destination, $PortNumber -Verbose -ErrorAction Stop
            $display = $PC + '    ' + $output.Connected
            Write-Verbose $display
        }
        catch 
        {
            $output = New-Object -TypeName PSObject -Property @{
                ComputerName = $PC
                Connected    = $false
            }
            Write-Error -Message "Unable to connect to $PC" -ErrorAction Continue

        }
        $out += $output
    }
    Write-Output -InputObject $out
}

$results = Test-SocketConnection -ComputerName $ComputerList -Destination $IPAddress -PortNumber $Port -Verbose
$results | Format-Table -Property ComputerName, Connected