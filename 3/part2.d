import std.stdio;

void main()
{
    char[][] grid;
    foreach(line; stdin.byLine)
    {
        grid ~= line.dup;
    }

    int[][] slopes = [
         [1, 1],
         [3, 1],
         [5, 1],
         [7, 1],
         [1, 2]
    ];
    ulong totalTrees = 1;
    foreach(slope; slopes)
    {
        totalTrees *= grid.countTrees(slope[0], slope[1]);
    }
    totalTrees.writeln();
}

ulong countTrees(char[][] grid, int right, int down)
{
    ulong x, y, trees;
    while(y < grid.length)
    {
        if(grid[y][x % grid[0].length] == '#')
        {
            trees++;
        }
        y += down;
        x += right;
    }
    return trees;
}
