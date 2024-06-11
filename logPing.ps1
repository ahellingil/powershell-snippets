<#
.DESCRIPTION
 PowerShell script to improve the ping utility, 
 logging the datetime of each ping and and be able to know when it fails.
 It tests the hostname/ip connection throw a ping every x milliseconds 
 and log the datetime of each ping.

.SYNOPSIS
    ./logping.ps1 -target <host> -ms <ms> -count <number>
   .PARAMETER <host>: specifies the hostname or IP to ping.
   .PARAMETER <ms>: specifies the milliseconds between each test (1000 ms by default).
   .PARAMETER <number>: specifies the number of pings that will be sent. 
       A value of 0 (the default) means infinite pings until the user force the stop of the script.

 .OUTPUTS
   Lines in the format: <hour>;<host>;<result>;<message>. Where:
     <result> = OK or ERROR.
     <message> = 
         If <result> = OK, <message> shows the response time in milliseconds. 
         If <result> = ERROR, <message> shows the error message that occurrs.

.EXAMPLE
     # 1. output continually the ping to www.google.com every 1000 milliseconds
     ./logping.ps1

     # 2. output the 4 pings to www.example.com every 1000 ms
     ./logping.ps1 -target www.example.com -count 4                

     # 3. log continually the ping to www.myserver.com every 600 ms to a file results.csv
     ./logping.ps1 -target www.myserver.com -ms 600 > results.csv  

.NOTES
 Author: ahellingil
#>
param(
    [string]$target,
    [int]$ms,
    [int]$count
)
if (-not $target) {
    $target = "www.google.com"
}
if (-not $ms) {
    $ms = 1000
}
if (-not $count) {
    $count = 0
}
Write-Output "Hour; Host; Result; Message"
for ($i = 1; $i -le $count -or $count -eq 0; $i++) {
    try {
        $dateTime = Get-Date
        $pingResult = Test-Connection -ComputerName $target -Count 1 -ErrorAction Stop
        $status = "OK; " + $pingResult.ResponseTime
    } catch {
        $status = "ERROR; $_"
    }
    Write-Output "$dateTime; $target; $status"
    if (-not ($i -eq $count)) {
        Start-Sleep -Milliseconds $ms
    }
}

