$names = @(
    "files.ps1",
    "filefolder.ps1",
    "option.ps1",
    "compiler.ps1"
)

$files = @()

$lenfiles = $names.Length
$counter = 0

while ($counter -lt $lenfiles){
    $name = $names[$counter]
    $files += [System.IO.FileInfo]::new("$PSScriptRoot/$name")
    $counter += 1
}

$output_item = [System.IO.FileInfo]::new("$PSScriptRoot.FullName/../compiler.ps1")
Remove-Item $output_item
New-Item $output_item

$divider = "#-----------------------------------------------"

foreach ($item in $files){

    Get-Content $item | Out-File -FilePath $output_item -Append
    $divider | Out-File -FilePath $output_item -Append
    
}