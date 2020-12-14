import std.stdio : stdin, writeln;
import std.string : startsWith;
import std.format : formattedRead, format;
import std.algorithm : sum, filter, map, each;
import std.range : iota, padLeft, lockstep;
import std.conv : to;
import std.array : array;

void main()
{
    ulong[ulong] ram;
    string mask;
    foreach(line; stdin.byLine)
    {
        if(line.startsWith("mask = "))
        {
            mask = line[7 .. $].idup;
        }
        else
        {
            ulong address, value;
            line.formattedRead!"mem[%u] = %u"(address, value);
            address.applyMask(mask).each!(address => ram[address] = value);
        }
    }
    ram.values.sum.writeln();
}

ulong[] applyMask(ulong address, string mask)
{
    return address.format!"%b".applyMask(mask).map!(address => address.to!ulong(2)).array;
}

unittest
{
    assert(42.applyMask("000000000000000000000000000000X1001X") == [26, 27, 58, 59]);
    assert(26.applyMask("00000000000000000000000000000000X0XX") == [16, 17, 18, 19, 24, 25, 26, 27]);
}

string[] applyMask(string address, string mask)
{
    string result;
    result.reserve(mask.length);
    foreach(m, a; lockstep(mask, address.padLeft('0', mask.length)))
    {
        switch(m)
        {
            case 'X': result ~= 'X'; break;
            case '1': result ~= '1'; break;
            default: result ~= a; break;
        }
    }
    return result.generateFloatingBits();
}

string[] generateFloatingBits(string address)
{
    ulong[] floatingIndexes = address.length.iota.filter!(i => address[i] == 'X').array;
    string[] result;
    foreach(number; 0 .. 2 ^^ floatingIndexes.length)
    {
        char[] current = address.dup;
        string bits = number.format!"%b".padLeft('0', floatingIndexes.length).to!string;
        foreach(j; 0 .. floatingIndexes.length)
        {
            current[floatingIndexes[j]] = bits[j];
        }
        result ~= current.idup;
    }
    return result;
}

unittest
{
    auto expected = [
        "000000000000000000000000000000010000",
        "000000000000000000000000000000010001",
        "000000000000000000000000000000010010",
        "000000000000000000000000000000010011",
        "000000000000000000000000000000011000",
        "000000000000000000000000000000011001",
        "000000000000000000000000000000011010",
        "000000000000000000000000000000011011"
    ];
    assert("00000000000000000000000000000001X0XX".generateFloatingBits() == expected);

    expected = [
        "000000000000000000000000000000011010",
        "000000000000000000000000000000011011",
        "000000000000000000000000000000111010",
        "000000000000000000000000000000111011"
    ];
    assert("000000000000000000000000000000X1101X".generateFloatingBits() == expected);
}
