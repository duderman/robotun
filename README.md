# Robotun

## Description

- The application is a simulation of a toy robot moving on a square tabletop, of dimensions 5 units x 5 units
- There are no other obstructions on the table surface
- The robot is free to roam around the surface of the table, but must be prevented from falling to destruction. Any movement that would result in the robot falling from the table must be prevented, however further valid movement commands must still be allowed
- You need to provide test data/results for the app & its logic

## Objectives

- Create an application that can read in commands of the following form:
  - PLACE X,Y,F
  - MOVE
  - LEFT
  - RIGHT
  - REPORT
- PLACE will put the toy robot on the table in position X,Y and facing NORTH, SOUTH, EAST or WEST
- The origin (0,0) can be considered to be the SOUTH WEST most corner
- The first valid command to the robot is a PLACE command, after that, any sequence of commands may be issued, in any order, including another PLACE command
- The application should discard all commands in the sequence until a valid PLACE command has been executed
- MOVE will move the toy robot one unit forward in the direction it is currently facing
- LEFT and RIGHT will rotate the robot 90 degrees in the specified direction without changing the
position of the robot
- REPORT will announce the X,Y and F of the robot. This can be in any form, but standard output is
sufficient
- Input can be from a file, or from standard input, as the developer chooses
- Provide test data to exercise the application

## Constraints

- The toy robot must not fall off the table during movement. This also includes the initial
placement of the toy robot
- Any move that would cause the robot to fall must be ignored

## Example

### Input

```text
PLACE 0,0,NORTH
MOVE
REPORT
PLACE 0,0,NORTH
LEFT
REPORT
PLACE 1,2,EAST
MOVE
MOVE
LEFT
MOVE
REPORT
```

### Output

```text
0,1,NORTH
0,0,WEST
3,3,NORTH
```

## How to run

1. Clone repo
2. `asdf install` (or similar for your version manager)
3. `bundle install`
4. `exe/robotun commands.txt`

OR:

4. `gem build robotun.gemspec`
5. `gem install ./robotun-0.1.0.gem`
6. Rehash your version manager binaries
7. `robotun commands.txt`

## TODO

- [ ] Separate logging and reporting output
- [ ] Separate configure method and config singleton class to hold logger, output etc
- [ ] Only use ARGF when running from a bin, leaving an option to actually use code as a gem
- [ ] Output option when running as a bin (to be able to use files or whatever)
