import std.stdio : writeln, readln;
import std.string : strip;
import std.algorithm : map, splitter;
import std.range : enumerate;
import std.conv : to;
import std.array : array;

void main()
{
    readln.strip.splitter(",").map!(to!ulong).array.findNthSpokenNumber(2020).writeln();
}

ulong findNthSpokenNumber(ulong[] starting, int n)
{
    ulong[][ulong] spoken;
    ulong last;
    foreach(i, number; starting.enumerate)
    {
        spoken[number] ~= i;
        last = number;
    }

    foreach(round; starting.length .. n)
    {
        if(last in spoken && spoken[last].length > 1)
        {
            last = spoken[last][$ - 1] - spoken[last][$ - 2];
            spoken[last] ~= round;
        }
        else
        {
            spoken[0] ~= round;
            last = 0;
        }
    }

    return last;
}

unittest
{
    assert([0, 3, 6].findNthSpokenNumber(10) == 0);
    assert([1, 3, 2].findNthSpokenNumber(2020) == 1);
    assert([2, 1, 3].findNthSpokenNumber(2020) == 10);
    assert([1, 2, 3].findNthSpokenNumber(2020) == 27);
    assert([2, 3, 1].findNthSpokenNumber(2020) == 78);
    assert([3, 2, 1].findNthSpokenNumber(2020) == 438);
    assert([3, 1, 2].findNthSpokenNumber(2020) == 1836);
    assert([10, 16, 6, 0, 1, 17].findNthSpokenNumber(2020) == 412);
}
