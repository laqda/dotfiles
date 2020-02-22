#!/usr/bin/python3

import os
import subprocess
import math
import netifaces as ni

if __name__ == "__main__":
    wlp82s0 = ni.ifaddresses('wlp82s0')
    enp0s31f6 = ni.ifaddresses('enp0s31f6')
    
    if ni.AF_INET in wlp82s0:
        wlp82s0 = wlp82s0[ni.AF_INET][0]['addr']
    else:
        wlp82s0 = "disconnected"
  
    if ni.AF_INET in enp0s31f6:
        enp0s31f6 = enp0s31f6[ni.AF_INET][0]['addr']
    else:
        enp0s31f6 = "disconnected"

    print("  " + enp0s31f6 + "   " + wlp82s0)
    print("  " + enp0s31f6 + "   " + wlp82s0)
    print("#FFFFFF")
