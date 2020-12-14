import cv2
  
image = cv2.imread('lena_color.png')
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
  
#cv2.imshow('Original image',image)
cv2.imshow('Gray image', gray)
  
k = cv2.waitKey(0)
if k == 27:         # wait for ESC key to exit
    cv2.destroyAllWindows()
elif k == ord('s'): # wait for 's' key to save and exit
    cv2.imwrite('lena_gray.png',gray)
    cv2.destroyAllWindows()
