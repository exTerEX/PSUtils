#Requires -Version 3.0

New-Module -Name filesystem -ScriptBlock {
    Function Hide-File() {
        <#
        .SYNOPSIS
            Hide a specific file in the Windows explorer

        .EXAMPLE
            C:\PS> Hide-File /path/to/file

        .EXAMPLE
            C:\PS> Hide-File -Path /path/to/file
        #>

        param(
            [Parameter(Mandatory)]
            [String]$Path
        )

        if (!(((Get-Item -Path $Path -Force).Attributes.ToString() -Split ", ") -Contains "Hidden")) {
            (Get-Item -Path $Path -Force).Attributes += "Hidden"
        }
    }

    Function New-Directory() {
        <#
        .SYNOPSIS
            Create a new folder at the specific path

        .EXAMPLE
            C:\PS> New-Directory /path

        .EXAMPLE
            C:\PS> New-Directory -Path /path

        .EXAMPLE
            C:\PS> New-Directory -Path /path -Hide
        #>

        param (
            [Parameter(Mandatory)]
            [String]$Path,
            [Switch]$Hide
        )

        process {
            if (!(Test-Path $Path)) {
                New-Item -Path $Path -ItemType "directory" | Out-Null
            }

            if ($Hide) { Hide-File($Path) }
        }
    }

    Function Set-Softlink() {
        <#
        .SYNOPSIS
            Create a soft/symbolic link to path from target

        .EXAMPLE
            C:\PS> Set-Softlink -Path /path/1 -Target /path/2

        .EXAMPLE
            C:\PS> Set-Softlink -Path /path/1 -Target /path/2 -Hide
        #>

        param (
            [Parameter(Mandatory)]
            [string]$Path,
            [Parameter(Mandatory)]
            [String]$Target,
            [switch]$Hide
        )

        process {
            if (Test-Path -Path $Path) {
                if (!(Get-Item $Path -Force).LinkType -eq "SymbolicLink") {
                    Rename-Item -Path $Path -NewName "$((Get-Item -Path $Path).Name).old" # TODO: Add variable
        
                    New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
                }
            }
            else {
                New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
            }

            if ($Hide) { Hide-File($Path) }
        }
    }

    Function Set-Hardlink() {
        <#
        .SYNOPSIS
            Create a soft/symbolic link to path from target

        .EXAMPLE
            C:\PS> Set-Hardlink -Path /path/1 -Target /path/2

        .EXAMPLE
            C:\PS> Set-Hardlink -Path /path/1 -Target /path/2 -Hide
        #>

        param (
            [Parameter(Mandatory)]
            [string]$Path,
            [Parameter(Mandatory)]
            [String]$Target,
            [switch]$Hide
        )

        process {
            if (Test-Path -Path $Path) {
                if (!(Get-Item $Path -Force).LinkType -eq "SymbolicLink") {
                    Rename-Item -Path $Path -NewName "$((Get-Item -Path $Path).Name).old"  # TODO: Add variable
        
                    New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
                }
            }
            else {
                New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
            }

            if ($Hide) { Hide-File($Path) }
        }
    }

    Export-ModuleMember -Function Hide-File
    Export-ModuleMember -Function New-Directory
    Export-ModuleMember -Function Set-Softlink
    Export-ModuleMember -Function Set-Hardlink
}