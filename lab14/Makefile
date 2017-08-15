CC=gcc
CFLAGS= -g -Wall #-Werror -Wextra

lab14: binarytree.o pgm.o
	$(CC) $(CFLAGS) binarytree.o pgm.o -o lab14

binarytree.o: binarytree.c
	$(CC) $(CFLAGS) -c binarytree.c

pgm.o: pgm.c
	$(CC) $(CFLAGS) -c pgm.c

clean:
	rm -f *.o lab14
