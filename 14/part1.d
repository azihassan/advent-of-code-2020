import std.stdio : stdin, writeln;
import std.string : startsWith;
import std.format : formattedRead, format;
import std.algorithm : sum;
import std.range : lockstep, padLeft;
import std.conv : to;

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
            ram[address] = value.applyMask(mask);
        }
    }
    ram.values.sum.writeln();
}

ulong applyMask(ulong value, string mask)
{
    return value.format!"%b".applyMask(mask).to!ulong(2);
}

unittest
{
    assert(11.applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == 73);
    assert(101.applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == 101);
    assert(0.applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == 64);
}

string applyMask(string value, string mask)
{
    string result;
    result.reserve(mask.length);
    foreach(m, v; lockstep(mask, value.padLeft('0', mask.length)))
    {
        if(m == 'X')
        {
            result ~= v;
        }
        else
        {
            result ~= m;
        }
    }
    return result;
}

unittest
{
    assert("000000000000000000000000000000001011".applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == "000000000000000000000000000001001001");
    assert("1011".applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == "000000000000000000000000000001001001");
    assert("000000000000000000000000000001100101".applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == "000000000000000000000000000001100101");
    assert("1100101".applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == "000000000000000000000000000001100101");
    assert("000000000000000000000000000000000000".applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == "000000000000000000000000000001000000");
    assert("0".applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == "000000000000000000000000000001000000");
}

