# Momentum Modules - Turbo

A [Factorio](https://factorio.com) mod that adds ramping momentum modules: a Turbo version of every
module type, plus Clean and Heat Up.

Turbo modules start weak and get stronger the longer a machine keeps running, reaching their full
strength at 10 momentum. Stop the machine and the momentum decays again.

## Modules

| Module | Effect |
| --- | --- |
| `<type>` Turbo (tiers 1-3) | A ramping version of every module type in the module list. Effects scale from the min scaling setting at 0 momentum to the max scaling setting at 10. |
| Clean (tiers 1-3) | A weaker speed module with no quality penalty and slightly less pollution. Maxes out at 65% of the matching speed module, times scaling. |
| Heat Up (tiers 1-3) | A ramping mix of productivity and speed: 50% + 5% per momentum of both, times scaling / 2. |

## Startup settings

| Setting | Default | Description |
| --- | --- | --- |
| Modules Max Scaling | 1.5 | How strong the modules are at 10 momentum, compared to vanilla modules. |
| Modules Min Scaling | 0.5 | How strong the modules are at 0 momentum, compared to vanilla modules. |
| Turbo mod recipe ingredients | 1 engine unit, 2 electronic circuits, 25 lubricant | Extra ingredients added to every recipe in this mod, on top of the base module it is made from. |

## Dependencies

- Factorio 2.0+
- [Momentum Modules](https://github.com/SirRolin/Factorio-momentum-modules) 0.2.0+ — the library mod
  that provides the momentum tracking, module generation and icon tinting used here.
- Optional: Space Age, Quality

## Related mods

- [Momentum Modules](https://github.com/SirRolin/Factorio-momentum-modules) (library)
- [Momentum Modules - Catalytic](https://github.com/SirRolin/Factorio-momentum-catalytic)
- [Momentum Modules - Threshold](https://github.com/SirRolin/Factorio-momentum-threshold)
- [Clean Modules](https://github.com/SirRolin/Factorio-clean-modules)

## Installation

Clone or copy this folder into your Factorio `mods` directory as
`sir-rolins-momentum-turbo_<version>`, or install it from the in-game mod portal.
