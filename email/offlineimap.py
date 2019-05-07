#! /usr/bin/env python2
from subprocess import check_output

def pass_epitech():
    return check_output("pass epitech/philippe.loctaux@epitech.eu", shell=True).splitlines()[0]
def pass_plcom():
    return check_output("pass plcom/email-app-password", shell=True).splitlines()[0]
