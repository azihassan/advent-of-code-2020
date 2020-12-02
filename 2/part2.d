import std.stdio : writeln, stdin;
import std.format : formattedRead;

void main()
{
    int counter = 0;
    foreach(line; stdin.byLine)
    {
        int min, max;
        char letter;
        string password;
        line.formattedRead!"%d-%d %c: %s"(min, max, letter, password);
        if(password.isValid(min, max, letter))
        {
            counter++;
        }
    }
    counter.writeln();
}

bool isValid(string password, int min, int max, char c)
{
    return (password[min - 1] == c || password[max - 1] == c) && password[min - 1] != password[max - 1];
}

unittest
{
    assert("abcde".isValid(1, 3, 'a'));
    assert(!"cdefg".isValid(1, 3, 'b'));
    assert(!"ccccccccc".isValid(2, 9, 'c'));
}
