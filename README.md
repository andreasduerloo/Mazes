# Mazes

Mazes is a work-in-progress project exploring maze generation and pathfinding algorithms.

These topics are currently ready:

- Maze generation
  - Randomized depth-first search

## Maze generation

A 'good' or 'correct' maze has a few properties:
- Every point is reachable from any other point. Without this property we would have disjointed parts of the maze, separated by a wall.
- Every point is connected to every other point by exactly one direct path. Without this property we would have loops and isolated islands of walls that could mess with some of the more naive pathfinding algorithms.
See also the [Wikipedia article](https://en.wikipedia.org/wiki/Maze_generation_algorithm).

These properties allow mazes to be considered [spanning trees](https://en.wikipedia.org/wiki/Spanning_tree).

### Randomized depth-first search

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

After this algorithm has run its course, there will be no more unconnected/unvisited nodes. The output will be (in this implementation) a map of nodes and the node they were visited from.
    