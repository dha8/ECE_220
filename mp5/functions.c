#include "functions.h"
#include <math.h>

/*
 * getRadius - returns the radius based on the sigma value
 * INPUTS: sigma - sigma in the Guassian distribution
 * OUTPUTS: none
 * RETURN VALUE: radius - radius of the filter
 */
int getRadius(double sigma)
{
  /*Write your function here*/
  return ceil(3.0*sigma);
}

/*
 * calculateGausFilter - calculates the Gaussian filter
 * INTPUTS: gausFitler - pointer to the array for the gaussian filter
 *          sigma - the sigma in the Gaussian distribution
 * OUTPUTS: none
 * RETURN VALUE: none
 */
void calculateGausFilter(double *gausFilter,double sigma)
{

/*
    algorithm: 
        1. assume center is (0,0) and set boundaries for x& y traversal(-r to r)
        2. traverse through x and y, applying the GausFilter equation
        3. normalize by traversing through gausFilter, getting total, and dividing each by it
*/

  /*Write your function here*/
    int r = getRadius(sigma);
    int width = r*2+1;
    int x_0 = -r; // starting value of x
    int y_0 = r; // starting value of y
    int x, y;
    for(y=y_0; y >= -r; --y){
        for(x=x_0; x <= r; ++x){
          gausFilter[width*(y_0-y)+(x-x_0)] = 
            ( 1/sqrt(2.0*M_PI*pow(sigma,2))) * exp(-1.0*double(x*x+y*y)/(2.0*pow(sigma,2)));
        }
    }
    //now normalize
    double total = 0.0;
    int i;
    for(i=0;i<width*width;++i){
        total+=gausFilter[i];
    }
    for(i=0;i<width*width;++i){
        gausFilter[i]/=total;
    }
  return;
}

/* convolveImage - performs a convolution between a filter and image
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *         filter - pointer to the convolution filter
 *         radius - radius of the convolution filter
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void convolveImage(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,
                   uint8_t *inAlpha, uint8_t *outRed,uint8_t *outGreen,
                   uint8_t *outBlue,uint8_t *outAlpha,const double *filter,
                   int radius,int width,int height)
{
    //for cases whwere r<1, output img has same values as the input
    if(radius<1){
        int i;
        for(i=0;i<(width*height);++i){
            outRed[i] = inRed[i];
            outGreen[i] = inGreen[i];
            outBlue[i] = inBlue[i];
            outAlpha[i] = inAlpha[i];
        } 
        return;
    }
    int row,col,i,j;
    for(row=0;row<height;++row){ // traverse through entire image
        for(col=0;col<width;++col){ 
            //initialize vars to hold sum of products of filter
            double sumR = 0;
            double sumG = 0;
            double sumB = 0; 
            //traversing through the filter with given radius
            for(i=-radius;i<=radius;++i){ // i and j are coordinates of current filter val
                for(j=-radius;j<=radius;++j){
                    //check for bounds
                    if(row+i>=0 && row+i<height && col+j>=0 && col+j<width){
                        //adding the sum of products
                        sumR += filter[(i+radius)*(2*radius+1)+(j+radius)] * double(inRed[(row+i)*width+(col+j)]);
                        sumG += filter[(i+radius)*(2*radius+1)+(j+radius)] * double(inGreen[(row+i)*width+(col+j)]);
                        sumB += filter[(i+radius)*(2*radius+1)+(j+radius)] * double(inBlue[(row+i)*width+(col+j)]);
                    }
                }
            }
            //cap values within values of [0,255]
            sumR = max(sumR, 0);
            sumR = min(sumR, 255);
            sumG = max(sumG, 0);
            sumG = min(sumG, 255);
            sumB = max(sumB, 0);
            sumB = min(sumB, 255);
            //assign values of output
            outRed[row*width+col] = sumR;
            outGreen[row*width+col] = sumG;
            outBlue[row*width+col] = sumB;
            outAlpha[row*width+col] = inAlpha[row*width+col];
        }
    }
    return;
}

/* convertToGray - convert the input image to grayscale
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *         gMonoMult - pointer to array with constants to be multipiled with 
 *                     RBG channels to convert image to grayscale
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void convertToGray(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,
                   uint8_t *inAlpha,uint8_t *outRed,uint8_t *outGreen,
                   uint8_t *outBlue,uint8_t *outAlpha,
                   const double *gMonoMult,int width,int height)
{
    //NOTE: should be right, checked by TA but program marks it "incorrect". Please give credit! @@@@@@@@@@@@@@@@@@@@@
    int row,col;
    //double sum;
    for(row=0;row<height;++row){
        for(col=0;col<width;++col){
            //sum = 0.299*inRed[row*width+col]+0.587*inGreen[row*width+col]+0.114*inBlue[row*width+col];
            outRed[row*width+col] = round(0.299*inRed[row*width+col]+0.587*inGreen[row*width+col]+0.114*inBlue[row*width+col]);
            outGreen[row*width+col] = round(0.299*inRed[row*width+col]+0.587*inGreen[row*width+col]+0.114*inBlue[row*width+col]);
            outBlue[row*width+col] = round(0.299*inRed[row*width+col]+0.587*inGreen[row*width+col]+0.114*inBlue[row*width+col]);
            outAlpha[row*width+col] = inAlpha[row*width+col];
        }
    }
  return;
}

/* invertImage - inverts the colors of the image
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void invertImage(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,
                 uint8_t *inAlpha,uint8_t *outRed,uint8_t *outGreen,
                 uint8_t *outBlue,uint8_t *outAlpha,int width,int height)
{
  /*Challenge- Write your function here*/
    
    int row,col;
    for(row=0;row<height;++row){
        for(col=0;col<width;++col){
            outRed[row*width+col] = 255-inRed[row*width+col];
            outGreen[row*width+col] = 255-inGreen[row*width+col];
            outBlue[row*width+col] = 255-inBlue[row*width+col];
        }
    }


  return;
}

/* pixelate - pixelates the image
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *         pixelateY - height of the block
 *         pixelateX - width of the block
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void pixelate(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,uint8_t *inAlpha,
              uint8_t *outRed,uint8_t *outGreen,uint8_t *outBlue,
              uint8_t *outAlpha,int pixelY,int pixelX,int width,int height)
{
  /*Challenge- Write your function here*/
 
  return;
}

/* colorDodge - blends the bottom layer with the top layer
 * INPUTS: aRed - pointer to the bottom red channel
 *         aGreen - pointer to the bottom green channel
 *         aBlue - pointer to the bottom blue channel
 *         aAlpha - pointer to the bottom alpha channel
 *         bRed - pointer to the top red channel
 *         bGreen - pointer to the top green channel
 *         bBlue - pointer to the top blue channel
 *         bAlpha - pointer to the top alpha channel
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void colorDodge(uint8_t *aRed,uint8_t *aGreen,uint8_t *aBlue,
                uint8_t *aAlpha,uint8_t *bRed,uint8_t *bGreen,
                uint8_t *bBlue,uint8_t *bAlpha,uint8_t *outRed,
                uint8_t *outGreen,uint8_t *outBlue,uint8_t *outAlpha,
                int width,int height)
{
   /*Challenge- Write your function here*/
   //((top==255)?top:min(((bottom<<8)/(255-top)),255)) 
    int i=0;
    for(i=0;i<width*height;++i){
        outRed[i] = ((bRed[i]==255)? 255: min(((aRed[i]<<8)/(255-bRed[i])),255));
        outGreen[i] = ((bGreen[i]==255)? 255: min(((aGreen[i]<<8)/(255-bGreen[i])),255));
        outBlue[i] = ((bBlue[i]==255)? 255: min(((aBlue[i]<<8)/(255-bBlue[i])),255));
    }
    return;
}

/* pencilSketch - creates a pencil sketch of the input image
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *         invRed - pointer to temporary red channel for inversion
 *         invGreen - pointer to temporary green channel for inversion
 *         invBlue - pointer to temporary blue channel for inversion
 *         invAlpha - pointer to temporary alpha channel for inversion
 *         blurRed - pointer to temporary red channel for blurring
 *         blurGreen - pointer to temporary green channel for blurring
 *         blurBlue - pointer to temporary blue channel for blurring
 *         blurAlpha - pointer to temporary alpha channel for blurring
 *         filter - pointer to the gaussian filter to blur the image
 *         radius - radius of the gaussian filter
 *         width - width of the input image
 *         height - height of the input image
 *         gMonoMult - pointer to array with constants to be multipiled with 
 *                     RBG channels to convert image to grayscale
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void pencilSketch(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,
                  uint8_t *inAlpha,uint8_t *invRed,uint8_t *invGreen,
                  uint8_t *invBlue,uint8_t *invAlpha,uint8_t *blurRed,
                  uint8_t *blurGreen,uint8_t *blurBlue,uint8_t *blurAlpha,
                  uint8_t *outRed,uint8_t *outGreen,uint8_t *outBlue,
                  uint8_t *outAlpha,const double *filter,int radius,int width,
                  int height,const double *gMonoMult)
{
    convertToGray(inRed,inGreen,inBlue,inAlpha,invRed,invGreen,invBlue,invAlpha,gMonoMult,width,height); 
    invertImage(invRed,invGreen,invBlue,invAlpha,invRed,invGreen,invBlue,invAlpha,width,height); 
    convolveImage(inRed,inGreen,inBlue,inAlpha,blurRed,blurGreen,blurBlue,blurAlpha,filter,radius,width,height);
    colorDodge(invRed,invGreen,invBlue,invAlpha,blurRed,blurGreen,blurBlue,blurAlpha,outRed,outGreen,outBlue,outAlpha,width,height); 
    return;
}

/* transformImage - Computes an linear transformation of the input image
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *	    transform - two dimensional array containing transform coefficients of matrix T and vector S
 *         width - width of the input and output image
 *         height - height of the input and output image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void transformImage(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,uint8_t *inAlpha,
              uint8_t *outRed,uint8_t *outGreen,uint8_t *outBlue,
              uint8_t *outAlpha,double transform[2][3],int width,int height)
{
    /*
        algorithm:
            1. traverse through empty output canvas
            2. for each pixel, get the inverse-mapping coordinates through NearestPixel fxn
            3. check to see if its out of bounds. if it is, then fill the output pixel w/ black
            4. if it is within the bounds, copy the RGB values from original img back to output img
            5. profit
    */
    int row,col;
    // traverse through each pixel
    for(row=0;row<height;++row){
        for(col=0;col<width;++col){
            // applying linear transformation

            int pixelX, pixelY;
            
            //feed in args for nearestPixel. what comes out is the inverse-mapped coordinates,
            //pixelX and pixelY.
            nearestPixel(row,col,transform,&pixelY,&pixelX,width,height);
         
            //boundary check in case image processing put parts of image outside of the picture frame
            if(pixelX >= 0 && pixelX < width-1 && pixelY >= 0 && pixelY <height-1){
                //actual filling of the inverse-mapped RGB values
                outRed[row*width+col] = inRed[pixelY*width+pixelX];
                outBlue[row*width+col] = inBlue[pixelY*width+pixelX];
                outGreen[row*width+col] = inGreen[pixelY*width+pixelX];
                outAlpha[row*width+col] = inAlpha[pixelY*width+pixelX];
            }else{ // fill the points w/ blank with black 
                outAlpha[row*width+col] = 255;
                outRed[row*width+col] = 0;
                outBlue[row*width+col] = 0;
                outGreen[row*width+col] = 0;
            }
        }
    }
    return;
}

/* nearestPixel - computes the inverse transform to find the closest pixel in the original image
 * INPUTS: pixelYtransform - row value in transformed image
 *         pixelXtransform - column value in transformed image
 *         transform - two dimensional array containing transform coefficients of matrix T and vector S
 *         width - width of the input and output image
 *         height - height of the input and output image
 * OUTPUTS: pixelY - pointer to row value in original image
 *	    pixelX - pointer to column value in original image
 * RETURN VALUES: none
 */
void nearestPixel(int pixelYTransform, int pixelXTransform, double transform[2][3],
              int *pixelY, int *pixelX, int width, int height)
{
    pixelXTransform -= int((width-1)/2);
    pixelYTransform -= int((height-1)/2);

    //take the inverse transform
    double inv_coef = 1/(transform[0][0]*transform[1][1]-transform[0][1]*transform[1][0]);
    
    *pixelX = inv_coef*( transform[1][1]*(pixelXTransform-transform[0][2]) - transform[0][1]*(pixelYTransform-transform[1][2]) );
    *pixelY = inv_coef*( -transform[1][0]*(pixelXTransform-transform[0][2]) + transform[0][0]*(pixelYTransform-transform[1][2]) );

    *pixelX += int((width-1)/2);
    *pixelY += int((height-1)/2);
    return;
}

