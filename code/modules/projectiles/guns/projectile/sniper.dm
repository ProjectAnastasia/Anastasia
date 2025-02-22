/obj/item/gun/projectile/automatic/sniper_rifle
    name = "sniper rifle"
    desc = "The kind of gun that will leave you crying for mummy before you even realise your leg's missing."
    icon_state = "sniper"
    item_state = "sniper"
    recoil = 2
    weapon_weight = WEAPON_HEAVY
    mag_type = /obj/item/ammo_box/magazine/sniper_rounds
    fire_sound = 'sound/weapons/gunshots/gunshot_sniper.ogg'
    magin_sound = 'sound/weapons/gun_interactions/batrifle_magin.ogg'
    magout_sound = 'sound/weapons/gun_interactions/batrifle_magout.ogg'
    fire_delay = 40
    burst_size = 1
    origin_tech = "combat=7"
    can_unsuppress = 1
    can_suppress = 1
    w_class = WEIGHT_CLASS_NORMAL
    zoomable = TRUE
    zoom_amt = 7 //Long range, enough to see in front of you, but no tiles behind you.
    slot_flags = SLOT_BACK
    actions_types = list()

/obj/item/gun/projectile/automatic/sniper_rifle/syndicate
    name = "syndicate sniper rifle"
    desc = "Syndicate flavoured sniper rifle, it packs quite a punch, a punch to your face."
    origin_tech = "combat=7;syndicate=6"

/obj/item/gun/projectile/automatic/sniper_rifle/syndicate/penetrator
    name = "syndicate penetrator sniper rifle"

/obj/item/gun/projectile/automatic/sniper_rifle/syndicate/penetrator/Initialize(mapload)
    . = ..()
    desc += " It comes loaded with a penetrator magazine, but can use different magazines."

    QDEL_NULL(magazine)
    magazine = new /obj/item/ammo_box/magazine/sniper_rounds/penetrator(src)

/obj/item/gun/projectile/automatic/sniper_rifle/update_icon()
    if(magazine)
        icon_state = "sniper-mag"
    else
        icon_state = "sniper"

/obj/item/gun/projectile/automatic/sniper_rifle/compact //holds very little ammo, lacks zooming, and bullets are primarily damage dealers, but the gun lacks the downsides of the full size rifle
    name = "compact sniper rifle"
    desc = "A compact, unscoped version of the standard issue syndicate sniper rifle. Still capable of sending people crying."
    icon_state = "snipercompact"
    recoil = 0
    weapon_weight = WEAPON_LIGHT
    fire_delay = 0
    mag_type = /obj/item/ammo_box/magazine/sniper_rounds/compact
    can_unsuppress = FALSE
    can_suppress = FALSE
    zoomable = FALSE

/obj/item/gun/projectile/automatic/sniper_rifle/compact/update_icon()
    if(magazine)
        icon_state = "snipercompact-mag"
    else
        icon_state = "snipercompact"

//Normal Boolets
/obj/item/ammo_box/magazine/sniper_rounds
    name = "sniper rounds (.50)"
    icon_state = ".50mag"
    origin_tech = "combat=6;syndicate=2"
    ammo_type = /obj/item/ammo_casing/point50
    max_ammo = 6
    caliber = ".50"

/obj/item/ammo_box/magazine/sniper_rounds/update_icon()
    if(ammo_count())
        icon_state = "[initial(icon_state)]-ammo"
    else
        icon_state = "[initial(icon_state)]"

/obj/item/ammo_casing/point50
    desc = "A .50 bullet casing."
    caliber = ".50"
    projectile_type = /obj/item/projectile/bullet/sniper
    muzzle_flash_strength = MUZZLE_FLASH_STRENGTH_STRONG
    muzzle_flash_range = MUZZLE_FLASH_RANGE_STRONG
    icon_state = ".50"

/obj/item/projectile/bullet/sniper
    damage = 70
    stun = 5
    weaken = 5
    armour_penetration = 50

/obj/item/ammo_box/magazine/sniper_rounds/antimatter
    name = "sniper rounds (Antimatter)"
    desc = "Antimatter sniper rounds, for when you really don't like something."
    icon_state = "antimatter"
    ammo_type = /obj/item/ammo_casing/antimatter

/obj/item/ammo_casing/antimatter
    desc = "A .50 antimatter bullet casing, designed to cause massive damage to whatever is hit."
    caliber = ".50"
    projectile_type = /obj/item/projectile/bullet/sniper/antimatter
    icon_state = ".50"

/obj/item/projectile/bullet/sniper/antimatter
    name = "antimatter bullet"
    dismemberment = 50

/obj/item/projectile/bullet/sniper/antimatter/on_hit(atom/target, blocked = 0, hit_zone)
    if((blocked != 100) && (!ismob(target)))
        target.ex_act(rand(1,2))

    return ..()

//Sleepy ammo
/obj/item/ammo_box/magazine/sniper_rounds/soporific
    name = "sniper rounds (Zzzzz)"
    desc = "Soporific sniper rounds, designed for happy days and dead quiet nights..."
    icon_state = "soporific"
    origin_tech = "combat=6;syndicate=3"
    ammo_type = /obj/item/ammo_casing/soporific
    max_ammo = 3

/obj/item/ammo_casing/soporific
    desc = "A .50 bullet casing, specialised in sending the target to sleep, instead of hell."
    caliber = ".50"
    projectile_type = /obj/item/projectile/bullet/sniper/soporific
    icon_state = ".50"
    harmful = FALSE

/obj/item/projectile/bullet/sniper/soporific
    armour_penetration = 0
    nodamage = 1
    stun = 0
    weaken = 0

/obj/item/projectile/bullet/sniper/soporific/on_hit(atom/target, blocked = 0, hit_zone)
    if((blocked != 100) && istype(target, /mob/living))
        var/mob/living/L = target
        L.SetSleeping(20)

    return ..()



//hemorrhage ammo
/obj/item/ammo_box/magazine/sniper_rounds/haemorrhage
    name = "sniper rounds (Bleed)"
    desc = "Haemorrhage sniper rounds, leaves your target in a pool of crimson pain"
    icon_state = "haemorrhage"
    ammo_type = /obj/item/ammo_casing/haemorrhage
    max_ammo = 5

/obj/item/ammo_casing/haemorrhage
    desc = "A .50 bullet casing, specialised in causing massive bloodloss"
    caliber = ".50"
    projectile_type = /obj/item/projectile/bullet/sniper/haemorrhage
    icon_state = ".50"

/obj/item/projectile/bullet/sniper/haemorrhage
    armour_penetration = 25
    damage = 45
    stun = 3
    weaken = 3

/obj/item/projectile/bullet/sniper/haemorrhage/on_hit(atom/target, blocked = 0, hit_zone)
    if((blocked != 100) && iscarbon(target))
        var/mob/living/carbon/C = target
        C.bleed(150)

    return ..()

//penetrator ammo
/obj/item/ammo_box/magazine/sniper_rounds/penetrator
    name = "sniper rounds (penetrator)"
    desc = "An extremely powerful round capable of passing straight through cover and anyone unfortunate enough to be behind it."
    icon_state = "penetrator"
    ammo_type = /obj/item/ammo_casing/penetrator
    origin_tech = "combat=6;syndicate=3"
    max_ammo = 5

/obj/item/ammo_casing/penetrator
    desc = "A .50 caliber penetrator round casing."
    caliber = ".50"
    projectile_type = /obj/item/projectile/bullet/sniper/penetrator
    icon_state = ".50"

/obj/item/projectile/bullet/sniper/penetrator
    icon_state = "gauss"
    name = "penetrator round"
    damage = 60
    forcedodge = 1
    stun = 0
    dismemberment = 0
    weaken = 0

//compact ammo
/obj/item/ammo_box/magazine/sniper_rounds/compact
    name = "sniper rounds (compact)"
    desc = "An extremely powerful round capable of inflicting massive damage on a target."
    ammo_type = /obj/item/ammo_casing/compact
    max_ammo = 4

/obj/item/ammo_casing/compact
    desc = "A .50 caliber compact round casing."
    caliber = ".50"
    projectile_type = /obj/item/projectile/bullet/sniper //Same as the base sniper bullet, but can't be reloaded with any fancy sniper ammo in the mag, which only holds 4
    muzzle_flash_strength = MUZZLE_FLASH_STRENGTH_NORMAL
    muzzle_flash_range = MUZZLE_FLASH_RANGE_NORMAL
    icon_state = ".50"


//toy magazine
/obj/item/ammo_box/magazine/toy/sniper_rounds
    name = "donksoft Sniper magazine"
    icon_state = ".50mag"
    ammo_type = /obj/item/ammo_casing/caseless/foam_dart/sniper/riot
    max_ammo = 6
    caliber = "foam_force_sniper"

/obj/item/ammo_box/magazine/toy/sniper_rounds/update_icon()
    overlays.Cut()

    var/ammo = ammo_count()
    if(ammo && istype(contents[contents.len], /obj/item/ammo_casing/caseless/foam_dart/sniper/riot))
        overlays += image('icons/obj/ammo.dmi', icon_state = ".50mag-r")
    else if(ammo)
        overlays += image('icons/obj/ammo.dmi', icon_state = ".50mag-f")
    else
        icon_state = "[initial(icon_state)]"
