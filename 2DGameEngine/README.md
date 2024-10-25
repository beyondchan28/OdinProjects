# Architectural Decision
- Anything rather than a fundamental systems for 2D games such as Lua Bindings should be treated as plugin

# Odin 2D Game Engine To-Do List:
- [x] Components and Entities base (Entity Manager) 
- [x] Organize to seperate files
- [] Scene system
- [] Hot Reload
- [] Basic GUI 
- [] Integrate with Tiled for level design software
- [] Plugin Box2D (Phyics)

## Problem
- Current implementation still hard coded on declaring components 

## Considerable
- Start to use the GUI to know how the GUI integrates with the engine
- Need to find a good way to set components

### Implementing Entity Manager
- Need a function to check and find active and deactive entities
- Adding a new entity, should be automatically choose the right index
- Removing an entity should also deactivated all its components
- Function to declaring components

### Odin Related To-Do List
- [] Tryout the arena allocator and temp_allocator
- [] Tracking memory leak
- [] Attributes