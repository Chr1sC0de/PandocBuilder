'''
for a specified number increment all the markdown files
'''
import pathlib as pt
import click

@click.command()
@click.option("--start", default=2, help="file to start the increment")
@click.option("--amount", default=1, help="amount to increment the file numbers")
def main(start, amount):
    files = list(pt.Path().glob("*.md"))
    for file in files:
        filename = file.name
        split = filename.split("_", 1)
        file_id = int(split[0])
        basename = split[1]
        if file_id >= start:
            file_id += amount
            new_filename = '%02d_%s'%(file_id, basename)
            file.rename(new_filename)

if __name__ == "__main__":
    main()
