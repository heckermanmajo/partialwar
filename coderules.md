# Code Rules 

## Objects
Object contain state. They should not contain any logic.

## Functions
Functions are only pure.

## Systems 
Systems contain the logic of the application.
They can have local state, but the state of a system 
cannot leave the system.

Systems CANNOT call other systems, they are only allowed 
to call compositions.

## Compositions
Compositions are functions that do not change any state, but
extract new state out of the given data.

They can be used by multiple systems.

## Parameterize 
Always parameterize the code. Dont put in "god objects", like
"Battle", but only what is needed.

Alo dont use globals OR hard coded values.