function Get-HPArrayDisks
{
    <#
    .SYNOPSIS
    Retrieves physical hard disk information for HP servers.
 
    .DESCRIPTION
    The Get-HPArrayDisks function works through WMI and requires
    that the HP Insight Management WBEM Providers are installed on
    the server that is being quiered.
 
    .PARAMETER Computername
    The HP server for which the disks should be listed.
    This parameter is optional and if the parameter isn't specified
    the command defaults to local machine.
    First positional parameter.
 
    .EXAMPLE
    Get-HPArrayDisks
    Lists physical disk information for the local machine
 
    .EXAMPLE
    Get-HPArrayDisks SRV-HP-A
    Lists physical disk information for server SRV-HP-A
 
    .EXAMPLE
    "SRV-HP-A", "SRV-HP-B", "SRV-HP-C" | Get-HPArrayDisks
    Lists physical disk information for three servers
 
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position = 1)][string]$Computername=$env:computername
    )
 
    Process{
 
        if ($pscmdlet.ShouldProcess("List disks on server " +$Computername)){
            $diskdrives =  Get-WmiObject -Computername $ComputerName -Namespace root\hpq -Query "select * from HPSA_DiskDrive"
            ForEach ($disk in $diskdrives){
                $OutObject = New-Object System.Object
                $OutObject | Add-Member -type NoteProperty -name ComputerName -value $ComputerName
                $OutObject | Add-Member -type NoteProperty -name Slot -value $disk.ElementName
                $OutObject | Add-Member -type NoteProperty -name Interface -value $disk.Description
                $OutObject | Add-Member -type NoteProperty -name RotationalSpeed -value $disk.DriveRotationalSpeed
 
                $drivePhys = Get-WmiObject -Computername $ComputerName -Namespace root\hpq -Query ("ASSOCIATORS OF {HPSA_DiskDrive.CreationClassName='HPSA_DiskDrive',DeviceID='" + $disk.DeviceID + "',SystemCreationClassName='" + $disk.SystemCreationClassName + "',SystemName='" + $disk.SystemName + "'} WHERE AssocClass=HPSA_DiskPhysicalPackageDiskDrive")
                $OutObject | Add-Member -type NoteProperty -name Model -value $drivePhys.Model
                $OutObject | Add-Member -type NoteProperty -name SerialNumber -value $drivePhys.SerialNumber.trim()
 
                $driveFW = Get-WmiObject -Computername $ComputerName -Namespace root\hpq -Query ("ASSOCIATORS OF {HPSA_DiskDrive.CreationClassName='HPSA_DiskDrive',DeviceID='" + $disk.DeviceID + "',SystemCreationClassName='" + $disk.SystemCreationClassName + "',SystemName='" + $disk.SystemName + "'} WHERE AssocClass=HPSA_DiskDriveDiskDriveFirmware")
                $OutObject | Add-Member -type NoteProperty -name FirmwareVersion -value $driveFW.VersionString.trim()
 
                $driveStorage = Get-WmiObject -Computername $ComputerName -Namespace root\hpq -Query ("ASSOCIATORS OF {HPSA_DiskDrive.CreationClassName='HPSA_DiskDrive',DeviceID='" + $disk.DeviceID + "',SystemCreationClassName='" + $disk.SystemCreationClassName + "',SystemName='" + $disk.SystemName + "'} WHERE AssocClass=HPSA_DiskDriveStorageExtent")
                $OutObject | Add-Member -type NoteProperty -name SizeInGigabytes -value ([math]::round(($driveStorage.BlockSize * $driveStorage.NumberOfBlocks) / 1000000000))
                $OutObject | Add-Member -type NoteProperty -name PowerOnHours -value $driveStorage.TotalPowerOnHours
 
                Write-Output $OutObject
            }
        }
    }
}