# Mazes

Mazes is a work-in-progress project exploring maze generation and pathfinding algorithms in Elixir.

These topics are currently ready:

- [Maze generation](https://github.com/andreasduerloo/Mazes#maze-generation)
  - [Randomized depth-first search](https://github.com/andreasduerloo/Mazes#randomized-depth-first-search)
- Maze solving and pathfinding
  - Randomly walking around
  - Following a wall

## Maze generation

A 'good' or 'correct' maze has a few properties:
- Every point is reachable from any other point. Without this property we would have disjointed parts of the maze, separated by a wall.
- Every point is connected to every other point by exactly one direct path. Without this property we would have loops and isolated islands of walls that could mess with some of the more naive pathfinding algorithms.
See also the [Wikipedia article](https://en.wikipedia.org/wiki/Maze_generation_algorithm).

These properties allow mazes to be considered [spanning trees](https://en.wikipedia.org/wiki/Spanning_tree).

### Randomized depth-first search

This method is based on a [depth-first search](https://en.wikipedia.org/wiki/Depth-first_search). This means we keep going down one path until we can't go any further. At that point we step back on the path we came just far enough to where we can branch off again.

Example output (20 x 20 nodes):

```
##################################################################################
##      ##              ##      ##      ##  ##      ##                          ##
##  ######  ######  ##  ##  ##  ##  ##  ##  ##  ##  ##########  ##############  ##
##  ##      ##      ##      ##      ##  ##      ##          ##  ##              ##
##  ##  ######  ######################  ##################  ##  ##  ##############
##          ##  ##              ##          ##      ##  ##      ##  ##          ##
##  ##########  ##  ##########  ##########  ##  ##  ##  ##########  ##  ##  ######
##  ##  ##      ##  ##      ##          ##      ##  ##      ##      ##  ##      ##
##  ##  ##  ##  ##  ##  ##  ##########  ##########  ##  ##  ##  ######  ######  ##
##  ##  ##  ##  ##  ##  ##  ##      ##          ##      ##  ##      ##      ##  ##
##  ##  ##  ##  ##  ##  ##  ######  ##########  ##########  ######  ##  ######  ##
##  ##  ##  ##  ##      ##      ##  ##      ##      ##      ##      ##  ##      ##
##  ##  ##  ##################  ##  ##  ##  ######  ##########  ######  ##  ######
##      ##                  ##  ##      ##  ##      ##          ##      ##      ##
######  ##################  ##  ##  ######  ##  ######  ##########  ##########  ##
##  ##  ##          ##      ##  ##      ##  ##      ##  ##          ##      ##  ##
##  ##  ######  ######  ######  ##########  ######  ##  ######  ######  ##  ##  ##
##  ##      ##      ##          ##      ##  ##      ##      ##  ##      ##  ##  ##
##  ######  ######  ##############  ##  ##  ##  ##  ######  ##  ##  ######  ##  ##
##  ##      ##      ##          ##  ##      ##  ##  ##      ##      ##  ##  ##  ##
##  ##  ######  ##  ##  ######  ##  ######  ##  ##  ##  ##############  ##  ##  ##
##  ##          ##      ##  ##  ##  ##  ##  ##  ##  ##              ##      ##  ##
##  ######################  ##  ##  ##  ##  ##  ##  ##############  ##########  ##
##                      ##  ##  ##  ##      ##  ##          ##      ##      ##  ##
##  ##########  ######  ##  ##  ##  ##########  ##  ##########  ######  ##  ##  ##
##  ##      ##      ##  ##  ##  ##      ##      ##  ##      ##      ##  ##      ##
##  ##  ##  ######  ##  ##  ##  ######  ##  ##########  ##  ######  ##  ######  ##
##  ##  ##  ##      ##      ##          ##              ##      ##      ##      ##
##  ######  ##  ######################  ######################  ##########  ######
##          ##  ##                                          ##          ##  ##  ##
##########  ##  ##  ######################  ##################  ######  ##  ##  ##
##      ##  ##  ##  ##                  ##  ##                  ##  ##  ##      ##
##  ##  ##  ##  ##  ##  ##############  ######  ##  ##############  ##  ######  ##
##  ##  ##  ##      ##      ##  ##              ##  ##          ##      ##      ##
######  ##  ##############  ##  ##  ##############  ##  ######  ######  ##  ######
##      ##      ##  ##      ##  ##  ##          ##  ##      ##      ##  ##  ##  ##
##  ##########  ##  ##  ######  ##  ##  ######  ##########  ######  ##  ##  ##  ##
##  ##          ##  ##      ##      ##  ##  ##          ##  ##  ##  ##  ##      ##
##  ##  ##########  ######  ##########  ##  ######  ######  ##  ##  ##########  ##
##                      ##                      ##              ##              ##
##################################################################################
```
 #### How it works

 1. Start with a grid of unconnected nodes. We use a map where pairs of coordinates are the key. As values we will store the previous node.
 2. Take a random node to be the origin. That's where we'll start building the maze.
 3. For that node, list all unvisited neighbors (i.e. neighboring nodes that don't have a previous node in the map).
    - If there are unvisited neighbors, step to one at random and note the node we came from. Recursively go to step 3 for the new node.
    - If there are no unvisited neighbors: 
      - Is the current node the origin? That means we're done!
      - If the current node is not the origin, step back to the previous node and recurse into step 3 again.

After this algorithm has run its course, there will be no more unconnected/unvisited nodes. The output will be (in this implementation) a map of nodes and the node they were visited from. We then run that output through a drawing function which translates it into the output you see above.

## Maze solving and pathfinding

### Randomly walking around

This approach consists of making random decisions whenever a junction is reached, without keeping track of where w've been before. Given a finite maze where all nodes are connected, we will eventually find a path from any point to any other. This kind of strategy is far from optimal, but it can be used in real life (and very likely is, most of the time) by people or animals that have to navigate a maze.

### Following a wall

Another strategy available to people (but most likely overly ambitious for most animals), and one that is widely shared as a clever way to solve a maze, consists of keeping either your left or right hand on a wall the entire time. This approach ensures that for a 'correct maze' (see above), you will eventually visit all points in the maze without needing to keep track of where you have been. Under the hood, it's also a form of depth-first search.