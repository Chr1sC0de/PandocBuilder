import pathlib as pt
import subprocess

class PandocCompiler:
    pass

class File:
    pass

class Option:
    pass

if __name__ == "__main__":
    
    cwd =pt.Path(__file__).parent

    files = list(cwd.glob("*.md"))

    extension = "html"

    filename = "test"

    output_file = files[0].parent/("%s.%s"%(filename, extension))

    pandoc_command = ["pandoc"]

    options = ["-o"]

    pandoc_command.extend([files[0].as_posix()])

    pandoc_command.extend(options)

    pandoc_command.extend([output_file.as_posix()])

    pandoc_command = " ".join(pandoc_command)

    subprocess.call(pandoc_command)

    pass
