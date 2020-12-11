import std.stdio : writeln, stdin;
import std.typecons : tuple;
import std.array : array;
import std.algorithm : map, count, sum;

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
                if(current.countOccupiedSeats(x, y) == 0)
                {
                    next[y][x] = '#';
                }
                break;

                case '#':
                if(current.countOccupiedSeats(x, y) >= 5)
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

ulong countOccupiedSeats(char[][] grid, ulong x, ulong y)
{
    auto offsets = [
        tuple(-1, -1),
        tuple(-1, 0),
        tuple(-1, 1),
        tuple(0, -1),
        tuple(0, 1),
        tuple(1, -1),
        tuple(1, 0),
        tuple(1, 1)
    ];

    ulong count = 0;
    foreach(offset; offsets)
    {
        auto current = tuple(x + offset[0], y + offset[1]);
        while(grid.withinBounds(current.expand))
        {
            if(grid[current[1]][current[0]] == 'L')
            {
                break;
            }
            if(grid[current[1]][current[0]] == '#')
            {
                count++;
                break;
            }
            current[0] += offset[0];
            current[1] += offset[1];
        }
    }
    return count;
}

bool withinBounds(char[][] grid, ulong x, ulong y)
{
    return 0 <= x && x < grid[0].length && 0 <= y && y < grid.length;
}

ulong occupiedCount(char[][] grid)
{
    return grid.map!(row => row.count('#')).sum;
}
