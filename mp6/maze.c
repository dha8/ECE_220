#include <stdio.h>
#include <stdbool.h> // for using bools
#include "maze.h"

/*
 * findStart -- finds the x and y location of the start of the  maze
 * INPUTS:      maze -- 2D char array that holds the contents of the maze
 *              width -- width of the maze
 *              height -- height of the maze
 *              x -- pointer to where x location should be stored
 *              y -- pointer to where y location should be stored
 * OUTPUTS: x and y will hold the values of the start
 * RETURN: none
 * SIDE EFFECTS: none
 */ 
void findStart(char ** maze, int width, int height, int * x, int * y)
{
    int row, col;
    for(row=0;row<height;++row){
        for(col=0;col<width;++col){
            if(maze[row][col] == 'S'){
                *x = col;
                *y = row;
                return;
            }
        }
    }
    //no start found
    *x = *y = -1;
    return;
}

/*
 * printMaze -- prints out the maze in a human readable format (should look like examples)
 * INPUTS:      maze -- 2D char array that holds the contents of the maze 
 *              width -- width of the maze
 *              height -- height of the maze
 * OUTPUTS:     none
 * RETURN:      none
 * SIDE EFFECTS: prints the maze to the console
 */
void printMaze(char ** maze, int width, int height)
{
    int i=0;
    for(;i<width*height;++i){
        if(i%width==0)printf("\n");
        printf("%c",maze[i/width][i%width]);
    }
    printf("\n");
}

/*
 * solveMazeDFS -- recursively solves the maze using depth first search
 * INPUTS:         maze -- 2D char array that holds the contents of the maze
 *                 width -- the width of the maze
 *                 height -- the height of the maze
 *                 xPos -- the current x position within the maze
 *                 yPos -- the current y position within the maze
 * OUTPUTS:        updates maze with the solution path ('.') and visited nodes ('~')
 * RETURNS:        0 if the maze is unsolvable, 1 if it is solved
 * SIDE EFFECTS:   none
 */ 
int solveMazeDFS(char ** maze, int width, int height, int xPos, int yPos)
{
    findStart(maze, width, height, &xPos, &yPos);
    if(walk(maze, width, height, xPos, yPos)){
        maze[yPos][xPos]='S';
        return 1;
    }
    maze[yPos][xPos]='S';
    return 0;
}

/*  helper fxn for moving
    if valid space, place '.' and move to 4 directions. if false, mark
    the path visited.
*/
bool walk(char ** maze, int width, int height, int xPos, int yPos){

    //case 1: end
    if(maze[yPos][xPos] == 'E') return true;

    //case 2: out of bounds
    if(xPos<0 || xPos>=width || yPos<0 || yPos>=height) return false;

    //case 3: coming back: check if spot is walkable
    if(maze[yPos][xPos] != ' ' && maze[yPos][xPos] != 'S') return false;

    //walk R, D, L, U respectively
    maze[yPos][xPos] = '.'; // empty path! mark it and walk
    if(walk(maze,width,height,xPos-1, yPos)) return true;
    if(walk(maze,width,height,xPos+1, yPos)) return true;
    if(walk(maze,width,height,xPos, yPos+1)) return true;
    if(walk(maze,width,height,xPos, yPos-1)) return true;
    //at this point, we know the path was incorrect
    //we did mark the path w/ '.', but mark it '~' now
    maze[yPos][xPos] = '~';
    return false;
}

/*
 * checkMaze -- checks if a maze has a valid solution or not
 * INPUTS:      maze -- 2D char array that holds the contents of the maze
 *              width -- width of the maze
 *              height -- height of the maze
 *              x -- the starting x position in the maze
 *              y -- the starting y position in the maze
 * OUTPUTS:     none
 * RETURN:      1 if the maze has a valid solution, otherwise 0
 * SIDE EFFECTS: none
 */ 
int checkMaze(char ** maze, int width, int height, int x, int y)
{
    // follow path. if E is found on the path, return 1. else ret 0.
    
    //case 1: E is found
    if(maze[y][x] == 'E') return true;
    //case 2: out of bounds
    if(x<0 || x>=width || y<0 || y>=height) return false;
    //case 3: not on path
    if(maze[y][x]!='.' && maze[y][x]!='S') return false;
    //walking
    maze[y][x] = ' '; //mark visited to prevent going back and forth.
    if(checkMaze(maze,width,height,x+1,y)){ maze[y][x] = '.';return true;}
    if(checkMaze(maze,width,height,x-1,y)){ maze[y][x] = '.';return true;}
    if(checkMaze(maze,width,height,x,y+1)){ maze[y][x] = '.';return true;}
    if(checkMaze(maze,width,height,x,y-1)){ maze[y][x] = '.';return true;}
    maze[y][x] = '.'; //unmark the path coming back
    return false;
}

/*
 * solveMazeBFS -- solves the maze using a breadth first search algorithm
 * INPUTS:         maze -- A 2D array that contains the contents of the maze
 *                 width -- the width of the maze
 *                 height -- the height of the maze
 *                 xPos -- the starting x position within the maze
 *                 yPos -- the starting y position within the maze
 * OUTPUTS:        none
 * RETURNS:        0 if the maze is unsolvable, else 1
 * SIDE EFFECTS:   marks the cells within the maze as visited or part of the solution path
 */
int solveMazeBFS(char ** maze, int width, int height, int xPos, int yPos)
{
    return 0;
}

/*
 * enqueue -- enqueues an integer onto the given queue
 * INPUTS:    queue -- a pointer to the array that will hold the contents of the queue
 *            value -- the value to  enqueue
 *            head -- a pointer to a variable that contains the head index in the queue
 *            tail -- a pointer to a variable that contains the tail index in the queue
 *            maxSize -- the maximum size of the queue (size of the array)
 * OUTPUTS:   none
 * RETURNS:   none
 * SIDE EFFECTS: adds an item to the queue
 */ 
void enqueue(int * queue, int value, int * head, int * tail, int maxSize)
{
    if ((*tail - maxSize) == *head)
    {
        printf("Queue is full\n");
        return;
    }
    *tail = *tail + 1;
    queue[*tail % maxSize] = value;
}

/* dequeue -- dequeues an item from the given queue
 * INPUTS:    queue -- a pointer to the array that holds the contents of the queue
 *            head -- a pointer to a variable that contains the head index in the queue
 *            tail -- a pointer to a variable that contains the tail index in the queue
 *            maxSize -- the maximum size of the queue (size of the array)
 * OUTPUTS:   none
 * RETURNS:   the value dequeued from the queue
 * SIDE EFFECTS: removes an item from the queue
 */
int dequeue(int * queue, int * head, int * tail, int maxSize)
{
    if (*head == *tail)
    {
        printf("Queue is empty\n");
        return -1;
    }
    *head = *head + 1;
    return queue[*head % maxSize];
}

