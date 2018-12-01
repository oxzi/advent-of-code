#include "taxicab.h"

Coordinate newCoordinate(int x, int y, int direction) {
  Coordinate c;

  if(!(c = malloc(sizeof(CoordinateElement))))
    return NULL;

  c->x = x;
  c->y = y;
  c->direction = direction;
  return c;
}

Coordinate copyCoordinate(Coordinate old) {
  Coordinate new;

  if(!old || !(new = malloc(sizeof(CoordinateElement))))
    return NULL;

  new->x = old->x;
  new->y = old->y;
  new->direction = old->direction;
  return new;
}

void deleteCoordinate(Coordinate c) {
  free(c);
}

Direction turn(Direction from, int direction) {
  switch(direction) {
    case DIRECTION_TURN_LEFT:
      return ((from - 1) % 4 + 4) % 4;
    case DIRECTION_TURN_RIGHT:
      return (from + 1) % 4;
    case DIRECTION_STRAIGHT:
    default:
      return from;
  }
}

void move(Coordinate coordinate, int direction, int length) {
  if(!coordinate)
    return;

  coordinate->direction = turn(coordinate->direction, direction);
  switch(coordinate->direction) {
    case NORTH:
      coordinate->y += length;
      break;
    case EAST:
      coordinate->x += length;
      break;
    case SOUTH:
      coordinate->y -= length;
      break;
    case WEST:
      coordinate->x -= length;
  }
}

int distanceBetween(Coordinate c1, Coordinate c2) {
  return abs(c1->x - c2->x) + abs(c1->y - c2->y);
}

int distanceFromZero(Coordinate c) {
  return abs(c->x) + abs(c->y);
}

bool sameCoordinates(Coordinate c1, Coordinate c2) {
  return (c1->x == c2->x) && (c1->y == c2->y);
}
