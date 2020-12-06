import std.stdio : writeln, stdin;
import std.algorithm : splitter, map, count;
import std.array : join;

void main()
{
    auto input = stdin.byLine.join("\n").splitter("\n\n").map!splitter;
    ulong sum;
    foreach(group; input)
    {
        int[dchar] counter;
        int length;
        foreach(answers; group)
        {
            length++;
            foreach(answer; answers)
            {
                counter[answer]++;
            }
        }
        sum += counter.values.count(length);
    }
    sum.writeln();
}
