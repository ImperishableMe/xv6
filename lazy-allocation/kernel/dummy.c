#include <stdio.h>

char *board[9][9];
int cnt = 81;

int valid_solution()
{

    // 1 // valid solution
    // 0 // invalid solution

    // (0,0)
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            if (board[i][j] ==)
        }
    }

    // (0,3)
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            if (board[i + 0][j + 3] ==)
        }
    }
    // (3,0)
    // (x, y)
    // (l_x, l_y)
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            if (atoi(board[i + l_x][j + l_y]) == atoi(board[x][y]))
            {
            }
        }
    }
}

iDraw()
{
    if (valid_solution() == 0)
    {
        iText("Invalid Solution");
    }
    else
    {
        iText("Valid Solution");
    }
}