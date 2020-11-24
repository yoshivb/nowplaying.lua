-- This version was tested using VLC version 3.0.11 (Windows) --

--[[
INSTALLATION:
Put the file in the VLC subdir /lua/extensions, by default:
* Windows (all users): C:\Program Files (x86)\VideoLAN\VLC\lua\extensions
* Windows (current user): C:\Users\USER\AppData\Roaming\vlc\lua\extensions
To load extension simply restart VLC or from the menu bar Tools -> Plugins and extensions -> Active extensions click Reload extensions
Activate the extension by going to the "View" menu and click on "Now Playing Info"

CONFIG:
In the config variable below you can setup the pattern for converting to the metadata into your now_playing.txt content.
Some common meta keys:
description,
date,
artwork_url,
genre,
track_total,
album,
track_number,
filename,
publisher,
copyright,
artist,
language,
title
--]]

-- Loads required libraries
require "io"
require "string"

local config = {
    infoPattern = "{artist} - {album} - {title}"
}

-- VLC Extension Descriptor
function descriptor()
	return {
        title = "Now Playing Info";
        version = "0.9";
        author = "yoshivb";
        url = 'https://github.com/yoshivb';
        shortdesc = "Now Playing Info";
        description = "Writes the current song info and album art into files.<br />"
                    .."(Fork from j-witz's extension)<br />"
                    .."(https://github.com/J-Witz/nowplaying.lua)<br />"
                    .."(Modified by yoshivb)";
        capabilities = { "meta-listener" };
    }
end

-- This function is triggered when the extension is activated
function activate()
	vlc.msg.dbg("[Now Playing Radio] Activated")
	handleItem()
	return true
end

-- This function is triggered when the extension is deactivated
function deactivate()
	vlc.msg.dbg("[Now Playing Radio] Deactivated")
	return true
end

-- Triggered by change in input meta
function meta_changed()
	handleItem()
end

-- Reads meta information and writes them to the files
function handleItem()
	local item = vlc.item or vlc.input.item()
	if not (item == nil) and vlc.input.is_playing() then   
        local infoFilePath = vlc.config.homedir() .. "/now_playing.txt"
        local artFilePath = vlc.config.homedir() .. "/now_playing.jpg"
        local infoFile = io.open(infoFilePath, "w+")
    
        local infoString = config.infoPattern
        
		local metas = item:metas()
        if metas then
            for key, value in pairs(metas) do
                infoString = string.gsub(infoString, "{" .. key .. "}", value)
            end
        else
            vlc.msg.info("no meta data available")
        end
        infoString = string.gsub(infoString, "{.}", "")
               
        infoFile:write(infoString)
        
        if not (metas.artwork_url == nil) then
            local artwork_path = vlc.strings.make_path(metas.artwork_url)
            local artInFile = io.open(artwork_path, "rb")
            local artBytes = artInFile:read("*a")
            artInFile:close()

            local artFile = io.open(artFilePath, "wb")
            artFile:write(artBytes)
            artFile:close()
        else
            vlc.msg.info("no artwork data available")
        end
        
        infoFile:close()
	end
end
