minetest mod Beds
=========================

This mod improves beds which allows sleep, featured to (auto) skip the night.

Information
-----------

This mod is named `beds` to sleep, by rightclick the bed. It featured
in singleplayer mode that the night gets skipped immediately. If playing
in multiplayer you get shown how many other players are in bed too,
if all players are sleeping the night gets skipped.

![screenshot.jpg](screenshot.jpg)

Tech information
----------------

This mod sustitute default one, you must disable the default of minetest
game if present or override it.

#### Features

* Night Skypping:

This mod auto featured night skip in singleplayer, in multiplayer it skipped
if more than a set percentage (default 50%) of the players are lying
in bed and use this option. Check configuration section for more info.

* Controlled respawning:

If you have slept in bed (not just lying in it) your respawn point
is set to the beds location and you will respawn there after
death. Check configuration section for more info.

* More beds:

It features more beds, so along with the Red simple bed we now have White and
Blue, and the fance beds has the original Red and now Pink.

#### Dependencies

* default
* player_api (for newer engines)

Optional dependences:

* intllib (only for older engines)
* pova (optional)

The pova mod are not xplicit set as optional depends, due the circular depends bug,
its detected and used.

#### Configuration

| Configuration         | type  | default | place file   |  Notes about                             |
| --------------------- | ----- | ------- | ------------ | ----------------------------------------- |
| enable_bed_respawn    | bool  |  true   | minetest.conf | Enable respawn point set to last sleep bed |
| enable_bed_night_skip | bool  |  false  | minetest.conf | You can disable the night skip feature |
| bed_sleep_divide      |  int  |    2    | minetest.conf | Division of players needed to skip night |

#### Nodes

Crafting are same as original default mod, but colored uses a white plus the other color.

| Node name               | Description name      |
| ----------------------- | --------------------- |
| beds:bed                | Simple bed            |
| beds:bed_blue           | Simple bed blue       |
| beds:fancy_bed          | Fancy shaped bed      |
| beds:fancy_bed_pink     | Fancy shaped bed pink |

#### Nodes and Aliasing

| mod name : node name        | new mod name : new node |
| --------------------------- | ----------------------- |
| beds:bed_top_red            | beds:bed_top            |
| beds:bed_bottom_red         | beds:bed_bottom         |

#### Mini-Game Support

If enable_bed_respawn is set to true and a player dies when playing a mini-game then this
can interrupt the game, so a special beds.respawn[player_name] flag has been added which
is set to 'true' by default to always respawn player at their bed, but can be set to
'false' during a mini-game to stop this behaviour.


License
------

### Authors of source code

Originally by BlockMen (MIT)
Various Minetest developers and contributors (MIT)

### Authors of media (textures)

BlockMen (CC BY-SA 3.0)
 All textures unless otherwise noted

JP (WTFPL)
 All models unless otherwise noted

VOPI Team (CC BY-SA 3.0)
beds_bed.png
beds_bed_inv.png
beds_halloween_bed.png
beds_halloween_bed_inv.png

Check [license.txt](license.txt)
