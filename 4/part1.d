import std.stdio : writeln, stdin;
import std.format : formattedRead;
import std.algorithm : splitter;

void main()
{
    string[string] passport;
    int counter;
    foreach(line; stdin.byLine)
    {
        if(line.length == 0)
        {
            counter += passport.isValid();
            passport = string[string].init;
        }
        else
        {
            foreach(pair; line.splitter(" "))
            {
                string key, value;
                pair.formattedRead!"%s:%s"(key, value);
                passport[key] = value;
            }
        }
    }
    counter += passport.isValid();
    counter.writeln();
}

bool isValid(string[string] passport)
{
    string[] fields = [
        "byr",
        "iyr",
        "eyr",
        "hgt",
        "hcl",
        "ecl",
        "pid"
    ];
    foreach(field; fields)
    {
        if(field !in passport)
        {
            return false;
        }
    }
    return true;
}
