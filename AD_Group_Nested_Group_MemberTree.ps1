#<Requires Quest Active Directory Management Tools v2.0 or higher>

Add-PSSnapin Quest.ActiveRoles.ADManagement
Function Get-GroupMemberTree {
  Param(
    $Identity,
    $IndentLevel = 0,
    $IndentCharacter = "`t"
  )

  Write-Host "$($IndentCharacter * $IndentLevel)$($Identity -replace '^CN=|,(CN|OU|DC)=.+$')" -ForegroundColor "yellow"

  $IndentLevel++

  Get-QADGroupMember $Identity | ForEach-Object {
    if ($_.Type -eq 'group') {
      Get-GroupMemberTree $_.DN $IndentLevel $IndentCharacter
    } else {
      Write-Host "$($IndentCharacter * $IndentLevel)$($_.Name)"
    }
  }
}

Get-GroupMemberTree "Account Operators"