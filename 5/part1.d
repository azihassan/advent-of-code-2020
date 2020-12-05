import std.stdio : writeln, stdin;
import std.algorithm : map, reduce, max;
import std.traits : isSomeString;

void main()
{
    stdin.byLine.map!findSeatId.reduce!max.writeln();
}

int findSeatId(S)(S specification) if(isSomeString!S)
{
    int[] row = [0, 127];
    int[] col = [0, 7];
    foreach(s; specification)
    {
        switch(s)
        {
            case 'B':
                row[0] += 1 + ((row[1] - row[0]) / 2);
                //writeln("B ", row);
            break;

            case 'F':
                row[1] -= 1 + ((row[1] - row[0]) / 2);
                //writeln("F ", row);
            break;

            case 'L':
                col[1] -= 1 + ((col[1] - col[0]) / 2);
                //writeln("L ", col);
            break;

            default:
                col[0] += 1 + ((col[1] - col[0]) / 2);
                //writeln("R ", col);
            break;
        }
    }
    //row.writeln();
    //col.writeln();
    return row[0] * 8 + col[0];
}

unittest
{
    assert("FBFBBFFRLR".findSeatId() == 357);
    assert("BFFFBBFRRR".findSeatId() == 567);
    assert("FFFBBBFRRR".findSeatId() == 119);
    assert("BBFFBBFRLL".findSeatId() == 820);
}
