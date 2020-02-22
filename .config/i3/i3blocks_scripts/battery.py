#!/usr/bin/python3

import os
import subprocess
import math

if __name__ == "__main__":
    color = "#FFFFFF"
    
    charging = subprocess.check_output(['cat', '/sys/class/power_supply/BAT0/status']).decode().rstrip()
    energy_now = subprocess.check_output(['cat', '/sys/class/power_supply/BAT0/energy_now']).decode().rstrip()
    energy_full = subprocess.check_output(['cat', '/sys/class/power_supply/BAT0/energy_full']).decode().rstrip()
    
    percentage = math.floor((int(energy_now) / int(energy_full)) * 100)

    if percentage <= 20:
        color = "#D50000"

    if charging != "Discharging":
        color = "#FFD600"
        if energy_now == energy_full:
            color = "#00C853"

    if percentage < 10:
        percentage = " " + str(percentage)

    print(str(percentage) + "%")
    print(str(percentage) + "%")
    print(color)
