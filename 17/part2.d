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
            space[Point(x.to!int, y.to!int, 0, 0)] = slice[y][x];
        }
    }

    foreach(cycle; 0 .. 6)
    {
        cycle.writeln();
        space = space.nextCycle();
    }

    space.countActiveCubes().writeln();
}

struct Point
{
    int x;
    int y;
    int z;
    int w;
}

ulong countActiveNeighbors(Point p, bool[Point] space)
{
    int count;
    foreach(_w; p.w - 1 .. p.w + 2)
    {
        foreach(_z; p.z - 1 .. p.z + 2)
        {
            foreach(_y; p.y - 1 .. p.y + 2)
            {
                foreach(_x; p.x - 1 .. p.x + 2)
                {
                    if(p.x != _x || p.y != _y || p.z != _z || p.w != _w)
                    {
                        count += Point(_x, _y, _z, _w) in space && space[Point(_x, _y, _z, _w)];
                        if(count > 3)
                        {
                            return count;
                        }
                    }
                }
            }
        }
    }
    return count;
}

bool[Point] nextCycle(bool[Point] space)
{
    bool[Point] next;
    foreach(cube, active; space)
    {
        foreach(_w; cube.w - 1 .. cube.w + 2)
        {
            foreach(_z; cube.z - 1 .. cube.z + 2)
            {
                foreach(_y; cube.y - 1 .. cube.y + 2)
                {
                    foreach(_x; cube.x - 1 .. cube.x + 2)
                    {
                        if(cube.x != _x || cube.y != _y || cube.z != _z || cube.w != _w)
                        {
                            auto neighbor = Point(_x, _y, _z, _w);
                            if(neighbor !in space)
                            {
                                space[neighbor] = false;
                            }
                        }
                    }
                }
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
