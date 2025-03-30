#!/usr/bin/env python3
from string import Template

tmpl = """
switch(FEAT_STATIONS, SELF, sw_${name}_prepare, [
    STORE_TEMP(${style}, t_style),
]){return;}

item(FEAT_STATIONS, i_${name}){
    property {
        class: "BASE";
        classname: string(STR_GRF_NAME);
        name: string(STR_GRF_NAME);
        tile_flags: [
            bitmask(STAT_TILE_PYLON),
            bitmask(STAT_TILE_PYLON),
            bitmask(STAT_TILE_PYLON),
            bitmask(STAT_TILE_PYLON),
            bitmask(STAT_TILE_PYLON),
            bitmask(STAT_TILE_PYLON),
            bitmask(STAT_TILE_PYLON),
            bitmask(STAT_TILE_PYLON)
        ];
    }
    graphics {
        prepare_layout: sw_${name}_prepare();
        custom_spritesets: [s_fences_and_underlay];
        sprite_layouts: [${sprite_layouts}];
    }
}
"""

tmpl = Template(tmpl)

# remove old file
with open("generated/base_platforms.nml", "w") as f:
    f.write("")

for name in ("default", "nanaimo", "wooden"):
    for i in range(24):
        layouts = ["basic_x", "basic_y"]
        if i % 8 >= 4:
            layouts = ["basic_opp_x", "basic_opp_y"]
        with open("generated/base_platforms.nml", "a") as f:
            f.write(
                tmpl.substitute(
                    name=f"base_station_{name}_{i}",
                    style=str(i % 8 + (i // 8) * 16) + f"+ (id_base_platforms_{name} * id_base_platforms_size)",
                    sprite_layouts=", ".join(layouts),
                )
            )
