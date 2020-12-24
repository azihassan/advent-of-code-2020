import std.stdio : writeln, stdin, File;
import std.string : startsWith;
import std.algorithm : count, map;

struct Set(T)
{
    byte[0][T] set;
    alias set this;

    void opOpAssign(string operator)(T value) if(operator == "~")
    {
        set[value] = [];
    }
}

Point[string] directions;

static this()
{
    directions = [
        "e": Point(1, -1, 0),
        "se": Point(0, -1, 1),
        "sw": Point(-1, 0, 1),
        "w": Point(-1, 1, 0),
        "nw": Point(0, 1, -1),
        "ne": Point(1, 0, -1)
    ];
}

void main()
{
    Set!Point black = stdin.findBlackTiles();

    foreach(i; 0 .. 100)
    {
        black = black.nextCycle();
    }
    black.length.writeln();
}

Set!Point nextCycle(Set!Point floor)
{
    Set!Point next;
    foreach(tile, _; floor)
    {
        ulong blackNeighborCount = tile.countBlackNeighbors(floor);
        if(!(blackNeighborCount == 0 || blackNeighborCount > 2))
        {
            next ~= tile;
        }
        foreach(neighbor; tile.neighbors)
        {
            blackNeighborCount = neighbor.countBlackNeighbors(floor);
            if(neighbor in floor)
            {
                if(!(blackNeighborCount == 0 || blackNeighborCount > 2))
                {
                    next ~= neighbor;
                }
            }
            else
            {
                if(blackNeighborCount == 2)
                {
                    next ~= neighbor;
                }
            }
        }
    }
    return next;
}


Set!Point findBlackTiles(File input)
{
    Set!Point black;
    foreach(line; input.byLine)
    {
        auto current = Point(0, 0, 0);
        int i;
        while(i < line.length)
        {
            if(line[i .. $].startsWith("e") || line[i .. $].startsWith("w"))
            {
                current += directions[line[i .. i + 1]];
                i++;
            }
            else
            {
                current += directions[line[i .. i + 2]];
                i += 2;
            }
        }
        if(current in black)
        {
            black.remove(current);
        }
        else
        {
            black ~= current;
        }
    }
    return black;
}

struct Point
{
    int x;
    int y;
    int z;

    auto neighbors() const
    {
        return directions.byValue.map!(d => d + this);
    }

    ulong countBlackNeighbors(Set!Point floor) const
    {
        return neighbors.count!(n => (n in floor) != null);
    }

    Point opBinary(string operator)(Point other) const
    {
        static if(operator == "+")
        {
            return Point(x + other.x, y + other.y, z + other.z);
        }
        else static if(operator == "-")
        {
            return Point(x - other.x, y - other.y, z - other.z);
        }
        else static assert(0, "Operator "~op~" not implemented");
    }

    void opOpAssign(string operator)(Point other)
    {
        this = other.opBinary!operator(this);
    }
}
