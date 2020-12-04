import std.stdio : stdin, writeln;
import std.ascii : isDigit;
import std.conv : to;
import std.format : formattedRead;
import std.algorithm : splitter, all, canFind;

void main()
{
    string[string] passport;
    int counter;
    foreach(line; stdin.byLine)
    {
        if(line.length == 0)
        {
            if(passport.isValid)
            {
                counter++;
            }
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
        if(field !in passport || !isFieldValid(field, passport[field]))
        {
            return false;
        }
    }
    return true;
}

bool isFieldValid(string field, string value)
{
    switch(field)
    {
        case "byr":
            return value.all!isDigit && value.to!int.between(1920, 2002);
        
        case "iyr":
            return value.all!isDigit && value.to!int.between(2010, 2020);
        
        case "eyr":
            return value.all!isDigit && value.to!int.between(2020, 2030);
        
        case "hgt":
            return value.validateHeight();
        
        case "hcl":
            return value.validateHairColor();
        
        case "ecl":
            return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].canFind(value);
        
        case "pid":
            return value.length == 9 && value.all!isDigit;
        
        case "cid":
            return true;

        default:
            return false;
    }
}

unittest
{
    assert(isFieldValid("byr", "2002"));
    assert(!isFieldValid("byr", "2003"));

    assert(isFieldValid("hgt", "60in"));
    assert(isFieldValid("hgt", "190cm"));
    assert(!isFieldValid("hgt", "190in"));
    assert(!isFieldValid("hgt", "190"));

    assert(isFieldValid("hcl", "#123abc"));
    assert(!isFieldValid("hcl", "#123abz"));
    assert(!isFieldValid("hcl", "123abc"));

    assert(isFieldValid("ecl", "brn"));
    assert(!isFieldValid("ecl", "wat"));

    assert(isFieldValid("pid", "000000001"));
    assert(!isFieldValid("pid", "0123456789"));
}

bool validateHeight(string height)
{
    int number;
    string unit;
    height.formattedRead!"%d%s"(number, unit);
    switch(unit)
    {
        case "cm":
            return number.between(150, 193);
        case "in":
            return number.between(59, 76);
        default:
            return false;
    }
}

bool validateHairColor(string color)
{
    return color.length == 7 && color[0] == '#' && color[1 .. $].all!(c => c.isDigit || c.between('a', 'f'));
}

bool between(T)(T value, T min, T max)
{
    return min <= value && value <= max;
}
