local momentum = require("__sir-rolins-momentum-modules__/lib/momentum")
require("__sir-rolins-momentum-modules__/lib/module_list")
local SetupRampMod = momentum.SetupRampMod
local getTintedIcons = momentum.getTintedIcons
local scaleModuleEffect = momentum.scaleModuleEffect
local withoutEffect = momentum.withoutEffect
local withAddedEffect = momentum.withAddedEffect
local unit1, unit2, unit3 = momentum.unit1, momentum.unit2, momentum.unit3

local productivity1 = util.table.deepcopy(data.raw.module["productivity-module"])
local productivity2 = util.table.deepcopy(data.raw.module["productivity-module-2"])
local productivity3 = util.table.deepcopy(data.raw.module["productivity-module-3"])
local speed1 = util.table.deepcopy(data.raw.module["speed-module"])
local speed2 = util.table.deepcopy(data.raw.module["speed-module-2"])
local speed3 = util.table.deepcopy(data.raw.module["speed-module-3"])
local efficiency1 = util.table.deepcopy(data.raw.module["efficiency-module"])
local efficiency2 = util.table.deepcopy(data.raw.module["efficiency-module-2"])
local efficiency3 = util.table.deepcopy(data.raw.module["efficiency-module-3"])

local rampScaling = {
	min = settings.startup["sr-mom-ramping-min-scaling"].value,
	max = settings.startup["sr-mom-ramping-max-scaling"].value,
}

local package = {}

-- Small engine unit in the top left corner marking turbo modules: 12px of the 64px icon,
-- 4px in from the edges. Icon scale/shift work on a 32 unit icon, so halved values.
local turboBadge = {
	icon = "__base__/graphics/icons/engine-unit.png",
	icon_size = 64,
	scale = 24 / 64,
	shift = { -2, -4 },
}

-- A turbo module for every module type and tier in the module list, e.g. sr-mom-speed-turbo-2-0.
for _, module in pairs(getModuleList()) do
	-- Named by module list entry (e.g. "Clean Speed"), since several entries can share a category.
	local categoryName = momentum.categoryName(module.name)
	for tier = 1, 3 do
		local base = module["tier" .. tier]
		if base then
			local names = {
				name = tier == 1
					and { "sr-mom-name.turbo", categoryName }
					or  { "sr-mom-name.turbo-tier", categoryName, tostring(tier) },
				description = function(i) return { "sr-mom-description.turbo", categoryName, tostring(tier), tostring(i) } end,
			}
			local c, l = module.baseColour, module.lightColour
			local icons = getTintedIcons(tier, c.r, c.g, c.b, l.r, l.g, l.b)
			-- layers are base, lights, highlights, wires: the badge goes behind the lights
			table.insert(icons[1], 2, turboBadge)
			SetupRampMod(package, module.name .. "-turbo", base.category, base, tier,
				icons, nil, rampScaling,
				{ names = names, recipeSettings = "turbo" })
		end
	end
end
-- The original turbo modules (sr-mom-turbo-*) are renamed to speed-turbo in old saves by
-- the core mod's migrations/0.1.3-turbo-to-speed-turbo.json.

local clean1 = withAddedEffect(scaleModuleEffect(withoutEffect(speed1, "quality"), 0.65), "pollution", -0.05)
local clean2 = withAddedEffect(scaleModuleEffect(withoutEffect(speed2, "quality"), 0.65), "pollution", -0.05)
local clean3 = withAddedEffect(scaleModuleEffect(withoutEffect(speed3, "quality"), 0.65), "pollution", -0.05)

-- Clean's effects are a modified speed module, so its recipe is given the real speed module.
SetupRampMod(package, "clean",   "speed", clean1, 1, getTintedIcons(1, 0.3, 0.75, 0.45, 0.6, 1.0, 0.75), { prerequisites = {"speed-module"},                    unit = unit1 }, rampScaling, { recipeSettings = "turbo", recipeModules = speed1 })
SetupRampMod(package, "clean",   "speed", clean2, 2, getTintedIcons(2, 0.3, 0.75, 0.45, 0.6, 1.0, 0.75), { prerequisites = {"sr-mom-clean-1", "speed-module-2"}, unit = unit2 }, rampScaling, { recipeSettings = "turbo", recipeModules = speed2 })
SetupRampMod(package, "clean",   "speed", clean3, 3, getTintedIcons(3, 0.3, 0.75, 0.45, 0.6, 1.0, 0.75), { prerequisites = {"sr-mom-clean-2", "speed-module-3"}, unit = unit3 }, rampScaling, { recipeSettings = "turbo", recipeModules = speed3 })

SetupRampMod(package, "heat-up", "speed", { productivity1, speed1, efficiency1 }, 1, getTintedIcons(1, 0.7, 0.22, 0.05, 1.0, 1.0, 0.15), { prerequisites = {"speed-module", "productivity-module", "efficiency-module"},                            unit = { count = 50,  ingredients = {}, time = 30 } }, rampScaling, { recipeSettings = "turbo" }) -- This one is special, no research costs
SetupRampMod(package, "heat-up", "speed", { productivity2, speed2, efficiency2 }, 2, getTintedIcons(2, 0.7, 0.22, 0.05, 1.0, 1.0, 0.15), { prerequisites = {"sr-mom-heat-up-1", "speed-module-2", "productivity-module-2", "efficiency-module-2"},  unit = { count = 75,  ingredients = {}, time = 30 } }, rampScaling, { recipeSettings = "turbo" }) -- This one is special, no research costs
SetupRampMod(package, "heat-up", "speed", { productivity3, speed3, efficiency3 }, 3, getTintedIcons(3, 0.7, 0.22, 0.05, 1.0, 1.0, 0.15), { prerequisites = {"sr-mom-heat-up-2", "speed-module-3", "productivity-module-3", "efficiency-module-3"},  unit = { count = 300, ingredients = {}, time = 60 } }, rampScaling, { recipeSettings = "turbo" }) -- This one is special, no research costs

-- Catalyst moved to its own mod (Momentum Modules - Catalytic).

data:extend(package)
