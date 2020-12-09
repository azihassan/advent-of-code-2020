import std.stdio : stdin, writeln;
import std.conv : to;
import std.algorithm : map, sum, min, max, reduce;
import std.array : array;

void main()
{
    long[] input = stdin.byLine.map!(to!long).array;
    input.findWeakness(731031916).writeln();
}

long findWeakness(long[] xmas, long invalid)
{
    foreach(i; 0 .. xmas.length)
    {
        foreach(j; i + 1 .. xmas.length)
        {
            if(xmas[i .. j].sum == invalid)
            {
                return xmas[i .. j].reduce!min + xmas[i .. j].reduce!max;
            }
        }
    }
    return -1;
}
