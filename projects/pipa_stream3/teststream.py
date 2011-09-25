import unittest
from time import sleep

from stream import FFMpegProcess

class TestFFMpegProcess(unittest.TestCase):
    def test_parse(self):
        p= FFMpegProcess("ffmpeg -y -i video.avi video.mp4")
        while(1):
            if not p.isRunning():
                break
            lines= p.parseStatus()
            if not lines:
                continue
            print "New status:"
            for line in lines:
                print line
            sleep(0.01)
if __name__ == '__main__':
        unittest.main()
