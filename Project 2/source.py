#!/bin/python3
import os
import shutil

inFile = "../../sheep.jji"

magic_numbers = {'jji_start': b'\x00\x4a\x00\x4f\x00\x53\x00\x48',
                 'jji_end': b'\x00\x4a\x00\x4f\x00\x4e\x00\x45\x00\x53'}
max_read_size = 10

outpath = "output_files"


def create_dir(path):
    if os.path.exists(path):
        shutil.rmtree(path)
    os.makedirs(path)

def save_file(filename, bytes):
    with open(filename,"w+b") as f:
    	f.seek(0)
    	f.write(bytes)

def main():
    print("Reading file ...")

    BUF_SIZE = 10
    start_addr = 0
    end_addr = 0

    create_dir(outpath)

    with open(inFile, "rb") as f:
        buf = f.read(BUF_SIZE)
        while buf:
            if buf.startswith(magic_numbers['jji_start']):
                start_addr = f.tell()
                print("Start_addr: {0}".format(start_addr))
            elif buf.startswith(magic_numbers['jji_end']):
                end_addr = f.tell()
                print("End_addr: {0}".format(end_addr))

                size = end_addr - start_addr + BUF_SIZE
                result_path = outpath + "/result.txt"
                with open(result_path, "a+b") as r:
                    f.seek(-size,1)

                    #read data of small size and save into file
                    bytes = f.read(size)
                    r.write(bytes)
                    
                    f.seek(0,1)

            else:
                f.seek(-max_read_size + 1, 1)

            buf = f.read(BUF_SIZE)

    print("Complete.")


if __name__ == "__main__":
    main()
