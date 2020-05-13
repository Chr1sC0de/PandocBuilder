using namespace System.IO
#----------------------------------------------------------------------------------
Class File {
    [FileInfo]$path
    [string]$name
    [string]$extension
    [bool]$is_null = $true

    File(){}

    File ([string]$path){
        $this.Init([FileInfo]::new($path))
    }

    File([FileInfo]$path){
        $this.Init($path)
    }

    Hidden Init([FileInfo]$path){
        $this.path = $path
        $this.is_null = $false
        $this.name = $this.path.Name
        $this.extension = $this.path.Extension
    }

    [string] as_option(){
        throw "as_option must be overriden by the child class"
    }
}
#----------------------------------------------------------------------------------
class InputFile: File {

    InputFile(){}
    InputFile([string]$path): base($path){}
    InputFile([FileInfo]$path): base($path){}

    Hidden Init([FileInfo]$path){
        ([File]$this).Init($path)
        $this.exists()
        $this.check_extension 
    }

    Hidden exists(){
        if (-Not $this.path.Exists){
            throw "file $this.path.Name does not exist"
        }
    }

    Hidden check_extension(){
        if ($this.path.Extension.ToLower() -ne ".md"){
            throw "file $this.path.Name is not markdown"
        }
    }

    [string] as_option(){
        return $this.path.FullName
    }

}
#----------------------------------------------------------------------------------
class OutputFile: File {

    OutputFile(){}
    OutputFile([string]$path): base($path){}
    OutputFile([FileInfo]$path): base($path){}

    Hidden Init([FileInfo]$path){
        ([File]$this).Init($path)
        $this.parents_exist()
    }

    Hidden parents_exist(){
        $parent_directory = $this.path.Directory
        if (-Not $parent_directory.Exists){
            throw "the parent directory $parent_directory does not exist"
        }
    }

    [string] as_option(){
        return  "-o" + " " + $this.path.FullName
    }

}
#----------------------------------------------------------------------------------
class YAMLFile: InputFile{

    YAMLFile(){}
    YAMLFile([string]$path): base($path){}
    YAMLFile([FileInfo]$path): base($path){}

    Hidden check_extension(){
        if ($this.path.Extension.ToLower() -ne ".yaml"){
            throw "file $this.path.Name is not yaml"
        }
    }

    Hidden Init([FileInfo]$path){
        ([File]$this).Init($path)
        $this.check_extension()
    }
}
#-----------------------------------------------
class FileFolder {

    [InputFile[]]$files = @()
    [FileFolder[]]$folders = @()

    [DirectoryInfo]$path

    FileFolder([DirectoryInfo]$path){
        $this.init($path)
    }

    FileFolder([string]$path){
        $this.init($path)
    }

    Hidden init([DirectoryInfo]$path){
        $this.path = $path
        $this.exists()
        $this.find_files()
    }
    
    Hidden exists(){
        if (-Not $this.path.Exists){
            throw "folder $this.Name does not exist"
        }
    }

    Hidden find_files(){

        foreach ($item in $this.path.GetFiles()){
            $this.files += [InputFile]::new($item)
        }

        foreach ($item in $this.path.GetDirectories()){
            $folder = [FileFolder]::new($item)
            $this.files += $folder.files
            $this.folders += $folder
        }

    }


}
#-----------------------------------------------
class Option {

    [string]$flag
    [string]$value

    Option([string]$flag){
        $this.init($flag, "")
    }

    Option([string]$flag,[string]$value){
        $this.init($flag, $value)
    }

    Hidden init([string]$flag, [string]$value){
        $this.set_flag($flag)
        $this.value = $value
    }

    set_flag([string]$flag){
        if (-Not $flag.StartsWith("-")){
            throw "invalid flag"
        }
        $this.flag = $flag
    }

    set_value([string]$value){
        $this.value = $value
    }

    [string] as_option(){
        if ($this.value.Length -eq 0){
            return $this.flag
        } else {
            $output = $this.flag
            $output += " "
            $output += $this.value
            return $output
        }
    }
}
#-----------------------------------------------
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
#-----------------------------------------------
