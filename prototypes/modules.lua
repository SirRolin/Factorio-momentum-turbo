local momentum = require("__sir-rolins-momentum-modules__/lib/momentum")
local moduleList = require("__sir-rolins-module-lib__/lib/module_list")
local getTintedIcons = require("__sir-rolins-module-lib__/lib/icons").getTintedIcons
local SetupRampMod = momentum.SetupRampMod

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
for _, module in pairs(moduleList.get()) do
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
				{ names = names, recipeSettings = "turbo",
				  sortKey = moduleList.rowOrder(module.series .. "-turbo", module.family) })
		end
	end
end
-- The original turbo modules (sr-mom-turbo-*) are renamed to speed-turbo in old saves by
-- the core mod's migrations/0.1.3-turbo-to-speed-turbo.json.

-- The hardcoded Clean modules (sr-mom-clean-*) are gone. Clean Modules registers its families
-- with the module library, so the loop above now generates a Clean <type> Turbo for each of them
-- when that mod is installed, instead of this mod carrying its own one-off clean speed module.
-- Old saves are migrated by migrations/0.2.0-clean-to-clean-speed-turbo.json -- kept here rather
-- than in the core, since this mod is the one that owned those prototypes.

SetupRampMod(package, "heat-up", "speed", { productivity1, speed1, efficiency1 }, 1, getTintedIcons(1, 0.7, 0.22, 0.05, 1.0, 1.0, 0.15), { prerequisites = {"speed-module", "productivity-module", "efficiency-module"},                            unit = { count = 50,  ingredients = {}, time = 30 } }, rampScaling, { recipeSettings = "turbo" }) -- This one is special, no research costs
SetupRampMod(package, "heat-up", "speed", { productivity2, speed2, efficiency2 }, 2, getTintedIcons(2, 0.7, 0.22, 0.05, 1.0, 1.0, 0.15), { prerequisites = {"sr-mom-heat-up-1", "speed-module-2", "productivity-module-2", "efficiency-module-2"},  unit = { count = 75,  ingredients = {}, time = 30 } }, rampScaling, { recipeSettings = "turbo" }) -- This one is special, no research costs
SetupRampMod(package, "heat-up", "speed", { productivity3, speed3, efficiency3 }, 3, getTintedIcons(3, 0.7, 0.22, 0.05, 1.0, 1.0, 0.15), { prerequisites = {"sr-mom-heat-up-2", "speed-module-3", "productivity-module-3", "efficiency-module-3"},  unit = { count = 300, ingredients = {}, time = 60 } }, rampScaling, { recipeSettings = "turbo" }) -- This one is special, no research costs

-- Catalyst moved to its own mod (Momentum Modules - Catalytic).

data:extend(package)
