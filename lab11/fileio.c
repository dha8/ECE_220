#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define NofS 3

#define EQUAL 0
#define NOTEQUAL 1

struct studentStruct
{
    char name[100];
    int ID;
    char grade;
};
typedef struct studentStruct Student;

void enterRecords(Student s[], int n);
void writeRecordsToFile(Student s[], int n, char *fname);

/* implement me */
void readRecordsFromFile(Student s[], int n, char *fname);

/* implement me */
int compareRecords(Student s1[], Student s2[], int n);


int main()
{
    Student S1[NofS];
    Student S2[NofS];

    enterRecords(S1, NofS);
    writeRecordsToFile(S1, NofS, "ece220.dat");
    readRecordsFromFile(S2, NofS, "ece220.dat");

    if (compareRecords(S1, S2, NofS) == EQUAL)
        printf("Records are identical\n");
    else    
        printf("Records are different\n");

    return 0;
}

/*
    enterRecords enters n number of student records into student array s[].
    returns nothing. just prompts the user to enter student data n times.
*/
void enterRecords(Student s[], int n)
{
    int i;
    char temp[8]; // temporary buffer for flushing
    for (i = 0; i < n; i++)
    {
        printf("Enter student's name: "); // reads name from stdin, store@ s[i].name. max 99 chars
        fgets(s[i].name, 99, stdin);
        printf("Enter student's ID: "); // read ID# into s[i].ID
        scanf("%d", &(s[i].ID));
  
        printf("Enter student's grade: ");
        scanf("\n%c", &(s[i].grade)); // read grade into s[i].grade. also, by putting \n in front of %c, eliminates the need for flushing after ID input
        fgets(temp, 7, stdin); // reads extra string from stdin to temp, aka
                                // "flushing" to clear stream
    }
}

/*
    writeRecordsToFile opens up a output stream to write n student records
    contained in s[]. fname is the file path.
*/
void writeRecordsToFile(Student s[], int n, char *fname)
{
    FILE *f;
    int i;

    if ((f = fopen(fname, "w")) == NULL)  // open file @ fname. if DNE, return error msg
    {
        fprintf(stderr, "Unable to open file %s\n", fname);
        exit(1);
    }
    for (i = 0; i < n; i++) //in f,write each record in format of name,ID,grade (with delimiter of \n)
        fprintf(f, "%s%d\n%c\n", s[i].name, s[i].ID, s[i].grade);

    fclose(f);
}

/*
    readRecordsFromFile:
    read n records saved in file by writeRecordsToFile function.
    returns nothing, just does reading into the array s[].
*/
void readRecordsFromFile(Student s[], int n, char *fname)
{
    FILE *f;
    int i;
    if((f = fopen(fname,"r")) == NULL){
        printf("unable to open file for reading");
        return;
    }
    for(i=0;i<n;++i){
        fgets(s[i].name,99,f);
        fscanf(f, "%d\n%c\n",  &(s[i].ID), &(s[i].grade));
        //fscanf(f, "%s%d\n%c\n", s[i].name, &(s[i].ID), &(s[i].grade));
        //printf("%s\n%d\n%c\n",s[i].name, s[i].ID, s[i].grade);
    }
    fclose(f);
}


/*
    compareRecords compares the contents of s1[] and s2[] and 
    returns 0 if all elements are identical and otherwise 1.
    as specified in the directives above, 
    EQUAL == 0 and NOTEQUAL == 1
*/
int compareRecords(Student s1[], Student s2[], int n)
{
    for(int i=0;i<n;++i){ // must compare *(s1[i].name)(value), not the base addr of char array.
        if((strcmp(s1[i].name,s2[i].name)!=0) || (s1[i].ID != s2[i].ID) ||
            (s1[i].grade != s2[i].grade)) return NOTEQUAL;
    }
    return EQUAL;
}

