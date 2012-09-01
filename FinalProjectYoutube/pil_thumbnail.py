# -*- mode: python; coding: utf-8 -*-
#
# Time-stamp: <2012-09-02 07:56:56 NorimasaNabeta>
#
# [PIL required]
#
from PIL import Image,ImageDraw,ImageColor
import sys
import os.path


# thumbnail placeholder icons generator
#
# Usage:
#  python pil_thumbnail.py <directory_name>
#
#
def createThumbnailSizePlaceHolderIcon(colorName,saveDir):
    img = Image.new('RGBA', (48,48), (255,255,255,0))
    draw=ImageDraw.Draw(img)
    for x in xrange(4,8,1):
        draw.rectangle(
            (x,x,img.size[0]-x,img.size[1]-x),
            outline=ImageColor.getrgb(colorName))
    del draw
    try:
        if not os.path.exists(saveDir):
            os.makedirs(saveDir)
        outfile=os.path.join(saveDir,("%s.png" % colorName))
        img.save(outfile,"PNG",interlace=False);
    except IOError:
        print "Cannot create file:", infile

    return
#
#
#
if __name__ == "__main__":

    if len(sys.argv) > 1 :
        saveDir = sys.argv[1]
    else:
        saveDir = "icons"

    for color in ImageColor.colormap.keys():
        createThumbnailSizePlaceHolderIcon(color,saveDir)


