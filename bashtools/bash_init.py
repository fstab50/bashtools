#!/usr/bin/env python3

import os
import sys
import subprocess


class BadRCError(Exception):
    pass


def run_command(cmd):
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()
    if p.returncode != 0:
        raise BadRCError("Bad rc (%s) for cmd '%s': %s" % (p.returncode, cmd, stdout + stderr))
    return stdout   


cmd = 'sudo sh rkhunter-install.sh --help'

print(run_command(cmd))
sys.exit(0)

#p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
#p = subprocess.Popen(['which', 'nice'], stdout=subprocess.PIPE, universal_newlines=True).communicate()[0].rstrip()
#stdout, stderr = p.communicate()
#print(stdout)
