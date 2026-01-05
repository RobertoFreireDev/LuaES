# LuaES
Game engine like Pico 8 but using Love2d to be able to play at hardware that supports opengl es

# Implement UI

- Add joystick in buttons as well
- Save/Load Music patterns in txt file
- Implement UI for Sprite/Map Editor
- Implement UI for Sfx/Music Editor

# Run on ArkOS RG353PS 

- alt + l on main.lua to test
- compact all files in same level as file main.lua to zip file and rename to .love extension
- Copy and paste file.love to roms/love2d folder
- to validate files: cmd -> ssh ark@192.168.100.86
- ls -a /opt/love2d (files saved on /opt/love2d)