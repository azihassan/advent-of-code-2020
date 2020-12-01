#include <iostream>
#include <set>
#include <vector>

using namespace std;

int product_of_sum_of_three(int product, const vector<int>& entries, const set<int>& report)
{
    for(int i = 0; i < entries.size(); i++)
    {
        for(int j = i + 1; j < entries.size(); j++)
        {
            auto match = report.find(2020 - entries[i] - entries[j]);
            if(match != report.end())
            {
                return *match * entries[i] * entries[j];
            }
        }
    }
    return -1;
}

int main()
{
    set<int> report;
    vector<int> entries;
    int entry;
    while(cin >> entry)
    {
        report.insert(entry);
        entries.push_back(entry);
    }

    auto result = product_of_sum_of_three(2020, entries, report);
    if(result == -1)
    {
        cout << "No result" << endl;
    }
    else
    {
        cout << result << endl;
    }
}

