# Change hookable element
To make a line tracing element, who ever will touch it, you can copy/duplicate the "HookableNeedle" scene 
And copy it into Stela folder, then change it's sprite to a stone or something like that directly from the scene
You just copied

# To make the line as a drawabe element
Look at the scene in "grappling_hook_needles.tsc" inside story lore-quest -> quest_002 -> 2_grappling_hook
And identify/understand, how the needles near the door was made to (you have to code a bit at this point 
to make the red needle appear or something like that)

# To finish the game 
Put the player into "COZY" Mode (as showed in the inspector) from a script or an AnimationPlayer(you can use this as well)
So only in this mode, the player will be able to collect the collectible, you can also create a little dialogue after collecting 
the collectible by creating it through the collectible element inspector.

## Challenge for the implementation of this level
- Creating a customized hookable glowing stone that will be used to be linked to draw a shape which will have an impact on the game
- 

## PS do not forget 
When using tailmap to design the level, VOID tilemap is superior to FLOOR tilemap so instead of erasing floor from the FLOOR
tilemap, consider adding/setting a void on top of it 
