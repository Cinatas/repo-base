--[[
	settings.lua
		handles OmniCC saved variables
--]]

local function SetDefaults(target, defaults)
	for k, v in pairs(defaults) do
		if type(v) == 'table' then
			target[k] = SetDefaults(target[k] or {}, v)
		end
	end
	
	defaults.__index = defaults
	return setmetatable(target, defaults)
end


--[[ Startup ]]--

function OmniCC:StartupSettings()
	OmniCC4Config = SetDefaults(OmniCC4Config or {}, {
		engine = 'AniUpdater',
		version = self:GetVersion(),
		groupSettings = {base = {}},
		groups = {}
	})

	self.sets = OmniCC4Config
	self:UpgradeSettings()
	self.sets.version = self:GetVersion()

	for id, group in pairs(self.sets.groupSettings) do
		self:StartupGroup(group)
	end
end

function OmniCC:UpgradeSettings()
	local expansion, patch, release = strsplit('.', self.sets.version)
	local version = tonumber(expansion) * 10000 + tonumber(patch or 0) * 100 + tonumber(release or 0)

	if version < 60007 then
		if self:AddGroup('Ignore') then
			self.sets.groupSettings['Ignore'].enabled = false
			self.sets.groups[#self.sets.groups].rules = {'LossOfControl', 'TotemFrame'}
		end
	end
end

function OmniCC:StartupGroup(group)
	return SetDefaults(group or {}, {
		enabled = true,
		scaleText = true,
		spiralOpacity = 1,
		fontFace = STANDARD_TEXT_FONT,
		fontSize = 22,
		fontOutline = 'OUTLINE',
		minDuration = 2,
		minSize = 0.5,
		effect = 'pulse',
		minEffectDuration = 30,
		tenthsDuration = 0,
		mmSSDuration = 0,
		xOff = 0,
		yOff = 0,
		anchor = 'CENTER',
		styles = {
			soon = {
				r = 1, g = .1, b = .1, a = 1,
				scale = 1.1
			},
			seconds = {
				r = 1, g = 1, b = .1, a = 1,
				scale = 1
			},
			minutes = {
				r = 1, g = 1, b = 1, a = 1,
				scale = 1
			},
			hours = {
				r = .7, g = .7, b = .7, a = 1,
				scale = .75
			},
			charging = {
				r = 0.8, g = 1, b = .3, a = .8,
				scale = .75
			},
			controlled = {
				r = 1, g = .1, b = .1, a = 1,
				scale = 1.1
			},
		}
	})
end


--[[ Version ]]--

function OmniCC:GetVersion()
	return GetAddOnMetadata('OmniCC', 'Version')
end
