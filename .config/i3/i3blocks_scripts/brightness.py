#!/usr/bin/python3

import subprocess

if __name__ == "__main__":
    color = "#FFFFFF"
    
    percent = subprocess.check_output(['light', '-G']).decode().rstrip()

    print(str(percent) + "%")
    print(str(percent) + "%")
    print(color)
