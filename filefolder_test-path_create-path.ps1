#Path to Check
$Path="C:\Temp\Test"
#Check if Path exists
If (!(Test-Path $Path)) 
	{
	#Create if it doesn't
	New-Item -Path $Path -ItemType Directory -Force
	}