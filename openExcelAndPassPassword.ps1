<# 
.DESCRIPTION
 PowerShell script to open a Microsoft Excel Workbook 
 that is protected by a password passing the password directly.

.SYNOPSIS
   ./openExcelAndPassPassword.ps1 -path <excel_filename> -password <password>

.NOTES
 Author: ahellingil
#>
param(
    [string]$path,
    [int]$password
)
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Open($path, $false, $false, 5, $password)
$excel.Visible = $true
$excel.Workbooks[1].Windows[1].Activate()