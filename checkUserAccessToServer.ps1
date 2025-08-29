<#
.DESCRIPTION
 PowerShell script to check what folders/subfolders a user has access in a server or PC.
 You must run this script in the server you want to search.

.SYNOPSIS
    ./checkUserAccessToServer.ps1 -User <user> -Path <path>
   .PARAMETER <user>: specifies the username of the domain.
   .PARAMETER <path>: specifies the root folder in which to search subfolders.

 .OUTPUTS
   Lines in the format: <hour>;<host>;<result>;<message>. Where:
     <result> = OK or ERROR.
     <message> = 
         If <result> = OK, <message> shows the response time in milliseconds. 
         If <result> = ERROR, <message> shows the error message that occurrs.

.EXAMPLE
     # 1. List permissions to domain user1 throughout disk C:
     ./checkUserAccessToServer.ps1 -user "DOMAIN\user1" -path "C:\"

     # 2. List permissions to PC user1 throughout disk C:
     ./checkUserAccessToServer.ps1 -user "MYPC\user1" -path "C:\"

.NOTES
 Author: ahellingil
#>
param (
    [string]$User,
    [string]$Path
)

if (-not (Test-Path $Path)) {
    Write-Error "La ruta especificada no existe: $Path"
    exit
}

Get-ChildItem -Path $Path -Recurse -Directory | ForEach-Object {
    $acl = Get-Acl $_.FullName
    if ($acl.Access | Where-Object { $_.IdentityReference -like "*$User*" }) {
        Write-Output "$($_.FullName) - acceso para $User"
    }
}