# Roadmap

## v01 - proof of concept

- Rename Managers to systems
- Create interfaces for all systems, what they need and 
  create check function for the interfaces

- move the registration of instances into the new function 

- CLEANUP OF THE CODE
 - add asserts
 - add checks for all data
 - add comments to all functions
 - add type hint comments

CLEANUP 
- MAKE all input to functions explicit, so we only 
  pass in what is really needed

- CLEANUP of the readmes 
- start battle and start campaign bash script
- Describe game 
- cleanup of the roadmap
- each camp object its own file

- Make the code more flexible
- comment what need to be done for adding multiple factions


## v02 - tech demo
- in battle ui, that works with all settings
  - so we need different icons to the unit types
  - also we need to specify the unit type, cluster/cost

- campaign ai improvement
  - improve the ai to pick of smaller units
  - sometimes attack bigger units to weaken them
  - try to block access points
  - try to conquer mineral or factories

- sounds
  - fight sound
  - die sound
  - sounds for the campaign view
    - create army
    - move army
    - merge army
    - increase units in army

- movement improvements
  - move first to a position in the chunk, where your enemy is in
  - move to 3 chunks before this one
  - UNITS SHOULD MOVE IN FORMATION OR AT LEAST IN A LINE until they are near the enemies
  

## v03 - demo
- ai improvement
- more unit types 
- nice UI
- destructable barriers and turrets
- bigger units, like giants


## v04 - alpha
- load campaign from image
- multiple factions on campaign map
- diplomacy
  - each faction with a character and a relation 
  - different factions to pick at the start
- improved real time battle system 
- commander
- rts-commands to manage units (based on commander)
- controllable commanders
  - ranged attack
  - some enemy units focus the commander
  - up to 3 near by focus the commander
  - the commander can lead near by own units around

## v05 - early access
- multiple scenarios (medival, modern, future, fantasy)
- save/load system