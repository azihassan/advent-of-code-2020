import std.stdio : writeln, stdin;
import std.algorithm : splitter;

void main()
{
    bool[dchar] counter;
    int sum;
    foreach(line; stdin.byLine)
    {
        if(line.length == 0)
        {
            sum += counter.length;
            counter.clear();
        }
        else
        {
            foreach(answers; line.splitter)
            {
                foreach(answer; answers)
                {
                    counter[answer] = true;
                }
            }
        }
    }
    sum += counter.length;
    sum.writeln();
}
