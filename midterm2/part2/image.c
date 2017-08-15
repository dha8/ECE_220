#include <stdio.h>
#include <stdlib.h>
#include "image.h"

/* 
   pixelType determines pixel type: object, background, or boundary

   INPUT:  base address of image array: image
           image size: height and width
           pixel coordinates: x, y
           addresses of output variables: background, object, boundary

   OUTPUT: one of "background", "object", or "boundary" is set to 1 to indicate the pixel type
           whereas the remaining 2 values are set to 0
*/ 
void pixelType(unsigned char *image, int height, int width, 
               int x, int y, 
               int *background, int *object, int *boundary)
{
		//if value == 0, is background
		if(image[y*width+x] == 0){
				*background = 1;
				*object = 0;
				*boundary = 0;
				return;
		}
		//check for boundary pixel

        //REGRADE REQUEST PART! if boundary of picture, it's a boundary pxl
        if(y == 0 || y == height-1 || x == 0 || x == width-1){
            *background = 0;
            *object = 0;
            *boundary = 1;
            return;
        } 
        //--------------------

		//top 3 pixels first
		int topidx = (y-1)*width+x-1; //starting index of the top 3 pixels
		int topend = topidx+3; //ending boundary of the top 3 pixels
		int x_chk = x-1; //x and y to check for boundary within the img
		int y_chk = y-1;
		for(;topidx<topend;++topidx){
				//check for bounds
				if(topidx < 0 || topidx > width*height) continue; // checks if within pixel arr
				if(x_chk<0 || x_chk >= width || y_chk<0 || y_chk>=height) continue;//check if within img boundary
				if(image[topidx] == 0){ //if bound, set the bound to 1
						*background = 0;
						*object = 0;
						*boundary = 1;
						return;
				}
				x_chk++; //increment x_chk to check if within img boundary of next pixel
		}
		//check for left and right pixel
		int LRidx = y*width+x-1; //starting index of Left & Right pixels(middle row)
		int LRend = y*width+x+2; // ending index of "
		x_chk = x-1; // x and y for img boundary check
		y_chk = y;
		for(;LRidx<LRend;++LRidx){
				if(LRidx < 0 || LRidx > width*height) continue; //check boundary of pixel arr
				if(x_chk<0 || x_chk >= width || y_chk<0 || y_chk>=height) continue;//check boundary of img dimensions
				if(image[LRidx] == 0){ // mark boundary pixel
						*background = 0;
						*object = 0;
						*boundary = 1;
						return;
				}
				x_chk++; //increment x_chk for nxt pixel boundary check
		}
		//bottom 3 pixels
		int botidx = (y+1)*width+x-1; //starting boundary for top 3 pixel
		int botend = botidx+3; //boundary for bot 3 pixels, end
		x_chk = x-1; // coordinates for img boundary check
		y_chk = y+1;
		for(;botidx<botend;++botidx){
				//check for bounds
				if(botidx < 0 || botidx > width*height) continue; //check for bounds of pixel array
				if(x_chk<0 || x_chk >= width || y_chk<0 || y_chk>=height) continue; // check for bounds of image
				if(image[botidx] == 0){ // mark boundary pixel 
						*background = 0;
						*object = 0;
						*boundary = 1;
						return;
				}
				x_chk++; //increment x coordinate for pixel boundary check
		}
		//custom case for top and bottom pixel..
		if((y-1)*width+x >= 0 && (y-1)*width+x<width*height){ //checking bottom pixel boundary
				if(image[(y-1)*width+x] == 0){ //if boundary, mark it
						*background = 0;
						*object = 0;
						*boundary = 1;
						return;
				}
		}
		if((y+1)*width+x >= 0 && (y+1)*width+x<width*height){ //checking for top boundary
				if(image[(y+1)*width+x] == 0){ // if boundary, mark it
						*background = 0;
						*object = 0;
						*boundary = 1;
						return;
				}
		}

		//if not boundary, it's an object pixel
		*background = 0;
		*object = 1;
		*boundary = 0;

    return;
}

/* do not modify code below this line! */
void contour(unsigned char *inImage, unsigned char *outImage, int height, int width)
{
    int x, y;
    int object, background, boundary;

    for (y = 0; y < height; y++)
        for (x = 0; x < width; x++)
        {
            pixelType(inImage, height, width, x, y, &background, &object, &boundary);
            if (boundary == 1)
                *outImage = 2;
            else if (object == 1)
                *outImage = 1;
            else
                *outImage = 0;
            outImage++;
        }
}

void printImage(unsigned char *image, int height, int width)
{
    int x, y;

    for (y = 0; y < height; y++)
    { 
        for (x = 0; x < width; x++)
        {
            printf("%d", *image);
            image++;
        }
        printf("\n");
    }
}



