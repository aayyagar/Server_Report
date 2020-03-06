#Backup with Robocopy and powershell by Mario Cortes
Write-host -foregroundcolor 'green' "Robocopy&PowerShell by Mario Cortes";

$arSourceFolders = ("D:\MySourcePath1", "D:\MySourcePath2");
$arDestinationFolders = ("F:\MyDestinationPath1", "F:\MyDestinationPath2");

if($arSourceFolders.Length -ne $arDestinationFolders.Length)
{
    Write-host -foregroundcolor 'red' "The numbers of folders have to similar";
}
else{
    for($i=0; $i -lt $arSourceFolders.Length; $i++)
    {
        Write-host -foregroundcolor 'green' "Process " $arSourceFolders[$i] " -> " $arDestinationFolders[$i] ;
        robocopy $arSourceFolders[$i] $arDestinationFolders[$i] /COPYALL /E /R:0 /xo
    }
}

Write-host -foregroundcolor 'green' "Done :)";