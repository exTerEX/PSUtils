<#
    .SYNOPSIS
        Retrieve gitignore template, and write to stdout

    .EXAMPLE
        C:\PS> Get-Gitignore python

            # Created by https://www.toptal.com/developers/gitignore/api/python
            # Edit at https://www.toptal.com/developers/gitignore?templates=python

            ### Python ###
            # Byte-compiled / optimized / DLL files

            ...

            # ruff
            .ruff_cache/

            # LSP config files
            pyrightconfig.json

            # End of https://www.toptal.com/developers/gitignore/api/python
#>

Set-StrictMode -Off;

[String[]] $List = $Args
$Params = $List -Join ","

if (!$Params) {
    "usage: Get-Gitignore [args]";

    "args:";

    Invoke-Restmethod -Uri "https://www.gitignore.io/api/list"

    Exit 1
}

Invoke-Restmethod -Uri "https://www.gitignore.io/api/$Params"

Exit 0