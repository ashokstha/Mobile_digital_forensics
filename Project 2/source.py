#!/bin/python3
import os
import shutil
from os import listdir
from os.path import isfile, join
import hashlib

inFile = "../../sheep.jji"
# inFile = "../../jji_project.001"

magic_numbers = {'jji_start': b'\x00\x4a\x00\x4f\x00\x53\x00\x48',
                 'jji_end': b'\x00\x4a\x00\x4f\x00\x4e\x00\x45\x00\x53'}
max_read_size = 10

outpath = "output_files"
outfile = "result.txt"
ofile = open(outfile,"w")

def create_dir(path):
    if os.path.exists(path):
        shutil.rmtree(path)
    os.makedirs(path)


def md5(fname):
    # fname = outpath + "/" + fname
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

def save_file(display):
    print(display)
    ofile.write(display+"\n")


def main():
    print("\nStart")
    print("Extracting files ...\n")

    save_file("+-------+------------------------------------+------------+")
    save_file("|  S.N. |                Hash                |    Size    |")
    save_file("+-------+------------------------------------+------------+")

    BUF_SIZE = 10
    start_addr = 0
    end_addr = 0
    cnt = 1
    byte_size = 100

    create_dir(outpath)

    with open(inFile, "rb") as f:
        buf = f.read(BUF_SIZE)
        while buf:
            if buf.startswith(magic_numbers['jji_start']):
                start_addr = f.tell()
                # print("Start_addr: {0}".format(start_addr))
            elif buf.startswith(magic_numbers['jji_end']):
                end_addr = f.tell()
                # print("End_addr: {0}".format(end_addr))

                size = end_addr - start_addr + BUF_SIZE
                result_path = outpath + "/file_" + str(cnt) + ".txt"

                with open(result_path, "a+b") as r:
                    f.seek(-size, 1)

                    # read data of small size and save into file
                    while size > 0:
                        if size > byte_size:
                            bytes = f.read(byte_size)
                        elif size > 0:
                            bytes = f.read(size)
                        r.write(bytes)
                        size -= byte_size

                hash = md5(result_path)
                filesize = end_addr - start_addr + BUF_SIZE
                save_file("| {0:4}  |  {1:32}  |  {2:8}  |".format(cnt, hash, filesize))

                save_file("+-------+------------------------------------+------------+")
                
                cnt += 1
            else:
                f.seek(-max_read_size + 1, 1)

            buf = f.read(BUF_SIZE)

    print("\nExtracting files complete.\n")

if __name__ == "__main__":
    main()
