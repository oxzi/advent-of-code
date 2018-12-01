#include "screen.h"

Screen::Screen(int x, int y) {
  this->x = x;
  this->y = y;

  data = new bool*[y];
  for(int i = 0; i < y; i++) {
    data[i] = new bool[x];
    for(int j = 0; j < x; j++)
      data[i][j] = false;
  }
}

Screen::~Screen() {
  for(int i = 0; i < y; i++)
    delete data[i];
  delete[] data;
}

void Screen::rect(int a, int b) {
  for(int i = 0; i < b && i < y; i++)
    for(int j = 0; j < a && j < x; j++)
      data[i][j] = true;
}

void Screen::rotateRow(int a, int b) {
  for(int i = 0; i < b; i++) {
    bool lst = data[a][x - 1];
    for(int j = x - 1; j > 0; j--)
      data[a][j] = data[a][j - 1];
    data[a][0] = lst;
  }
}

void Screen::rotateColumn(int a, int b) {
  for(int i = 0; i < b; i++) {
    bool btm = data[y - 1][a];
    for(int j = y - 1; j > 0; j--)
      data[j][a] = data[j - 1][a];
    data[0][a] = btm;
  }
}

char* Screen::toString() {
  char *str = new char[x * y];
  for(int i = 0, a = 0; i < y; i++) {
    for(int j = 0; j < x; j++)
      str[a++] =  data[i][j] ? '#' : '.';
    str[a++] = '\n';
  }
  return str;
}

int Screen::countLights() {
  int count = 0;
  for(int i = 0; i < y; i++)
    for(int j = 0; j < x; j++)
      count += (int) data[i][j];
  return count;
}
