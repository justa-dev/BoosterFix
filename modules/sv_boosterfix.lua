-- Booster fix 
-- by Justa (www.steamcommunity.com/id/just_adam)

-- Instructions:
-- Place into /modules/
-- Add line include("modules/sv_boosterfix.lua") to init.lua
-- Enjoy :)

-- Alright firstly lets create the main function we'll be using here.
local function AcceptInput(self, input, activator, caller, data)
	-- If we are given no data then blah!
	if (not data) then return end

	-- No boosterfix?
	if (self.noboosterfix) then return end

	-- Let's see what booster it is
	if string.match(data, "basevelocity") then 
		-- Values
		local var1, var2, var3 = string.match(data, "basevelocity (%d+) (%d+) (%d+)")
		local vel = self:GetVelocity()
		local pos = self:GetPos()
		local e_pos = caller:GetPos()
		local height = caller:GetCollisionBounds().z

		-- Set the stuff
		self:SetPos(Vector(pos.x, pos.y, e_pos.z + height))
		self:SetVelocity(Vector(0, 0, var3 - vel.z + 278))
		return true
	elseif string.match(data, "gravity") then 
		-- Values
		local grav = string.match(data, "gravity (%-?%d+)")

		-- Set the stuff
		if (tonumber(grav) < 0) then
			local e_pos = caller:GetPos()
			local pos = self:GetPos()
			local vel = self:GetVelocity()

			-- Bounds > 3
			if math.abs(caller:GetCollisionBounds().z) > 3 then 
				e_pos.z = pos.z + (pos.z - e_pos.z)
			else 
				e_pos.z = e_pos.z + caller:GetCollisionBounds().z
			end

			self:SetPos(Vector(pos.x, pos.y, e_pos.z))
			self:SetVelocity(Vector(0, 0, -vel.z + 270))
		end
	end
end
hook.Add("AcceptInput", "boosterfix.acceptinput", AcceptInput)

-- Command
local function AddCommand()
	Command:Register({"boosterfix", "fixboosters", "booster"}, function(ply, arguments)
		ply.noboosterfix = ply.noboosterfix or false 
		ply.noboosterfix = (not ply.noboosterfix)
		Core:Send(ply, "Print", {"Timer", "Booster modifications have now been " .. (ply.noboosterfix and "disabled" or "enabled") .. "."})
	end)
end
hook.Add("Initialize", "boosterfix.addcommand", AddCommand)
