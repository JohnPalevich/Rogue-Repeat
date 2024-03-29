--[[
    CSIM 2018
    Lecture 1

    -- Game Conf. --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

function love.conf(t)
    t.title = "Rogue:Repeat"	        	-- The title of the window the game is in (string)
    t.author = "John Palevich"	-- The author of the game (string)
    t.window.width = 512			-- The window width (number)
    t.window.height = 512			-- The window height (number)
    t.window.fullscreen = false		-- Enable fullscreen (boolean)
    t.window.vsync = 1			    -- Enable vertical sync (boolean)
end
