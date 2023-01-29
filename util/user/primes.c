#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void make_pipe(int* p) {
    if (pipe(p) < 0) {
        printf("pipe failed");
        exit(1);
    }
}
int* filter(int *, int);
int* generate();

int* generate() {
    int *p = (int *)malloc(2*sizeof(int));
    make_pipe(p);
    int pid = fork();
    if (!pid) {
        close(p[0]);
        int x;
        for (x = 2; x <= 35; x++) {
            if (write(p[1], &x, sizeof(int)) < 0) {
                printf("%d Par write failed", x);
                exit(1);
            }
        }
        close(p[1]);
        exit(0);
    }
    close(p[1]);
    return p;
}

int* filter (int *in, int pr) {
    int *out = (int *)malloc(2*sizeof(int));
    make_pipe(out);
    int pid = fork();
    if (!pid) {
        close(out[0]);
        int a;
        while (read(in[0], &a, sizeof(int))) {
            if (a % pr != 0) {
                write(out[1], &a, sizeof(int));
            }
        }
        close(in[0]);
        close(out[1]);
        exit(0);
    }
    close(in[0]);
    close(out[1]);
    return out;
}


int main(int argc, char *argv[]) {
    int *in;
    int pr;
    int wait_cnt = 0;

    in = generate();
    wait_cnt++;
    while (read(in[0], &pr, sizeof(int))){
        printf("prime %d\n", pr);
        in = filter(in, pr);
        wait_cnt++;
    }
    exit(0);
    while (wait_cnt--) {
        wait((int*)0);
    }
    exit(0);
}
