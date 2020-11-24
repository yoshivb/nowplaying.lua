# nowplaying.lua

This VLC Media Player extension will create a text file for both the artist name and track title for the currently playing input.
The current version was tested using VLC version 3.0.11 (windows)

INSTALLATION:
Put the file in the VLC subdir /lua/extensions, by default:
* Windows (all users): C:\Program Files (x86)\VideoLAN\VLC\lua\extensions
* Windows (current user): C:\Users\USER\AppData\Roaming\vlc\lua\extensions
To load extension simply restart VLC or from the menu bar Tools -> Plugins and extensions -> Active extensions click Reload extensions
Activate the extension by going to the "View" menu and click on "Now Playing Radio: Write song name and artist to file."

CONFIG:
In the config variable in the script you can setup the pattern for converting to the metadata into your now_playing.txt content.
Some common meta keys:
* description
* date
* artwork_url
* genre
* track_total
* album
* track_number
* filename
* publisher
* copyright
* artist
* language
* title
