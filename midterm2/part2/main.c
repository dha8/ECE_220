#include <stdio.h>
#include "image.h"


int main(int argc, char **argv)
{
    /* input image array */
    unsigned char inImage[8][16] = { { 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0 },
                                     { 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0 },
                                     { 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0 },
                                     { 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1 },
                                     { 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1 },
                                     { 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1 },
                                     { 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1 },
                                     { 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1 } };

    /* output image array */
    unsigned char outImage[8][16];

    printf("\nInput image:\n\n");
    printImage((unsigned char *)inImage, 8, 16);

    /* call contour function */
    contour((unsigned char *)inImage, (unsigned char *)outImage, 8, 16);

    printf("\nOutput image:\n\n");
    printImage((unsigned char *)outImage, 8, 16);

    return 0;
}


