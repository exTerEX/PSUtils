<#
    .SYNOPSIS
        Retrieve current Windows Defender status

    .EXAMPLE
        C:\PS> Test-Elevated

            AMServiceEnabled: True
            AntispywareEnabled: True
            AntivirusEnabled: True
            BehaviorMonitorEnabled: True
            IoavProtectionEnabled: True
            NISEnabled: True
            OnAccessProtectionEnabled: True
            RealTimeProtectionEnabled: True
#>

$Status = Get-MpComputerStatus
$Status | Get-Member -MemberType Properties | Where-Object Name -match "enabled" | ForEach-Object {
    "$($_.Name): $($Status.($_.Name))"
}