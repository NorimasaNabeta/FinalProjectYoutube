# -*- mode: python; coding: utf-8 -*-
#
# Time-stamp: <2012-08-31 22:31:46 NorimasaNabeta>
#
import sys
import os
import re
import plistlib
import datetime
import time
from urllib import urlretrieve
import tempfile


#
#
# http://img.youtube.com/vi/%@/2.jpg
def fetchThumbnail( videoId ):
    filePath=tempfile.mktemp(suffix = '.png')
    urlretrieve(("http://img.youtube.com/vi/%s/2.jpg" % videoId), filePath)
    imagef = open(filePath)
    imageData = imagef.read()
    imagef.close()
    os.remove(filePath)
    return plistlib.Data(imageData)

#
#
#
def readTextData( filename ):
    tags = [ 'app', 'youtube', 'name', '' ]
    f = open(filename)
    data = f.read()
    f.close()

    ctclass = []
    tmp = {}
    state=0
    for line in data.split('\n'):
        if ( len(line) > 0 ):
            if (re.match('^@', line)):
                if (state > 2):
                    tmp[ 'thumbnail' ] = fetchThumbnail( tmp[ 'youtube' ] )
                    ctclass.append(tmp)
                tmp = {}
                state = 0
            elif (re.match('^#', line)):
                pass
            else:
                tmp[ tags[state] ] = line
                state = state + 1
    if (state > 2):
        tmp[ 'thumbnail' ] = fetchThumbnail( tmp[ 'youtube' ] )
        ctclass.append(tmp)

    return ctclass
#
#
#
if __name__ == '__main__':
    if len(sys.argv) > 2 :
        inputTextDatafile = sys.argv[1]
        outputPlistFile   = sys.argv[2]
    else:
        inputTextDatafile = './studentlist.txt'
        outputPlistFile   = './CodingTogetherSummer2012.plist'

    outputPlist = dict(
        title = "Coding Together Summer2012",
        description = "Coding Together: Apps for iPhone and iPad", 
        date = datetime.datetime.fromtimestamp(time.mktime(time.gmtime())),
        version = 1,
        students = readTextData(inputTextDatafile) 
        )
    plistlib.writePlist(outputPlist, outputPlistFile)
    # convert into the binary plist form
    # https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/plutil.1.html
    # plutil -convert binary1 outputPlistFile
    os.system(('plutil -convert binary1 %s' % outputPlistFile))



