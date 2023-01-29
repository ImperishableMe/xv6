#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    int p2c[2], c2p[2];
    char buf[30];
    char *msg;
    int n;

    if (pipe(p2c) < 0 || pipe(c2p) < 0)
    {
        printf("pipe failed");
        exit(1);
    }

    int pid = fork();

    if (pid == 0) { // child process
        close(p2c[1]);
        if ((n = read(p2c[0], buf, sizeof(buf))) < 0)
        {
            printf("Child read failed\n");
            exit(1);
        }
        printf("%d: received %s\n", getpid(), buf);
        msg = "pong";
        if (write(c2p[1], msg, sizeof(msg)) < 0) {
            printf("Child write failed\n");
            exit(1);
        }
        close(c2p[1]);
        exit(0);
    }

    close(c2p[1]);
    msg = "ping";
    if (write(p2c[1], msg, sizeof(msg)) < 0) {
        printf("Par write failed");
        exit(1);
    }
    close(p2c[1]);

    if ((n = read(c2p[0], buf, sizeof(buf))) < 0) {
        printf("Par read failed");
        exit(1);
    }
    printf("%d: received %s\n", getpid(), buf);

    exit(0);
}