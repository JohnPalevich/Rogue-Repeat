	--[[
	    CSIM 2018

	    -- Main Program --
	    Author: Lucas N. Ferreira
	    lferreira@ucsc.edu
	]]

	-- Loading external libraries
	local sti = require "lib.sti"
	local push = require "lib.push"
	local class = require "lib.class"

	-- Loading objects
	local csim_object = require "scripts.objects.csim_object"
	local csim_enemy = require "scripts.objects.csim_enemy"
	local csim_player = require "scripts.objects.csim_player"
	local csim_camera = require "scripts.csim_camera"
	local csim_math = require "scripts.csim_math"
	local csim_level_parser = require "scripts.csim_level_parser"
	local csim_animator = require "scripts.components.csim_animator"
	local csim_vector = require "scripts.csim_vector"
	-- Importing components
	local csim_rigidbody = require "scripts.components.csim_rigidbody"

	-- Setting values of global variables
	local gameWidth, gameHeight = 256, 256
	local windowWidth, windowHeight, flags = love.window.getMode()

	function love.load()
		love.graphics.setDefaultFilter('nearest', 'nearest')
	  endGame = false
		numKills = 0
		numCoins = 0

		-- Initialize virtual resolution
		push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})
		currlvl = 1
		maps = {}
		map1 = sti("map/testmp.lua")
		map2 = sti("map/map3.lua")
		map3 = sti("map/lvl2.lua")
		map4 = sti("map/lvl4.lua")
		map5 = "endgame"
		--sound = love.audio.newSource("sounds/music.wav", "static")
		--sound:setLooping(true)
		--sound:play()
		table.insert(maps, map1)
		table.insert(maps, map2)
		table.insert(maps, map3)
		table.insert(maps, map4)
		table.insert(maps, map5)

		newLvl(maps[currlvl])

	end

	function newLvl(map)
		-- Creating a table to represent the player with three variables: sprite, x and y
		--sound:stop()
		if(map == "endgame") then
			endGame = true
			return
		end
		--sound:play()
		level_parser = csim_level_parser(map)

		-- Load characters
		player, enemies = level_parser:loadCharacters("Characters")

		local animator = csim_animator(love.graphics.newImage("map/playersprtmp.png"), 32, 32)
		animator:addClip("idle", {1}, 1, true)
		animator:addClip("move", {1,2,3,4,5,6}, 10, true)
		animator:addClip("attack", {7,8,9}, 10, true)
		player:addComponent(animator)

		for i=1, #enemies do
			local animator = csim_animator(love.graphics.newImage("map/enemy.png"), 32, 32)
			animator:addClip("move", {1,2}, 10, true)
			enemies[i]:addComponent(animator)
		end
		musicstrt = false
		items = level_parser:loadItems("Items")
		for i=1, #items do
			local animator = csim_animator(love.graphics.newImage("map/coin.png"), 32, 32)
			animator:addClip("idle", {1,2,3,4}, 3, true)
			items[i]:addComponent(animator)
		end
		healthBar = csim_object(player.pos.x, player.pos.y-10, 32, 12, 0, love.graphics.newImage("map/healthbar.png"))
		local animator = csim_animator(love.graphics.newImage("map/healthbar.png"), 32, 12)
		animator:addClip("full", {1},10,true)
		animator:addClip("nine", {2},10,true)
		animator:addClip("eight", {3},10,true)
		animator:addClip("seven", {4},10,true)
		animator:addClip("six", {5},10,true)
		animator:addClip("five", {6},10,true)
		animator:addClip("four", {7},10,true)
		animator:addClip("three", {8},10,true)
		animator:addClip("two", {9},10,true)
		animator:addClip("one", {10},10,true)
		healthBar:addComponent(animator)
		healthBar.timer = 0
		--PlayMUSIC

		--winmus = love.audio.newSource("sounds/winGame.wav", "static")
		--winmus:setLooping(true)
		-- Load Camera
		camera = csim_camera(0, 0)
	end

	function love.update(dt)

		if(endGame) then
			return
		end

		if(player.nextlvl) then
			currlvl = currlvl + 1
			newLvl(maps[currlvl])
		end
		--player.attackTimer = player.attackTimer + 1
		healthBar.timer = healthBar.timer + 1
		player:update(dt)
		for i=1, #enemies do
			enemies[i]:update(dt)
		end
		healthBar.pos = csim_vector(player.pos.x, player.pos.y-10)
		for i=1, #items do

			items[i]:update(dt)
			items[i]:getComponent("animator"):play("idle")
		end

		camera:setPosition(player.pos.x - gameWidth/2, player.pos.y - gameHeight/2)
		camera.x = csim_math.clamp(camera.x, 0, 768)
		camera.y = csim_math.clamp(camera.y, 0, 256)

	end

	function drawGame()
		maps[currlvl]:draw(-camera.x, -camera.y)

		-- Draw the player
		player:draw()
		if(healthBar.timer < 100) then
			healthBar:draw()
		end
		-- Draw the enemy
		for i=1,#enemies do
			if(enemies[i]:distance() < 200) then
				enemies[i]:draw()
			end
		end
		-- Draw the coins
		for i=1,#items do

			items[i]:draw()
		end

	end

	function drawEndGame()
		--sound:stop()
		winmus:play()
		camera:setPosition(0,0)
		love.graphics.print("Congratulations, you beat the playtest \n of Rogue: Repeat", 0, 0)
		love.graphics.print("You earned ".. numCoins .. " coins!", 0, 30)
		love.graphics.print("You killed ".. numKills.. " enemies!", 0, 45)
		love.graphics.print("You survived with "..player.life .. " health!", 0, 60)
	end

	function love.draw()
		push:start()

		-- Enable camera
		camera:start()
		if(endGame) then
			print("in end game")
			drawEndGame()
    else
			drawGame()
		end
		-- Disable camera
		camera:finish()
		love.graphics.print("FPS:" .. love.timer.getFPS())
		-- Draw the number of coins
		--love.graphics.print(number_coins, gameWidth - 20, 20)

		push:finish()
	end
