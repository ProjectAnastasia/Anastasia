/obj/structure/closet/secure_closet/bar
    name = "Booze cabinet"
    req_access = list(ACCESS_BAR)
    icon_state = "cabinetdetective_locked"
    icon_closed = "cabinetdetective"
    icon_locked = "cabinetdetective_locked"
    icon_opened = "cabinetdetective_open"
    icon_broken = "cabinetdetective_broken"
    icon_off = "cabinetdetective_broken"
    resistance_flags = FLAMMABLE
    max_integrity = 70
    open_sound = 'sound/machines/wooden_closet_open.ogg'
    close_sound = 'sound/machines/wooden_closet_close.ogg'
    open_sound_volume = 25
    close_sound_volume = 50

/obj/structure/closet/secure_closet/bar/populate_contents()
    new /obj/item/reagent_containers/food/drinks/cans/beer(src)
    new /obj/item/reagent_containers/food/drinks/cans/beer(src)
    new /obj/item/reagent_containers/food/drinks/cans/beer(src)
    new /obj/item/reagent_containers/food/drinks/cans/beer(src)
    new /obj/item/reagent_containers/food/drinks/cans/beer(src)
    new /obj/item/reagent_containers/food/drinks/cans/beer(src)
    new /obj/item/reagent_containers/food/drinks/cans/beer(src)
    new /obj/item/reagent_containers/food/drinks/cans/beer(src)
    new /obj/item/reagent_containers/food/drinks/cans/beer(src)
    new /obj/item/reagent_containers/food/drinks/cans/beer(src)

/obj/structure/closet/secure_closet/bar/update_icon()
    if(broken)
        icon_state = icon_broken
    else
        if(!opened)
            if(locked)
                icon_state = icon_locked
            else
                icon_state = icon_closed
        else
            icon_state = icon_opened
