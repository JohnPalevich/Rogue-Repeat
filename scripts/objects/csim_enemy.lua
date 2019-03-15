--[[
    CSIM 2018

    -- Enemy program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_object = require "scripts.objects.csim_object"

local csim_enemy = class(csim_object)

function csim_enemy:init(x, y, w, h, r, spr, life)
    csim_object:init(x, y, w, h, r, spr)
    self.life =  3
end

function csim_enemy:update(dt)
  if(self:distance() < 125) then
    local vel = player.pos:sub(self.pos)
    vel = vel:norm()
    vel = vel:div(1)
    self.vel = vel
    self.pos = self.pos:add(vel)
    csim_object.update(self, dt)
    self:getComponent("animator"):play("move")
  end
end

function csim_enemy:distance()
  return math.sqrt((self.pos.x-player.pos.x)^2 + (self.pos.y-player.pos.y)^2)
end

function csim_enemy:takeDamage(dmg)
  self.life = self.life - dmg
end

return csim_enemy
