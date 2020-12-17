import std.stdio : writeln, write, stdin;
import std.algorithm : map, count;
import std.array : array;
import std.conv : to;

void main()
{
    bool[Point] space;
    bool[][] slice;
    foreach(line; stdin.byLine)
    {
        slice ~= line.map!(cell => cell == '#').array;
    }
    foreach(y; 0 .. slice.length)
    {
        foreach(x; 0 .. slice[y].length)
        {
            space[Point(x.to!int, y.to!int)] = slice[y][x];
        }
    }

    foreach(cycle; 0 .. 6)
    {
        space = space.nextCycle();
    }

    space.countActiveCubes().writeln();
}

struct Point
{
    int x;
    int y;
    int z;

    Point[] neighbors()
    {
        Point[] neighbors;
        foreach(_z; z - 1 .. z + 2)
        {
            foreach(_y; y - 1 .. y + 2)
            {
                foreach(_x; x - 1 .. x + 2)
                {
                    if(x == _x && y == _y && z == _z)
                    {
                        continue;
                    }
                    neighbors ~= Point(_x, _y, _z);
                }
            }
        }
        return neighbors;
    }

    ulong countActiveNeighbors(bool[Point] space)
    {
        return neighbors.count!(neighbor => neighbor in space ? space[neighbor] : false);
    }
}

bool[Point] nextCycle(bool[Point] space)
{
    bool[Point] next;
    foreach(cube, active; space)
    {
        auto neighbors = cube.neighbors();
        foreach(neighbor; neighbors)
        {
            if(neighbor !in space)
            {
                space[neighbor] = false;
            }
        }
    }
    foreach(cube, active; space)
    {
        ulong activeNeighbors = cube.countActiveNeighbors(space);
        if(active)
        {
            if(activeNeighbors == 2 || activeNeighbors == 3)
            {
                next[cube] = true;
            }
            else
            {
                next[cube] = false;
            }
        }
        else
        {
            if(activeNeighbors == 3)
            {
                next[cube] = true;
            }
            else
            {
                next[cube] = false;
            }
        }
    }
    return next;
}

ulong countActiveCubes(bool[Point] space)
{
    return space.byValue.count(true);
}
