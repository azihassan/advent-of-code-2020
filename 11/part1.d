import std.stdio : stdin, writeln;
import std.algorithm : map, count, sum, filter;
import std.range : only;
import std.typecons : tuple;
import std.array : array;

void main()
{
    char[][] input = stdin.byLine.map!dup.array;

    while(true)
    {
        auto next = input.nextGen();
        if(next == input)
        {
            next.occupiedCount.writeln();
            break;
        }
        input = next.map!dup.array;
    }
}

char[][] nextGen(char[][] current)
{
    char[][] next = current.map!dup.array;

    foreach(y; 0 .. current.length)
    {
        foreach(x; 0 .. current[0].length)
        {
            switch(current[y][x])
            {
                case 'L':
                if(current.getNeighbors(x, y).count('#') == 0)
                {
                    next[y][x] = '#';
                }
                break;

                case '#':
                if(current.getNeighbors(x, y).count('#') >= 4)
                {
                    next[y][x] = 'L';
                }
                break;

                default:
                    next[y][x] = current[y][x];
                break;
            }
        }
    }
    return next;
}

auto getNeighbors(char[][] grid, ulong x, ulong y)
{
    return only(
        tuple(-1, -1),
        tuple(-1, 0),
        tuple(-1, 1),
        tuple(0, -1),
        tuple(0, 1),
        tuple(1, -1),
        tuple(1, 0),
        tuple(1, 1)
    )
    .map!(pair => tuple(x + pair[0], y + pair[1]))
    .filter!(pair => grid.withinBounds(pair[0], pair[1]))
    .map!(pair => grid[pair[1]][pair[0]]);
}

bool withinBounds(char[][] grid, ulong x, ulong y)
{
    return 0 <= x && x < grid[0].length && 0 <= y && y < grid.length;
}

ulong occupiedCount(char[][] grid)
{
    return grid.map!(row => row.count('#')).sum;
}
