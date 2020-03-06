#Save the file as a .PSM1 file first to use it as a module

﻿function Get-SharePermissions{ 
<#   
.SYNOPSIS   
    Retrieves share permissions. 
.DESCRIPTION 
    Retrieves share permissions. 
.PARAMETER computer 
    Name of server to test the port connection on.           
.NOTES   
    Name: Get-SharePermissions 
    Author: Boe Prox 
    DateCreated: 12SEPT2010  
            
.LINK   
    https://boeprox.wordpress.org 
.EXAMPLE   
    Get-SharePermissions -computer Test           
#>  
[cmdletbinding( 
    DefaultParameterSetName = 'computer', 
    ConfirmImpact = 'low' 
)] 
    Param( 
        [Parameter( 
            Mandatory = $True, 
            Position = 0, 
            ParameterSetName = 'computer', 
            ValueFromPipeline = $True)] 
            [array]$computer                       
            ) 
Begin {                 
    #Process Share report 
    $sharereport = @() 
    } 
Process { 
    #Iterate through comptuers 
    ForEach ($c in $computer) { 
        Try {     
            Write-Verbose "Computer: $($c)" 
            #Retrieve share information from comptuer 
            $ShareSec = Get-WmiObject -Class Win32_LogicalShareSecuritySetting -ComputerName $c -ea stop 
            ForEach ($Shares in $sharesec) { 
                Write-Verbose "Share: $($Shares.name)" 
                    #Try to get the security descriptor 
                    $SecurityDescriptor = $ShareS.GetSecurityDescriptor() 
                    #Iterate through each descriptor 
                    ForEach ($DACL in $SecurityDescriptor.Descriptor.DACL) { 
                        $arrshare = New-Object PSObject 
                        $arrshare | Add-Member NoteProperty Computer $c 
                        $arrshare | Add-Member NoteProperty Name $Shares.Name 
                        $arrshare | Add-Member NoteProperty ID $DACL.Trustee.Name 
                        #Convert the current output into something more readable 
                        Switch ($DACL.AccessMask) { 
                            2032127 {$AccessMask = "FullControl"} 
                            1179785 {$AccessMask = "Read"} 
                            1180063 {$AccessMask = "Read, Write"} 
                            1179817 {$AccessMask = "ReadAndExecute"} 
                            -1610612736 {$AccessMask = "ReadAndExecuteExtended"} 
                            1245631 {$AccessMask = "ReadAndExecute, Modify, Write"} 
                            1180095 {$AccessMask = "ReadAndExecute, Write"} 
                            268435456 {$AccessMask = "FullControl (Sub Only)"} 
                            default {$AccessMask = $DACL.AccessMask} 
                            } 
                        $arrshare | Add-Member NoteProperty AccessMask $AccessMask 
                        #Convert the current output into something more readable 
                        Switch ($DACL.AceType) { 
                            0 {$AceType = "Allow"} 
                            1 {$AceType = "Deny"} 
                            2 {$AceType = "Audit"} 
                            } 
                        $arrshare | Add-Member NoteProperty AceType $AceType 
                        #Add to existing array 
                        $sharereport += $arrshare 
                        } 
                    } 
                } 
            #Catch any errors                 
            Catch { 
                $arrshare | Add-Member NoteProperty Computer $c 
                $arrshare | Add-Member NoteProperty Name "NA" 
                $arrshare | Add-Member NoteProperty ID "NA"  
                $arrshare | Add-Member NoteProperty AccessMask "NA"           
                }  
            Finally { 
                #Add to existing array 
                $sharereport += $arrshare 
                }                                                    
            }  
        }                        
End { 
    #Display report 
    $Sharereport 
    } 
}     
 
function Get-ShareNTFSPermissions{ 
<#   
.SYNOPSIS   
    Retrieves NTFS permissions on a share. 
.DESCRIPTION 
   Retrieves NTFS permissions on a share. 
.PARAMETER computer 
    Name of server to test the port connection on.           
.NOTES   
    Name: Get-SharePermissions 
    Author: Boe Prox 
    DateCreated: 12SEPT2010  
            
.LINK   
    https://boeprox.wordpress.org 
.EXAMPLE   
    Get-ShareNTFSPermissions -computer Test         
#>  
[cmdletbinding( 
    DefaultParameterSetName = 'computer', 
    ConfirmImpact = 'low' 
)] 
    Param( 
        [Parameter( 
            Mandatory = $True, 
            Position = 0, 
            ParameterSetName = 'computer', 
            ValueFromPipeline = $True)] 
            [array]$computer                       
            )   
Begin {               
    #Process NTFS Share report                 
    $ntfsreport = @()       
    } 
Process { 
    #Iterate through each computer 
    ForEach ($c in $computer) {  
        Try {                  
            Write-Verbose "Computer: $($c)"  
            #Gather share information 
            $shares = Gwmi -comp $c Win32_Share -ea stop | ? {$_.Name -ne 'ADMIN$'-AND $_.Name -ne 'C$' -AND $_.Name -ne 'IPC$'} | Select Name,Path 
            ForEach ($share in $shares) { 
                #Iterate through shares 
                Write-Verbose "Share: $($share.name)" 
                If ($share.path -ne "") { 
                    #Retrieve ACL information from Share   
                    $remoteshare = $share.path -replace ":","$"  
                    Try { 
                        #Gather NTFS security information from each share 
                        $acls = Get-ACL "\\$computer\$remoteshare" 
                        #iterate through each ACL 
                        ForEach ($acl in $acls.access) { 
                            If ($acl.FileSystemRights -match "\d") { 
                                Switch ($acl.FileSystemRights) { 
                                    2032127 {$AccessMask = "FullControl"} 
                                    1179785 {$AccessMask = "Read"} 
                                    1180063 {$AccessMask = "Read, Write"} 
                                    1179817 {$AccessMask = "ReadAndExecute"} 
                                    -1610612736 {$AccessMask = "ReadAndExecuteExtended"} 
                                    1245631 {$AccessMask = "ReadAndExecute, Modify, Write"} 
                                    1180095 {$AccessMask = "ReadAndExecute, Write"} 
                                    268435456 {$AccessMask = "FullControl (Sub Only)"} 
                                    default {$AccessMask = "Unknown"} 
                                    }                                 
                                } 
                            Else { 
                                $AccessMask = $acl.FileSystemRights 
                                }                                 
                            $arrntfs = New-Object PSObject                     
                            #Process NTFS Report          
                            $arrntfs | Add-Member NoteProperty Computer $c               
                            $arrntfs | Add-Member NoteProperty ShareName $Share.name 
                            $arrntfs | Add-Member NoteProperty Path $share.path 
                            $arrntfs | Add-Member NoteProperty NTFS_User $acl.IdentityReference 
                            $arrntfs | Add-Member NoteProperty NTFS_Rights $AccessMask 
                            }     
                        } 
                    Catch { 
                        $arrntfs = New-Object PSObject                     
                        #Process NTFS Report          
                        $arrntfs | Add-Member NoteProperty Computer $c               
                        $arrntfs | Add-Member NoteProperty ShareName "NA" 
                        $arrntfs | Add-Member NoteProperty Path "NA" 
                        $arrntfs | Add-Member NoteProperty NTFS_User "NA" 
                        $arrntfs | Add-Member NoteProperty NTFS_Rights "NA"                     
                        } 
                    Finally { 
                        #Add to existing array 
                        $ntfsreport += $arrntfs  
                        }                                                                                    
                    }                                
                } 
            } 
        Catch { 
            $arrntfs | Add-Member NoteProperty Computer $c               
            $arrntfs | Add-Member NoteProperty ShareName "NA"  
            $arrntfs | Add-Member NoteProperty Path "NA"  
            $arrntfs | Add-Member NoteProperty NTFS_User "NA"  
            $arrntfs | Add-Member NoteProperty NTFS_Rights "NA"          
            } 
        Finally { 
            #Add to existing array 
            $ntfsreport += $arrntfs          
            }                                         
        }             
    } 
End { 
    #Display report 
    $ntfsreport 
    }              
}             