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