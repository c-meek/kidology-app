#5 week left meeting
* dashboard
* custom target
* writing stats to text file -> dumping into email

kidology-app
============
##@target game TODO
* ~~end the game (after N targets) -> to finish screen (with some sort of metrics or result?)~~
* radomize target types
* ~~randomize positions and scale of targets (in the subscreen)~~
* track the proper statistics/medical metrics
* ~~anchor~~

##@fetch game TODO
* add sounds for ball hit, dog go, & dog return
* better background

##@custom target game TODO
* read in values (floats)
```
Number of targets
Target delay after target touched
x1 y1 scale1
x2 y2 scale2
.
.
.
xN yN scaleN
```
* put values into object (2d array?, map?)
* have number of targets touched correspond to the object
* ~~I don't think having the targets timed as important, so default to 3 seconds (=target game)~~ We will take a value for this instead, where all targets appear after the custom time


