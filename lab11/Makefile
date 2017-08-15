CC=gcc
CFLAGS=-g -Wall -Werror -std=c99 -m32

all: records 

records: fileio.c 
	$(CC) $(CFLAGS) fileio.c -o records

clean:
	rm -f fileio.o records
