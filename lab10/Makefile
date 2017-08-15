CC=gcc
CFLAGS=-g -Wall -Werror -std=c99 -m32

all: permutation

permutation: main.o verify.o
	$(CC) $(CFLAGS) main.o verify.o -o permutation

main.o: main.c verify.h
	$(CC) $(CFLAGS) -c main.c

clean:
	rm -f main.o permutation
