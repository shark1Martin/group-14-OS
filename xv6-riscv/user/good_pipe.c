#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"

int main(void)
{
    // p[0] is the read end, p[1] is the write end
    int p[2];   
    int pid;

    char *haiku = "The light of a candle\nfluttering in the wind\nthe first star of night.\n";

    // create the pipe using the pipe() system call
    if (pipe(p) < 0)
    {
        printf("pipe creation failed\n");
        exit(1);
    }

    // Fork a child process
    pid = fork();

    // if pid negative, fork failed
    if (pid < 0)
    {
        printf("fork failed\n");
        exit(1);
    }
    // PARENT: parent process has the pid of child
    if (pid > 0)
    {
        // parent writes, so close read end
        close(p[0]);

        // Write the haiku into the pipe, one byte at a time
        int i = 0;
        while (haiku[i] != '\0')
        {
            // write file descriptor, a char from haiku, reading max 1 char 
            write(p[1], &haiku[i], 1);
            i++;
        }

        // Close write rend
        close(p[1]);

        // pause parent, wait for the child to finish
        wait(0);
    }
    // CHILD: the pid is 0, which is child
    else
    {
        // child reads, close the write end
        close(p[1]);

        // Read from the pipe one byte at a time and print each character
        char ch;
        while (read(p[0], &ch, 1) > 0)
        {
            printf("%c", ch);
        }

        // close the read end
        close(p[0]);
    }

    exit(0);
}