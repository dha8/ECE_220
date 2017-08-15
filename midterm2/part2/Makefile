CC=gcc
CFLAGS=-g -Wall -std=gnu99

all: part2 

part2: main.o image.o
	$(CC) $(CFLAGS) main.o image.o -o part2

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

image.o: image.c
	$(CC) $(CFLAGS) -c image.c

clean:
	rm -f *.o part2 

