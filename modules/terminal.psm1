#Requires -Version 2.0

New-Module -Name Terminal -ScriptBlock {
    Function Test-Admin() {
        <#
        .SYNOPSIS
            Test whether terminal has administration elevation

        .OUTPUTS
            bool

        .EXAMPLE
            C:\PS> Test-Admin
    
                true
        #>

        $User = [Security.Principal.WindowsIdentity]::GetCurrent()
        (New-Object Security.Principal.WindowsPrincipal $User).IsInRole(
            [Security.Principal.WindowsBuiltinRole]::Administrator
        )
    }

    Function Invoke-Admin() {
        <#
        .SYNOPSIS
            Invoke a new instance of Powershell with elevated admin rights

        .EXAMPLE
            C:\PS> Invoke-Admin

        .EXAMPLE
            C:\PS> Invoke-Admin Python -m pip --help
        #>
        param (
            [string]$Argument = "",
            [switch]$WaitForExit
        )

        $PSAdmin = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
        $PSAdmin.Arguments, $PSAdmin.Verb = $Argument, "runas"
        $PSAdmin = [Diagnostics.Process]::Start($PSAdmin)

        if ($waitForExit) {
            $PSAdmin.WaitForExit();
        }
    }

    Export-ModuleMember -Function Test-Admin
    Export-ModuleMember -Function Invoke-Admin
}