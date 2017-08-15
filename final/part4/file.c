#include <stdio.h>
#include <stdlib.h>

#include "file.h"

/*return ptr to loaded file*/
file_data *read_file(char *filename)
{
    file_data * returnThing;
	char ** temp_records;
    FILE * f;
	int num_Records;

    /* scan to get num records */
	f = fopen(filename,"r");
	if(f == NULL) return NULL;
    char buf[64];

	/*scan first line for num of records*/
    fscanf(f, "%s\n", buf);
	num_Records = buf[0]-'0';

    /*allocate size of records*/
    temp_records = (char**)malloc(num_Records*sizeof(char)*64);

	/*read the rest of the file*/
	int i;
	for(i=0;i<num_Records;++i){
        fscanf(f, "%s\n", buf);
		temp_records[i] = buf;
    }
	fclose(f);

	/*allocate memory for overall array*/
	returnThing = (file_data*)malloc(sizeof(file_data));
    returnThing->records = temp_records;
	returnThing->number_of_records = num_Records;

    /*printf("reading success!\n");*/
	return returnThing;
}


int write_file(file_data *data, char *filename) 
{
    /* IMPLEMENT ME */
    FILE * f;
    f = fopen(filename,"w");
	if(f == NULL) return 0;
	int i;
	/*write the first line*/
    fputs(data->records[0],f);
	for(i=data->number_of_records-1;i>0;--i){
		fputs(data->records[i],f);
	}
	fclose(f);
   return 1;
}    

/* do not modify this function */
void free_memory(file_data *data)
{
    int i;

    if (data != NULL)
    {
        if (data->records != NULL)
        {
            for (i = 0; i < data->number_of_records; i++)
            {
                if (data->records[i] != NULL) free(data->records[i]);
            }
            free(data->records);
        }
        free(data);
    }
}

