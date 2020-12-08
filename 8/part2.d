import std.stdio : stdin, writeln;
import std.format : formattedRead;
import std.range : enumerate;

void main()
{
    Instruction[] instructions;

    foreach(line; stdin.byLine)
    {
        instructions ~= Instruction(line);
    }

    foreach(i, ref instruction; instructions.enumerate())
    {
        string[string] swaps = [ "nop": "jmp", "jmp": "nop" ];
        if(instruction.opcode in swaps)
        {
            debug
            {
                writeln(i, " : Swapping ", instruction.opcode, " and ", swaps[instruction.opcode]);
            }
            instructions[i].opcode = swaps[instructions[i].opcode];
            auto cpu = runProgram(instructions);
            if(cpu.finished)
            {
                cpu.registers["a"].writeln();
                return;
            }
            instructions[i].opcode = swaps[instructions[i].opcode];
        }
    }
    writeln("No loops");
}

Cpu runProgram(Instruction[] instructions)
{
    auto cpu = Cpu();
    cpu.init(instructions);
    auto loop = cpu.findLoopAddress();
    return cpu;
}

int findLoopAddress(ref Cpu cpu)
{
    bool[int] visited;
    visited[cpu.pc] = true;
    while(!cpu.finished)
    {
        cpu.next();
        if(cpu.pc in visited)
        {
            return cpu.pc;
        }
        visited[cpu.pc] = true;
    }
    return -1;
}

struct Cpu
{
    Instruction[] code;
    int[string] registers;
    int pc;
    bool finished;

    void init(Instruction[] instructions)
    {
        registers["a"] = 0;
        code = instructions.dup;
    }

    void next()
    {
        if(pc >= code.length)
        {
            finished = true;
            return;
        }
        auto current = code[pc];
        debug
        {
            current.writeln();
            registers.writeln();
            pc.writeln();
            writeln();
        }
        switch(current.opcode)
        {
            case "acc":
                registers["a"] += current.value;
                pc++;
            break;

            case "jmp":
                pc += current.value;
            break;

            default:
                pc++;
            break;
        }
    }
}

struct Instruction
{
    string opcode;
    int value;

    this(char[] input)
    {
        input.formattedRead!"%s %d"(opcode, value);
    }
}
