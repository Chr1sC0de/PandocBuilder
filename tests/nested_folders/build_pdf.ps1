using module "D:\Github\PandocBuilder\cm_PandocBuilder.psm1"

$builder = [Compiler]::new("$PSScriptRoot/test.pdf")

$source_folder = [FileFolder]::new("$PSScriptRoot/source")

$builder.add_folder($source_folder)

$builder.run()


