#One method is to call the .net library
#Function RandomPW {
#[Reflection.Assembly]::LoadWithPartialName(“System.Web”)
#[System.Web.Security.Membership]::GeneratePassword(20,10) | gm | FT}

#This is another mehtod to get the pw from an random pw generator site
#$initialPW = $(Invoke-RestMethod https://www.random.org/passwords/?num=1"&"len=20"&"format=plain"&"rnd=new) -replace "`n"

#The following function is the best I found fo far
function Get-RandomPassword($length)
{
    $length-=1
    $lower = 'abcdefghijklmnopqrstuvwxyz'
    $upper = $lower.ToUpper()
    $number = 0..9
    $special='~!@#$%^&*()_+|}{[]\'
    $chars = "$lower$special$upper".ToCharArray()

    $pass = Get-Random -InputObject $chars -Count $length
    $digit = Get-Random -InputObject $number

    (-join $pass).insert((Get-Random $length),$digit)
}

#example
Get-RandomPassword -Length 20

#example if you want multiple passwords
1..20 | % {Get-RandomPassword -Length 20}