
#ifndef _IMAGE_H_
#define _IMAGE_H_

void pixelType(unsigned char *image, int height, int width, 
               int x, int y, 
               int *background, int *object, int *boundary);

void contour(unsigned char *inImage, unsigned char *outImage, int height, int width);

void printImage(unsigned char *image, int height, int width);

#endif

