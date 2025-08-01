global.game.player = id

//inherit
event_inherited()

//movement
setCollisionMask(10, 14)

//graphics
anisprite = new Anisprite("Alchemist", id)
depth = DEPTH_LEVELS.PLAYER