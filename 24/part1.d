import std.stdio : writeln, stdin;
import std.string : startsWith;

void main()
{
    Point[string] directions = [
        "e": Point(1, -1, 0),
        "se": Point(0, -1, 1),
        "sw": Point(-1, 0, 1),
        "w": Point(-1, 1, 0),
        "nw": Point(0, 1, -1),
        "ne": Point(1, 0, -1)
    ];

    Set!Point black;

    foreach(line; stdin.byLine)
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

    black.length.writeln();
}

struct Point
{
    int x;
    int y;
    int z;

    Point opBinary(string operator)(Point other)
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

struct Set(T)
{
    byte[0][T] set;
    alias set this;

    void opOpAssign(string operator)(T value) if(operator == "~")
    {
        set[value] = [];
    }
}
