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

# Validate parameters
if (-not $User) {
    Write-Error "The -User parameter is required."
    exit
}
if (-not (Test-Path $Path)) {
    Write-Error "The specified path does not exist: $Path"
    exit
}

# Get user groups
try {
    $userGroups = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).Groups | ForEach-Object {
        $_.Translate([System.Security.Principal.NTAccount]).Value
    }
    $userGroups += $User
} catch {
    Write-Warning "Could not retrieve the user's groups. Only the specified name will be used."
    $userGroups = @($User)
}


# Define access rights that imply actual access
$validRights = @(
    "ReadData", "ListDirectory", "Read", "ReadAndExecute",
    "Modify", "Write", "FullControl"
)

# Check access for each folder and subfolder
Get-ChildItem -Path $Path -Recurse -Directory | ForEach-Object {
    $acl = Get-Acl $_.FullName
    $accessmatches = $acl.Access | Where-Object {
        ($userGroups -contains $_.IdentityReference.Value) -and
        ($validRights -contains $_.FileSystemRights.ToString())
    }
    if ($accessmatches) {
        Write-Output "$($_.FullName)"
    }
}