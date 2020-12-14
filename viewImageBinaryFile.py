imageWidth = 1280;
imageHeight = 720;
numColor = 1;

import numpy as np
import cv2 as cv
import sys
fd = open(sys.argv[1], 'rb')
f = np.fromfile(fd, dtype=np.uint8,count=imageHeight*imageWidth*numColor)
img = f.reshape((imageHeight, imageWidth, numColor))
ima1 = cv.cvtColor(img,cv.COLOR_BGR2RGB)
fd.close()
cv.imshow('', ima1)
#cv.waitKey()
#cv.destroyAllWindows()

k = cv.waitKey(0)
if k == 27:         # wait for ESC key to exit
    cv.destroyAllWindows()
elif k == ord('s'): # wait for 's' key to save and exit
    cv.imwrite('audi_sharp.jpg',img)
    cv.destroyAllWindows()