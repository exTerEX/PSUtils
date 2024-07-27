<#
    .SYNOPSIS
        Convert Word files to PDF

    .EXAMPLE
        C:\PS> Convert-WordToPDF

    .EXAMPLE
        C:\PS> Convert-WordToPDF test.docx
#>

$Word = New-Object -ComObject Word.Application
$Word.Visible = $true

[String[]] $Path = $Args

Get-ChildItem -Path $Path -Include *.docx, *.doc -Recurse -File | ForEach-Object -Process {
    if (Test-Path -Path "$($_.DirectoryName)\$($_.BaseName).pdf") {
        $SkippedFiles += "`n$($_.FullName)"

        return
    } else {
        $ConvertedFiles += "`n$($_.FullName)"
    }

    $Document = $Word.Documents.Open($_.FullName)
    $Document.SaveAs("$($_.DirectoryName)\$($_.BaseName).pdf", 17)
    $Document.Close()
}

# Garbage collection
$Word.Quit()
$null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Word)
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

if ($ConvertedFiles) {
    ForEach-Object -Process {
        [PSCustomObject]@{ "Converted Files" = $ConvertedFiles }
    } | Format-Table -AutoSize -Wrap
}
if ($SkippedFiles) {
    ForEach-Object -Process {
        [PSCustomObject]@{ "Skipped Files" = $SkippedFiles }
    } | Format-Table -AutoSize -Wrap
}