import pathlib as pt

if __name__ == '__main__':

    cwd = pt.Path(__file__).parent

    contents_file = cwd/"00_contents.md"

    md_files = list(cwd.glob('*md'))

    md_files.sort(key=lambda x: int(x.name.split('_')[0]))

    output_string = "# Contents\n\n"

    for i, f in enumerate(md_files):
        if f.name != contents_file.name:
            with open(f, 'r') as file:
                heading = file.readline()
            heading = heading.strip('#')
            heading = heading.strip('\n')
            heading = heading.strip(' ')
            output_string += f"{i}. [{heading}]({f.name})\n"

    with open(contents_file, 'w') as f:
        f.write(output_string)

    pass