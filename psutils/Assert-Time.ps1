<#
    .SYNOPSIS
        Test how long a function use to finish its task

    .EXAMPLE
        C:\PS> Assert-Time Write-Output "Hello World!"

            Hello World!
            Elapsed time: 00:00:00.0003225
#>

Set-StrictMode -Off;

$Cmd, $Args = $Args
$Args = @($Args)
$Time = [diagnostics.stopwatch]::startnew()
& $Cmd @args
$Time.Stop()

Write-Host -ForegroundColor "Green" -Object "Elapsed time: $($Time.Elapsed)"