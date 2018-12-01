#ifndef SCREEN__
#define SCREEN__

class Screen {
  int x, y;
  bool **data;

  public:
    Screen(int x, int y);
    Screen() : Screen(50, 6) {}
    ~Screen();

    void rect(int a, int b);
    void rotateRow(int a, int b);
    void rotateColumn(int a, int b);

    char *toString();
    int countLights();
};

#endif
