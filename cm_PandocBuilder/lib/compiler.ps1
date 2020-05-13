class Compiler {

    [OutputFile]$output_file
    [YAMLFile]$settings_file

    [Option[]]$options = @()
    [InputFile[]]$input_files = @()

    Compiler([OutputFile]$output_file){
        $this.output_file = $output_file
    }

    add_folder([DirectoryInfo]$path){
        $this.input_files += [FileFolder]::new($path).files
    }
    add_folder([FileFolder]$path){
        $this.input_files += $path.files
    }
    add_folder([string]$path){
        $path = [DirectoryInfo]::new($path)
        $this.input_files += [FileFolder]::new($path).files
    }

    add_file([InputFile]$file){
        $this.input_files += $file
    }
    add_file([string]$file){
        $file = [InputFile]::new($file)
        $this.input_files += $file
    }

    add_option([Option]$option){
        $this.options += $option
    }
    add_option([string]$flag, [string]$value){
        $option = [Option]::new($flag, $value)
        $this.options += $option
    }
    add_option([string]$flag){
        $option = [Option]::new($flag)
        $this.add_option($option)
    }


    run(){

        $command = "pandoc"

        foreach ($option in $this.options){
            $command += (" " + $option.as_option())
        }

        $command += (" " + $this.output_file.as_option())

        foreach ($file in $this.input_files){
            $command += (" " + $file.as_option())
        }

        Invoke-Expression $command

    }

}
