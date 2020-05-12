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