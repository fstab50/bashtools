#!/usr/bin/env python3

import os
import sys
import subprocess


class BadRCError(Exception):
    print(Exception)
    pass


def run_command(cmd):
    """ No idea if this works """
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()
    if p.returncode == 0:
        os.killpg(os.getpgid(pro.pid), signal.SIGTERM) 
    else:
        raise BadRCError("Bad rc (%s) for cmd '%s': %s" % (p.returncode, cmd, stdout + stderr))
    return stdout


def parameters(args):
    parameter_str = ''
    for arg in args:
        parameter_str += arg + ' '
    return parameter_str

    
cmd = 'sudo sh rkhunter-install.sh ' + parameters(sys.argv[1:])



# Method 1:  Call --------------------------------------------------------------

    # can't process stdout stream
    # CAN perform user interface operations for interaction
    
subprocess.call(
        [cmd], shell=True,
        cwd='/home/blake/git/Security/gensec/rkhunter'
        )

sys.exit(0)


# Method 2: subprocess.Popen  --------------------------------------------------



    # - can process output if required
    # - Need to know how to SIGINT after execution -- shell script retains control


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
    process.kill()      # DOES NOT WORK
    os.killpg(os.getpgid(pro.pid), signal.SIGTERM)  # DOES NOT WORK



