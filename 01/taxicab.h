#ifndef TAXICAB__
#define TAXICAB__

#include <stdlib.h>
#include <stdbool.h>

#define DIRECTION_TURN_LEFT  0
#define DIRECTION_TURN_RIGHT 1
#define DIRECTION_STRAIGHT   2

typedef enum {
  NORTH, EAST, SOUTH, WEST } Direction;

#define COORDINATE_START newCoordinate(0, 0, NORTH)
typedef struct Coordinate {
  int x, y;
  Direction direction;
} *Coordinate, CoordinateElement;


/* Creates a new Coordinate at (x,y) and a view into the given Direction.
 * x: x-coordinate
 * y: y-coordinate
 * direction: value from the Direction-enum
 * returns: pointer to a new Coordinate
 */
Coordinate newCoordinate(int x, int y, int direction);

/* Copy a given (pointer to a) Coordinate to a one.
 * old: Coordinate to be copied
 * returns: New (pointer to a) Coordinate
 */
Coordinate copyCoordinate(Coordinate old);

/* Deletes (frees) the given Coordinate.
 * c: Coordinate to be deleted.
 */
void deleteCoordinate(Coordinate c);

/* Calculates the new Direction from a given viewpoint and a direction.
 * The direction is DIRECTION_TURN_LEFT, DIRECTION_TURN_RIGHT or
 * DIRECTION_STRAIGHT for not turning around.
 * from: Viewpoint (Direction-enum)
 * direction: direction where to look next
 * returns: new direction (Direction-enum)
 */
Direction turn(Direction from, int direction);

/* Moves this coordinate to a new point based on the given direction and the
 * length (distance). The direction is DIRECTION_TURN_LEFT, DIRECTION_TURN_RIGHT
 * or DIRECTION_STRAIGHT.
 * coordinate: existing (pointer to a) Coordinate
 * direction: direction to go
 * length: amount of fields to go
 */
void move(Coordinate coordinate, int direction, int length);

/* Calculates the distance between two Coordinates
 * c1: Coordinate one
 * c2: Coordinate two
 * returns: distance in "blocks"
 */
int distanceBetween(Coordinate c1, Coordinate c2);

/* Calculates the distance between a Coordinate and the origin.
 * c: (pointer to a) Coordinate
 * returns: distance in "blocks"
 */
int distanceFromZero(Coordinate c);


/* Checks if those two Coordinate have the same coordinates. The direction
 * doesn't matter.
 * c1: First Coordinate
 * c2: Second Coordinate
 * return: Same coordinate? (bool)
 */
bool sameCoordinates(Coordinate c1, Coordinate c2);
#endif
