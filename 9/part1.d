import std.stdio : stdin, writeln;
import std.conv : to;
import std.algorithm : map;
import std.array : array;
import std.container : RedBlackTree, redBlackTree;

void main()
{
    long[] input = stdin.byLine.map!(to!long).array;
    input.findInvalidNumber().writeln();
}

long findInvalidNumber(long[] xmas)
{
    foreach(i; 25 .. xmas.length)
    {
        auto preamble = redBlackTree(xmas[i - 25 .. i]);
        if(preamble.findSumOfTwo(xmas[i]) == -1)
        {
            return xmas[i];
        }
    }
    return -1;
}

long findSumOfTwo(RedBlackTree!long input, long a)
{
    foreach(b; input)
    {
        if(a - b in input)
        {
            return a - b;
        }
    }
    return -1;
}
