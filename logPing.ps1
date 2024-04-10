#
# PowerShell script to test hostname/ip connection throw a ping every x milliseconds and log the datetime of each ping.
# Use: testping -target <host> -ms <ms>
#   -target <host>: <host> is the hostname or IP to ping.
#   -ms <ms>: <ms> is the milliseconds between each test (1000 ms by default).
#
# Returns:
#   Lines in the format: <hour>;<host>;<result>;<message>. Where:
#     <result> = OK or ERROR.
#     <message> = 
#         If <result> = OK, <message> shows the response time in milliseconds. 
#         If <result> = ERROR, <message> shows the error message that occurrs.
#
#   Examples: 
#     testping                                                 # output the ping to www.google.com every 1000 milliseconds
#     testping -target www.example.com                         # output the ping to www.example.com every 1000 ms
#     testping -target www.myserver.com -ms 600 > results.csv  # log the ping to www.myserver.com every 600 ms to a file results.csv
#
# 2024-04-10 - ahellingil - Draft 1.0
#
param(
    [string]$target,
    [int]$ms
)
if (-not $target) {
    $target = "www.google.com"
}
if (-not $ms) {
    $ms = 1000
}
Write-Output "Hour; Host; Result; Message"
for (;;) {
    try {
        $dateTime = Get-Date
        $pingResult = Test-Connection -ComputerName $target -Count 1 -ErrorAction Stop
        $status = "OK; " + $pingResult.ResponseTime
    } catch {
        $status = "ERROR; $_"
    }
    Write-Output "$dateTime; $target; $status"
    Start-Sleep -Milliseconds $ms    
}

