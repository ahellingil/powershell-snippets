<# 
.DESCRIPTION
 List all the ocurrences of a pattern in the Windows Registry.

.SYNOPSIS
   ./searchInRegistry.ps1 -pattern <text to search> -startpath <startpath_parameter>
   .PARAMETER <startpath_parameter>
        Registry  (to search in the full Windows Registry)
        HKLM:\    (to search only in HKEY_LOCAL_MACHINE branch)
        HKCU:\    (to search only in HKEY_CURRENT_USER branch)
        HKCR:\    (to search only in HKEY_CLASS_ROOT branch)
        HKCC:\    (to search only in HKEY_CURRENT_CONFIG)
      

.EXAMPLE
    ./searchInRegistry.ps1 -pattern "*Bluetooth*" > results.txt

.NOTES
 Author: ahellingil
#>
param(
    [string]$pattern,
    [string]$startpath
)
if (-not $startpath) {
    $startpath = "Registry"
}
if ($startpath -eq "Registry") {
    $list1 = Get-ChildItem -Path HKLM:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like $pattern}
    foreach ($item in $list1) {
        Write-Output "$($item.PSPath) $($item.Name) ($($item.GetType().FullName)) = $($item.GetValue()). $($item.Property)"
    }
    $list2 = Get-ChildItem -Path HKCU:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like $pattern}
    foreach ($item in $list2) {
        Write-Output "$($item.PSPath) $($item.Name) ($($item.GetType().FullName)) = $($item.GetValue()). $($item.Property)"
    }
    $list3 = Get-ChildItem -Path HKCR:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like $pattern}
    $list4 = Get-ChildItem -Path HKCC:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like $pattern}
    $lists = $list1, $list2, $list3, $list4;
    foreach ($list in $lists) {
        foreach ($item in $list) {
            Write-Output "$($item.PSPath) $($item.Name) ($($item.GetType().FullName)) = $($item.GetValue()). $($item.Property)"
        }
    }
} else {
    $list = Get-ChildItem -Path $startpath -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like $pattern}
    foreach ($item in $list) {
        Write-Output "$($item.PSPath) $($item.Name) ($($item.GetType().FullName)) = $($item.GetValue()). $($item.Property)"
    }
}


#Get-ChildItem -Path HKCU:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like $pattern}
#Get-ChildItem -Path HKU:\  -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like $pattern}
#Get-ChildItem -Path HKCR:\  -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like $pattern}