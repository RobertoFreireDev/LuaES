# LuaES
Game engine like Pico 8 but using Love2d to be able to play at hardware that supports opengl es

# TO DO List

## Input

- add Scroll up and down to mouse()

## Timer Functions

- custom timer parameter
- pause timer parameter
- resume timer parameter

## Pixel Editor

- Tiles 8x8
- Create SpriteSheet
- Save and Load SpriteSheet
- Save and Load flags
- Implement UI for Pixel Editor

Functions:

- spixel -> set pixel on SpriteSheet
- gpixel -> get pixel from SpriteSheet
- sflag -> set flag
- gflag -> get flag
- spr(n, x, y, [w], [h], [flip_x], [flip_y]) — Draw sprite n.
- sspr(sx, sy, sw, sh, dx, dy, [dw], [dh]) — Draw a section of the sprite sheet.

## Map Editor

- Tiles 8x8
- Create MapSheet
- Save and Load MapSheet
- Implement UI for Map Editor

Functions:

- map(cel_x, cel_y, sx, sy, [cel_w], [cel_h], [layer]) — Draw map tiles.
- mget(x, y) — Get map tile.
- mset(x, y, v) — Set map tile.

## Sfx Editor

- Implement UI for Sfx Editor

## Music Editor

- music(n)
- Implement UI for Sfx Editor

# Run on ArkOS RG353PS 

- alt + l on main.lua to test
- compact all files in same level as file main.lua to zip file and rename to .love extension
- Copy and paste file.love to roms/love2d folder
- to validate files: cmd -> ssh ark@192.168.100.86
- ls -a /opt/love2d (files saved on /opt/love2d)