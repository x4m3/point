#! /usr/bin/env python2
from subprocess import check_output

def pass_gmail():
    return check_output("pass google/loctauxphilippe/email-app-password", shell=True).splitlines()[0]
