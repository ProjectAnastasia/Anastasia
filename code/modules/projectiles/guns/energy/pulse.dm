/obj/item/gun/energy/pulse
    name = "pulse rifle"
    desc = "A heavy-duty, multifaceted energy rifle with three modes. Preferred by front-line combat personnel."
    icon_state = "pulse"
    item_state = null
    w_class = WEIGHT_CLASS_BULKY
    can_holster = FALSE
    force = 10
    flags =  CONDUCT
    slot_flags = SLOT_BACK
    ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse, /obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser)
    cell_type = /obj/item/stock_parts/cell/pulse

/obj/item/gun/energy/pulse/emp_act(severity)
    return

/obj/item/gun/energy/pulse/cyborg

/obj/item/gun/energy/pulse/cyborg/newshot()
    ..()
    robocharge()

/obj/item/gun/energy/pulse/carbine
    name = "pulse carbine"
    desc = "A compact variant of the pulse rifle with less firepower but easier storage."
    w_class = WEIGHT_CLASS_NORMAL
    slot_flags = SLOT_BELT
    icon_state = "pulse_carbine"
    item_state = "pulse"
    cell_type = /obj/item/stock_parts/cell/pulse/carbine
    can_flashlight = 1
    flight_x_offset = 18
    flight_y_offset = 12

/obj/item/gun/energy/pulse/pistol
    name = "pulse pistol"
    desc = "A pulse rifle in an easily concealed handgun package with low capacity."
    w_class = WEIGHT_CLASS_SMALL
    slot_flags = SLOT_BELT
    icon_state = "pulse_pistol"
    item_state = "gun"
    can_holster = TRUE
    cell_type = /obj/item/stock_parts/cell/pulse/pistol
    can_charge = 0

/obj/item/gun/energy/pulse/destroyer
    name = "pulse destroyer"
    desc = "A heavy-duty, pulse-based energy weapon."
    cell_type = /obj/item/stock_parts/cell/infinite
    ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse)

/obj/item/gun/energy/pulse/destroyer/attack_self(mob/living/user)
    to_chat(user, "<span class='danger'>[name] has three settings, and they are all DESTROY.</span>")

/obj/item/gun/energy/pulse/destroyer/annihilator
    name = "pulse ANNIHILATOR"
    desc = "For when the situation calls for a little more than a pulse destroyer."
    ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter/pulse)

/obj/item/gun/energy/pulse/pistol/m1911
    name = "\improper M1911-P"
    desc = "A compact pulse core in a classic handgun frame for Nanotrasen officers. It's not the size of the gun, it's the size of the hole it puts through people."
    icon_state = "m1911"
    item_state = "gun"
    can_holster = TRUE
    cell_type = /obj/item/stock_parts/cell/infinite

/obj/item/gun/energy/pulse/turret
    name = "pulse turret gun"
    desc = "A heavy, turret-mounted pulse energy cannon."
    icon_state = "turretlaser"
    item_state = "turretlaser"
    slot_flags = null
    w_class = WEIGHT_CLASS_HUGE
    ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser/pulse)
    weapon_weight = WEAPON_MEDIUM
    can_flashlight = 0
    trigger_guard = TRIGGER_GUARD_NONE
    ammo_x_offset = 2
