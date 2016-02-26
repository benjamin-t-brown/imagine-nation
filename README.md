## Imagine Nation - Powered by the Illuamination Engine

```
Powered by the ILUAmination Engine

+------------------------------------------+
| ...........^.........../    \............|
| ........../ \......._./    ^ \...........|
| ........./   \..^._/      ^    \ -^- ....|
| ......--.     {`        ^  \ \  \_   \ ..|
| ...._/  ^    /      ^ ^  \        \    \.|
| ../    / \  /        \  \  \ \    }__    |
| ./   /`   \/      /   \  \           '\  |
| /   /   \ /  '\__/     `_       \      ' |
|    (     {        []     `   \   \      \|
|    /    {        /=\      \   \    \     |
|  _/      ,+,    /=-\       }             |
|(`        (,)    -= \        ____________ |
|         (   )  /== \    ___/~.~~~.~~.~~  |
|   ,^,    ```  -=-  \  _/~~ .~~.~~~.~~.~~ |
|  (   )       /==- \   ~~~~ .~~ ~.~~.~~.~~|
|   ```      /-==== \      \~~~.~~~~~~~.~~ |
+------------------------------------------+

```

This is an adventure game that tells the story of a girl who dozed off in class and found
herself in a strange, but oddly familiar world.

### Platforms:

	Windows

### Gameplay

The game is run like a text-based adventure, however only decisions are made via the
number keys 1-9.  It is played entirely in the Windows default terminal.

### Installation

No installation is required to play.  Simply go into the 'bin' folder and double click 
'ImagineNation.bat'.

### Development

To develop on this platform, the following technologies are required:

[Lua](http://www.lua.org/) - Version 5.2 or higher

[Node](https://nodejs.org/en/) - This is used to compile text into lua files (and for the web interface)

[Mingw](http://www.mingw.org/) - This is required for 'make'

[OpenOffice*](https://www.openoffice.org/)

*Any program that can edit *.odt files will work.

All game logic is written using [Lua](http://www.lua.org/) and all display should be
routed through the Illuamination Engine's display module.  

Game text is stored initially in *.odt (so they can have text color formatting and 
spellcheck for organizational purposes) files which are then converted into *.txt files
which are then compiled into Lua files.

To build game text from odt files into lua files, use the provided makefile.

### Screenshots

```
Powered by the ILUAmination Engine

  You stand inside of a massive cavern, cracks on the ceiling allowing
  slim rays of sunlight to cascade off of the walls. Stalagmites line
  the ceiling above a pool of water that dominates the majority of the
  walking space. You see an exit across the pool of water, and you also
  see a smaller path that leads further underground. You hear a very
  feint voice, almost not there, calling out from a passageway across
  the pool.

==================================================
1.) Cross the pool of water to the exit on the other side.
2.) Go further underground.
==================================================
```