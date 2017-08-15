
#define MAX_STRING_LEN 64
#define MAX_LINES 32

typedef struct
{
    int number_of_records;
    char **records;
} file_data;

file_data *read_file(char *filename);
int write_file(file_data *data, char *filename);
void free_memory(file_data *data);

