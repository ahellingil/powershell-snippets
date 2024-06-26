<# 
.DESCRIPTION
 PowerShell script to list recursively files with the full path included.
 You can specify the path to search or the files filter to apply.

.SYNOPSIS
   ./listFilesRecursively.ps1 [-path <path>] [-filter <filter>]
   .PARAMETER <path>: specifies the path to search files. If is omited, path "." is applied.
   .PARAMETER <filter>: specifies the filter you want to apply (i.e. *.txt).

.EXAMPLE
     # 1. List all files of the current folder:
     ./listFilesRecursively.ps1

     # 2. List markdown files (*.md) of the projects folder:
     ./listFilesRecursively.ps1 -path c:\projects -filter *.md

.NOTES
 Author: ahellingil
#>
param(
    [string]$path,
    [string]$filter
)
if (-not $path) {
    $path = "."
}
if (-not $filter) {
    $filter = "*"
}
(Get-ChildItem $path -Filter $filter -Recurse -Force).FullName