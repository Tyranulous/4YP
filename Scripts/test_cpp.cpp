#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
/*
 * It will iterate through all the lines in file and
 * put them in given vector
 */


int main()
{
    std::cout<<"test"<<std::endl;
    std::vector<std::vector<float>> float_array;
    std::vector<std::string> num;
    std::vector<float> pusher;
    std::ifstream file("C:/Users/joshu/OneDrive/Documents/Work/4YP/Scripts/test.dat");
    // Check if object is valid
    if (!file.is_open())
    {
        std::cout<<"error reading file"<<std::endl;
        return 1;
    }
    std::string line;
    int linenum = 1;
    while (std::getline(file,line)) 
    {
        if (line.size()<2){
            std::cout<<"string too small"<<std::endl;
        }
        else
        {
            line = line.substr(2,line.size() -2);
            std::stringstream ss(line);
            float val;
            //for (int ifor; ss >> ifor;)
            //{
            //    if 
            //    val = std::stof();
            //    pusher.push_back(val);
            //}
            //float_array.push_back(pusher);
            while (ss.good())
            {
                std::string substring;
                std::getline(ss,substring,',');
                val = std::stof(substring);
                pusher.push_back(val);
            }
            float_array.push_back(pusher);
        }
    }
    file.close();
    return 0;
}