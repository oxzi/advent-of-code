#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "taxicab.h"

int main(void) {
  Coordinate c, *cs;
  char input[] = INPUT_STRING, *token;
  int len, csSize, i, j;
  bool twice;

  c = COORDINATE_START;
  csSize = 0;
  cs = malloc(0);
  twice = false;

  for(token = strtok(input, ", "); token; token = strtok(NULL, ", ")) {
    cs = realloc(cs, ++csSize * sizeof(CoordinateElement));
    cs[csSize - 1] = copyCoordinate(c);

    sscanf(token + 1, "%d", &len);
    move(c, (token[0] == 'L') ? DIRECTION_TURN_LEFT : DIRECTION_TURN_RIGHT, 1); 

    for(i = 0; i < len - 1; i++) {
      cs = realloc(cs, ++csSize * sizeof(CoordinateElement));
      cs[csSize - 1] = copyCoordinate(c);

      move(c, DIRECTION_STRAIGHT, 1);

      for(j = 0; !twice && j < csSize - 1; j++)
        if(sameCoordinates(c, cs[j])) {
          printf("Part Two: Already visited (%d,%d) before‥ Distance are %d blocks.\n",
              c->x, c->y, distanceFromZero(c));
          twice = true;
        }
    }
 }

  printf("Part One: Easter Bunny HQ is %d blocks away.\n", distanceFromZero(c));
  
  deleteCoordinate(c);
  free(cs);

  return 0;
}
