#include <cstring>
#include <iostream>
using namespace std;
#include <fstream>
std::ifstream input("input");
#include "screen.h"

int main(void) {
  Screen s;

  for(std::string line; getline(input, line);) {
    string mode = line.substr(0, line.find(" "));
    string rest = line.substr(line.find(" ") + 1);

    if(mode.compare("rect") == 0) {
      size_t xPos = rest.find("x");
      int x = std::stoi(rest.substr(0, xPos));
      int y = std::stoi(rest.substr(xPos + 1));

      s.rect(x, y);
    } else if(mode.compare("rotate") == 0) {
      string rotMode = rest.substr(0, rest.find(" "));
      rest = rest.substr(rest.find(" ") + 1);

      int a = std::stoi(rest.substr(rest.find("=") + 1, rest.find(" ")));
      int b = std::stoi(rest.substr(rest.find("by") + 2));

      if(rotMode.compare("column") == 0)
        s.rotateColumn(a, b);
      else
        s.rotateRow(a, b);
    }
  }

  cout << "There are " << s.countLights() << " pixels glowing." << endl << endl;
  cout << s.toString() << endl;
}
