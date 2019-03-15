local csim_math = require "scripts.csim_math"
local csim_vector = require "scripts.csim_vector"

local csim_object = require "scripts.objects.csim_object"

local csim_player = class(csim_object)

function csim_player:init(x, y, w, h, r, spr, life)
    csim_object:init(x, y, w, h, r, spr)
    self.maxLife = 20
    self.life = 20
    self.is_on_ground = false
    self.nextlvl = false
    --self.attackTimer = 25
end

function csim_player:move(r, l, u, d)
  if( love.keyboard.isDown("space")) then
    self:getComponent("animator"):play("attack")
    return
  end
	if(love.keyboard.isDown(r)) then
        local f = csim_vector(0.2, 0)
        self:getComponent("rigidbody"):applyForce(f)

        -- Play move animation
        self.dir = 1
        if(self:getComponent("rigidbody").vel.y == 0) then
            self:getComponent("animator"):play("move")
        end
    elseif(love.keyboard.isDown(l)) then
        local f = csim_vector(-0.2, 0)
        self:getComponent("rigidbody"):applyForce(f)

        -- Play move animation
        self.dir = -1
        if(self:getComponent("rigidbody").vel.y == 0) then
            self:getComponent("animator"):play("move")
        end
    elseif(self:getComponent("rigidbody").vel.y == 0) then
        self:getComponent("animator"):play("idle")
	end

	if(love.keyboard.isDown(u)) then
      local f = csim_vector(0, -0.2)
      self:getComponent("rigidbody"):applyForce(f)
      self:getComponent("animator"):play("move")
	end

	if( love.keyboard.isDown(d)) then
		local f = csim_vector(0, 0.2)
        self:getComponent("rigidbody"):applyForce(f)
        self:getComponent("animator"):play("move")
	end

end

function csim_player:takeDamage(damage)
    self.life = self.life - damage
    if(self.life <= 0) then
        --sound:stop()
        love.load()
    end
end

function csim_player:onVerticalCollision(tile, vert_side)
  if (tile.id == 4 or tile.id == 5) and not self.nextlvl then
    player.nextlvl = true
  end
end

function csim_player:onHorizontalCollision(tile, hor_side)
  if (tile.id == 4 or tile.id == 5) and not self.nextlvl then
    player.nextlvl = true
  end
end

function csim_player:onVerticalTriggerCollision(tile, vert_side)

end

function csim_player:onHorizontalTriggerCollision(tile, horz_side)

end

function csim_player:update(dt)
    csim_object.update(self, dt)
    self:getComponent("rigidbody"):applyFriction(0.15)
    self:move("d", "a", "w", "s")
    --self.attackTimer = self.attackTimer + 1
    for i=1,#items do
        if(items[i] ~= nil) then
            local box_a = self:getComponent("collider"):getAABB()
            local box_b = items[i]:getComponent("collider"):getAABB()

            if(csim_math.checkBoxCollision(box_a, box_b)) then
                -- Collect coin
                coinsfx = love.audio.newSource("sounds/coinsfx.wav", "static")
            		--`coinsfx:setLooping(true)
            		coinsfx:play()
                numCoins = numCoins + 1
                table.remove(items, i)
            end
        end
    end
    for i=#enemies,1, -1 do
        if(enemies[i] ~= nil) then
            local box_a = self:getComponent("collider"):getAABB()
            local box_b = enemies[i]:getComponent("collider"):getAABB()

            if(csim_math.checkBoxCollision(box_a, box_b)) then
                --Take damage
                if(love.keyboard.isDown("space")) then
                  atksfx = love.audio.newSource("sounds/batsfx.wav", "static")
              		--atksfx:setLooping(true)
              		atksfx:play()
                  if(enemies[i].vel ~= nil) then
                    vel = enemies[i].vel
                    vel.y = vel.y * -20
                    vel.x = vel.x * -20
                    enemies[i]:getComponent("rigidbody").vel = csim_vector(0,0)
                    enemies[i]:getComponent("rigidbody"):applyForce(vel)
                  end
                  enemies[i].life = enemies[i].life - 1
                  if(enemies[i].life <=0) then
                    table.remove(enemies, i)
                    numKills = numKills + 1
                  end
                else
                  self:takeDamage(1)
                  dmgsfx = love.audio.newSource("sounds/damagesfx.wav", "static")
              		--dmgsfx:setLooping(true)
              		dmgsfx:play()
                  healthBar.timer = 0
                  self:getComponent("rigidbody").vel = csim_vector(0,0)
                  if(enemies[i] ~= nil and enemies[i].vel ~= nil) then
                    vel = enemies[i].vel
                    vel.y = vel.y * 20
                    vel.x = vel.x * 20
                    self:getComponent("rigidbody"):applyForce(vel)
                  end
              end
            end
        end
        self:setHealthBar(dt)
    end

end
function csim_player:setHealthBar(dt)
  csim_object.update(healthBar, dt)
  if(player.life == player.maxLife) then
    healthBar:getComponent("animator"):play("full")
  elseif (player.maxLife * 0.9 <= player.life) then
    healthBar:getComponent("animator"):play("nine")
  elseif (player.maxLife * 0.8 <= player.life) then
    healthBar:getComponent("animator"):play("eight")
  elseif (player.maxLife * 0.7 <= player.life) then
    healthBar:getComponent("animator"):play("seven")
  elseif (player.maxLife * 0.6 <= player.life) then
    healthBar:getComponent("animator"):play("six")
  elseif (player.maxLife * 0.5 <= player.life) then
    healthBar:getComponent("animator"):play("five")
  elseif (player.maxLife * 0.4 <= player.life) then
    healthBar:getComponent("animator"):play("four")
  elseif (player.maxLife * 0.3 <= player.life) then
    healthBar:getComponent("animator"):play("three")
  elseif (player.maxLife * 0.2 <= player.life) then
    healthBar:getComponent("animator"):play("two")
  elseif (player.maxLife * 0.1 <= player.life) then
    healthBar:getComponent("animator"):play("one")
  end
end

return csim_player
