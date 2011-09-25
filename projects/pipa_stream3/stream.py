#!/bin/python
import os
import subprocess
import fcntl
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

class Process(object):
    def __init__(self,command):
        self.process = subprocess.Popen(command.split(), stderr=subprocess.PIPE,stdout = subprocess.PIPE )
        self._setNonBlocking()

    def _setNonBlocking(self):
        fd = self.process.stderr.fileno()
        fl = fcntl.fcntl(fd, fcntl.F_GETFL)
        fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)

    def isRunning(self):
        self.process.poll()
        if self.process.returncode==None:
            return True
        return False

    def Terminate(self):
        self.process.terminate()

    def Kill(self):
        self.process.kill()

    def readLine(self):
        line = ""
        self.process.stderr.flush()
        while(1):
            try: ch= self.process.stderr.read(1)
            except: return line
            if ch=="\n":
                return line
            line+=ch

    def readLines(self):
        lines= []

        while(1):
            line= self.readLine()
            if not line:
                return lines
            lines+= [line]

class FFMpegProcess(Process):
    def __init__(self, command):
        Process.__init__(self, command)

    def parseStatus(self):
        lines= self.readLines()
        result=[]
        if not lines:
            return None
        for line in lines:
            if "frame=" in line:
                params= line.split("=")
                for i, param in enumerate(params):
                    if i==len(params)-1:
                        break
                    if i==0:
                        k=param
                        v=params[1].split()[0]
                    else:
                        k=param.split()[1]
                        v=params[i+1].split()[0]
                    result+=[[k,v]]
        return result

if __name__ == "__main__":
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

