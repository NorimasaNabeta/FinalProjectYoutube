# -*- mode: python; coding: utf-8 -*-
#
# Time-stamp: <2012-08-31 22:31:46 NorimasaNabeta>
#

import plistlib
import datetime
import time
import re

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
                    ctclass.append(tmp)
                tmp = {}
                state = 0
            elif (re.match('^#', line)):
                pass
            else:
                tmp[ tags[state] ] = line
                state = state + 1
    if (state > 2):
        ctclass.append(tmp)

    return ctclass

if __name__ == '__main__':
    output_pl = dict(
        title = "Coding Together Summer2012",
        description = "Coding Together: Apps for iPhone and iPad", 
        date = datetime.datetime.fromtimestamp(time.mktime(time.gmtime())),
        version = 1,
        students = readTextData('studentlist.txt') 
        )
    plistlib.writePlist(output_pl, 'CodingTogetherSummer2012.plist')


