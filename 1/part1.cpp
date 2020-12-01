#include <iostream>
#include <set>

using namespace std;

int main()
{
    set<int> report;
    int entry;
    while(cin >> entry)
    {
        report.insert(entry);
    }

    for(int entry: report)
    {
        auto match = report.find(2020 - entry);
        if(match != report.end())
        {
            cout << *match * entry << endl;
            break;
        }

        match = report.find(entry - 2020);
        if(match != report.end())
        {
            cout << *match * entry << endl;
            break;
        }
    }
}
