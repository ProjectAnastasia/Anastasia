/obj/item/gun/energy/gun
    name = "energy gun"
    desc = "An E-07 energy gun manufactured by Shellguard Munitions. The fire selector has 'kill' and 'disable' settings."
    icon_state = "energy"
    item_state = null	//so the human update icon uses the icon_state instead.
    ammo_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser)
    origin_tech = "combat=4;magnets=3"
    modifystate = 2
    can_flashlight = 1
    flight_x_offset = 20
    flight_y_offset = 10
    shaded_charge = TRUE

/obj/item/gun/energy/gun/detailed_examine()
    return "This is an energy weapon. Most energy weapons can fire through windows harmlessly. To switch between stun and lethal, click the weapon \
            in your hand. To recharge this weapon, use a weapon recharger."

/obj/item/gun/energy/gun/cyborg
    desc = "An energy-based laser gun that draws power from the cyborg's internal energy cell directly. So this is what freedom looks like?"

/obj/item/gun/energy/gun/cyborg/newshot()
    ..()
    robocharge()

/obj/item/gun/energy/gun/cyborg/emp_act()
    return

/obj/item/gun/energy/gun/mini
    name = "miniature energy gun"
    desc = "A small, pistol-sized energy gun with a built-in flashlight. It has two settings: disable and kill."
    icon_state = "mini"
    w_class = WEIGHT_CLASS_SMALL
    ammo_x_offset = 2
    charge_sections = 3
    can_flashlight = 0 // Can't attach or detach the flashlight, and override it's icon update
    actions_types = list(/datum/action/item_action/toggle_gunlight)
    shaded_charge = FALSE
    can_holster = TRUE  // Pistol sized, so it should fit into a holster

/obj/item/gun/energy/gun/mini/Initialize(mapload, ...)
    gun_light = new /obj/item/flashlight/seclite(src)
    . = ..()
    cell.maxcharge = 600
    cell.charge = 600

/obj/item/gun/energy/gun/mini/update_icon()
    ..()
    if(gun_light && gun_light.on)
        overlays += "mini-light"

/obj/item/gun/energy/gun/hos
    name = "\improper X-01 MultiPhase Energy Gun"
    desc = "This is an expensive, modern recreation of an antique laser gun. This gun has several unique firemodes, but lacks the ability to recharge over time."
    icon_state = "hoslaser"
    origin_tech = null
    force = 10
    ammo_type = list(/obj/item/ammo_casing/energy/electrode/hos, /obj/item/ammo_casing/energy/laser/hos, /obj/item/ammo_casing/energy/disabler)
    ammo_x_offset = 4
    resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
    shaded_charge = FALSE
    can_holster = TRUE

/obj/item/gun/energy/gun/blueshield
    name = "advanced stun revolver"
    desc = "An advanced stun revolver with the capacity to shoot both electrodes and lasers."
    icon_state = "bsgun"
    item_state = "gun"
    force = 7
    ammo_type = list(/obj/item/ammo_casing/energy/electrode/hos, /obj/item/ammo_casing/energy/laser/hos)
    ammo_x_offset = 1
    shaded_charge = TRUE
    can_holster = TRUE

/obj/item/gun/energy/gun/blueshield/pdw9
    name = "PDW-9 taser pistol"
    desc = "A military grade sidearm, used by many militia forces throughout the local sector."
    icon_state = "pdw9pistol"

/obj/item/gun/energy/gun/turret
    name = "hybrid turret gun"
    desc = "A heavy hybrid energy cannon with two settings: Stun and kill."
    icon_state = "turretlaser"
    item_state = "turretlaser"
    slot_flags = null
    w_class = WEIGHT_CLASS_HUGE
    ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser)
    weapon_weight = WEAPON_HEAVY
    can_flashlight = 0
    trigger_guard = TRIGGER_GUARD_NONE
    ammo_x_offset = 2
    shaded_charge = FALSE

/obj/item/gun/energy/gun/nuclear
    name = "advanced energy gun"
    desc = "An energy gun with an experimental miniaturized nuclear reactor that automatically charges the internal power cell."
    icon_state = "nucgun"
    item_state = "nucgun"
    origin_tech = "combat=4;magnets=4;powerstorage=4"
    var/fail_tick = 0
    charge_delay = 5
    can_charge = 0
    ammo_x_offset = 1
    ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser, /obj/item/ammo_casing/energy/disabler)
    selfcharge = 1
    shaded_charge = FALSE

/obj/item/gun/energy/gun/nuclear/detailed_examine()
    return "This is an energy weapon. Most energy weapons can fire through windows harmlessly. To switch between stun and lethal, click the weapon \
            in your hand. Unlike most weapons, this weapon recharges itself."
