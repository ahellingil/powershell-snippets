# PowerShell script to open a Microsoft Excel Workbook 
# that is protected by a password passing the password directly.
# Use:
#   openExcelAndPassPassword -path <excel_filename> -password <password>
#
# 2024-03-20 - ahellingil - Draft 1.0
#
param(
    [string]$path,
    [int]$password
)
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Open($path, $false, $false, 5, $password)
$excel.Visible = $true
$excel.Workbooks[1].Windows[1].Activate()