$username = "MUGASA\inforges"
$userpass = "Desmgsrv.2019!"
$computername = "SGI"
$logged = (Get-WmiObject -Class win32_computersystem -ComputerName $computername).UserName
if ($logged -ne $username) {
    $cred = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $userpass -AsPlainText -Force))
    Enter-PSSession -ComputerName $computername -Credential $cred -ConfigurationName "Microsoft.PowerShell32"
} else {
    Write-Output "Sesion $UserName ya activa."
}