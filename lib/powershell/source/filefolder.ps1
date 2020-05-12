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