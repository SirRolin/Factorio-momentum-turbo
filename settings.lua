local momentumSettings = require("__sir-rolins-momentum-modules__/lib/settings")

local settingsPackage = {
    {
        type = "double-setting",
        name = "sr-mom-ramping-max-scaling",
        setting_type = "startup",
        default_value = 1.5,
        minimum_value = 0.0,
        maximum_value = 3.0
    },
    {
        type = "double-setting",
        name = "sr-mom-ramping-min-scaling",
        setting_type = "startup",
        default_value = 0.5,
        minimum_value = 0.0,
        maximum_value = 3.0
    }
}

-- Shared by every module in this mod (the <module>-turbos, clean and heat-up),
-- added on top of the base module(s) each one is made from.
momentumSettings.addRecipeSettings(settingsPackage, "turbo", "Turbo mod", {
    items = {
        { item = "engine-unit", amount = 1 },
        { item = "electronic-circuit",   amount = 2 },
    },
    fluid = { 
        fluid = "lubricant",
        amount = 25 
    },
})

data:extend(settingsPackage)
