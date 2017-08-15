#include <stdio.h>
#include <stdlib.h>

#include "file.h"

int main(int argc, char **argv)
{
    file_data *buffer = NULL;

    if (argc != 3)
    {
        printf("Usage: %s input_file outpit_file\n", argv[0]);
        return 0;
    }

    buffer = read_file(argv[1]);

    if (buffer == NULL)
    {
        printf("Failed to read file %s\n", argv[1]);
        return 0;
    }

    if (write_file(buffer, argv[2]) == 0)
    {
        printf("Failed to write file %s\n", argv[2]);
        return 0;
    }

    free_memory(buffer);

    return 0;
}

    
