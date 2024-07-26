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

[string[]] $list = $args
$params = $list -join ","

if (!$params) {
    "usage: Get-Gitignore [args]";

    "args:";

    invoke-restmethod -uri "https://www.gitignore.io/api/list"

    exit 1
}

invoke-restmethod -uri "https://www.gitignore.io/api/$params"

exit 0
