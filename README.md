# Based Lighting Configs

[Nexus Mirror](https://www.nexusmods.com/skyrimspecialedition/mods/136870)
[Github Mirror](https://github.com/cyberrumor/based-lighting-configs)

## Requirements

- [SKSE](https://skse.silverlock.org/)
- [Address Library for SKSE Plugins](https://www.nexusmods.com/skyrimspecialedition/mods/32444)
- [powerofthree's tweaks](https://www.nexusmods.com/skyrimspecialedition/mods/51073)
- [Community Shaders](https://www.nexusmods.com/skyrimspecialedition/mods/86492)
- [Light Limit Fix](https://www.nexusmods.com/skyrimspecialedition/mods/99548)
- [Light Placer](https://www.nexusmods.com/skyrimspecialedition/mods/127557)

## Scope of Light Placer Configs

You can install the CLI tool `jq` and run this command to generate this list:

Windows:
```
type Data\lightplacer\based-lighting-configs\* | jq '.[].models' | sort /unique
```

Linux:
```
cat Data/lightplacer/based-lighting-configs/* | jq '.[].models' | sort | uniq
```

## Further Reading

* [Light Placer Wiki](https://github.com/powerof3/LightPlacer/wiki)
* [Community Shaders Wiki](
    https://github.com/doodlum/skyrim-community-shaders/wiki
  )

## Development Setup

Based Lighting uses pre-commit hooks to generate, format, and validate configs
and ModuleConfig.xml.

```
# ubuntu
sudo apt install pre-commit jq libxml2-utils
# arch
sudo pacman -S pre-commit jq libxml2
# all
pre-commit install
```

## Thanks

Thanks a bunch to powerofthree for making Light Placer so I could write configs
for it. It's been fun to work with.
