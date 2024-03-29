--[[
    CSIM 2018

    -- Rigid Body Component --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_rigidbody = class()

local MAX_SPEED = 2

function csim_rigidbody:init(mass, max_speed)
    self.vel = csim_vector(0,0)
    self.acc = csim_vector(0,0)
    self.lastVel = csim_vector(0,0)
    self.max_speed = max_speed or MAX_SPEED
    self.mass = mass or 1
    self.name = "rigidbody"
end

function csim_rigidbody:load()
    print("rigid body load!")
end

function csim_rigidbody:applyForce(f)
    if(f.x ~= 0 and f.y ~= 0) then
      self.lastVel = f
    end

    self.acc.x = self.acc.x + f.x/self.mass
    self.acc.y = self.acc.y + f.y/self.mass
end

function csim_rigidbody:applyFriction(u)
    if(self.vel:mag() > 0.1) then
        local f = csim_vector(self.vel.x, self.vel.y)
        f = f:norm()
        f = f:mul(-1 * u)
        self:applyForce(f)
    else
        self.vel = csim_vector(0,0)
    end
end

function csim_rigidbody:update(dt)
    -- Apply weight force

    self.vel = self.vel:add(self.acc)

    local collider = self.parent:getComponent("collider")
    if(collider) then
        collider:detectVerticalCollision(self.vel)
        collider:detectHorizontalCollision(self.vel)
    end

    if(self.vel:mag() > self.max_speed) then
        self.vel = self.vel:norm()
        self.vel = self.vel:mul(self.max_speed)
    end

    self.parent.pos = self.parent.pos:add(self.vel)

    self.acc = csim_vector(0, 0)
end

return csim_rigidbody
