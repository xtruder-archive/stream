#!/bin/python
import subprocess
import pystache
from time import gmtime, strftime

class Stream(pystache.View):
    def __init__(self, dumpf, res):
        pystache.View.__init__(self)

        self.dumpf= dumpf
        self.res= res
    def dumpfile(self):
        return self.dumpf
    def resolution(self):
        return self.res

dump_trailing= ".dv"

dump= raw_input("Ime predavanja: ")
kamera= raw_input("Katero kamero uporabljate(nova/stara)?")
date= strftime("%d-%m-%Y-%H-%M", gmtime())
if not dump:
    dump= date+dump_trailing
else:
    dump= date+"_"+dump+dump_trailing
if kamera=="stara":
    res= "768x567"
else:
    res= "720x405"

fftemplate= Stream(dump,res)
print fftemplate.render()
