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

# Method 1:  Call (can't process output)

subprocess.call(
        [cmd], shell=True,
        cwd='/home/blake/git/Security/gensec/rkhunter'
        )

# Method 2: (process output if required)

process = subprocess.Popen(
    [cmd],
    shell=True,
    cwd='/home/blake/git/Security/gensec/rkhunter',
    universal_newlines=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT
    )

with process.stdout:
    for line in iter(process.stdout.readline, b''):
        sys.stdout.write(line)
        sys.stdout.flush()
    process.kill()
    #os.killpg(os.getpgid(pro.pid), signal.SIGTERM)


#p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
#p = subprocess.Popen(['which', 'nice'], stdout=subprocess.PIPE, universal_newlines=True).communicate()[0].rstrip()
#stdout, stderr = p.communicate()
#print(stdout)
