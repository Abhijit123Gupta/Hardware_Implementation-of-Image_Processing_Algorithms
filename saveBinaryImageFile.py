import cv2 as cv
import sys
img = cv.imread(sys.argv[1])
#img = cv.imread("lena_color.tiff")
#print("Image read")
#cv.imshow("len_color_image", img)
#cv.waitKey()
#cv.destroyAllWindows()
ima1 = cv.cvtColor(img,cv.COLOR_BGR2RGB)
#cv.imshow("len_color_image_cov", ima)
#cv.waitKey()
#cv.destroyAllWindows()
f=open(sys.argv[2],'wb')
#f=open("lena_binary.bin",'wb')
f.write(ima1)
f.close()