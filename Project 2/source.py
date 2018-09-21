"""
/*-------------------------------------------------------------------------------
* (CS 480-01) (FA18) MOBILE DIGITAL FORENSICS
*                Project 2
*               Submitted By
*           Ashok Kumar Shrestha
*
* Description:
* ============
* Python script to parse out .JJI (Josh Jones Image) Files from the data files.
*--------------------------------------------------------------------------------*/
"""


#!/bin/python3
import os
import shutil
from os import listdir
from os.path import isfile, join
import hashlib
from argparse import ArgumentParser
import sys

inFile = "../../sheep.jji"
#inFile = "../../jji_project.001"

outpath = "output_files"
outfile = "result.txt"

magic_numbers = {'jji_start': b'\x00\x4a\x00\x4f\x00\x53\x00\x48',
                 'jji_end': b'\x00\x4a\x00\x4f\x00\x4e\x00\x45\x00\x53'}
max_read_size = 10
BUF_SIZE = 10
byte_size = 128

def create_dir(path):
    #remove output directory
    if os.path.exists(path):
        shutil.rmtree(path)
    os.makedirs(path)

    #remove output hash file
    if os.path.exists(outfile):
        os.remove(outfile)


def md5(fname):
    # fname = outpath + "/" + fname
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

def save_file(display):
    print(display)
    with open(outfile,"a") as ofile:
        ofile.write(display+"\n")

def check_args():
    parser = ArgumentParser()
    parser.add_argument("-f", "--file", dest="filename",
                        help="Path for image file", metavar="FILE_PATH")

    args = parser.parse_args()
    inFile =  args.filename
    if not os.path.exists(inFile):
        print("\nCould not open file. File missing or not found.\n")
        sys.exit()
    
    return inFile

def main():

    inFile = check_args()

    print("\nStart")
    print("Extracting files ...\n")
    create_dir(outpath)

    save_file("+-------+------------------------------------+------------+")
    save_file("|  S.N. |                Hash                |    Size    |")
    save_file("+-------+------------------------------------+------------+")

    cnt = 1
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
                if cnt<541:
                    f.seek(-max_read_size + 1, 1)

            buf = f.read(BUF_SIZE)

    print("\nExtracting files complete.\n")

if __name__ == "__main__":
    main()
