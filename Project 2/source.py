#!/bin/python3
import re

inFile = "../../sheep.jji"

def main():

    print("Reading file ...")

    pattern = re.compile("J.?O.?S.?H.?(\s|[\s\S])*\x01\x01")

    with open(inFile, encoding='latin1') as f:
        for line in f:
            match = pattern.search(line, re.MULTILINE) 
            if match:
                print(match)


    print("Complete.")


if __name__=="__main__":
    main()