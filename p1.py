#!/usr/bin/python
import re
import sys

filename = '../usb256.raw'
#filename = '../p1.pl'


def display_errors():
    print("Error! Incorrect syntax!\n")
    print("Usage\npython filename.py -[phonenumbers | emails]*\n")
    print("Examples:")
    print("python filename.py")
    print("python filename.py -emails")
    print("python filename.py -phonenumbers")
    print("python filename.py -emails -phonenumbers")
    print("python filename.py -phonenumbers -emails")


def fetch_emails(file_path):
    print("Fetching emails ...\n")

    EMAIL_REGEX = re.compile(r"^[\w-]+(\.[\w-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,})$")

    with open(file_path) as data:
        lines = data.readlines()
        for line in lines:
            print(line)
            if EMAIL_REGEX.match(line):
                print("Email: ")


def fetch_numbers(file_path):
    print("Fetching phone numbers ...\n")


def fetch_emails_numbers(file_path):
    print("Fetching emails and phonenumbers ...\n")


def fetch_values(file_path):
    # fetch arguments
    num_of_params = len(sys.argv) - 1
    args = sys.argv[1:]

    if (num_of_params == 1 and args[0] == "-emails"):
        fetch_emails(file_path)
    elif (num_of_params == 1 and args[0] == "-phonenumbers"):
        fetch_numbers(file_path)
    elif (num_of_params == 0 or
          (num_of_params == 2 and ((args[0], args[1]) == ("-phonenumbers", "-emails") or (args[0], args[1]) == (
                  "-emails", "-phonenumbers")))):
        fetch_emails_numbers(file_path)
    else:
        display_errors()


def main():
    print("\n----------------------------------------------------------------------------")
    fetch_values(file_path=filename)
    print("----------------------------------------------------------------------------\n")


if __name__ == "__main__":
    main()
