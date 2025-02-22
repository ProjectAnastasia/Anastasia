/* Utility Closets
 * Contains:
 *		Emergency Closet
 *		Fire Closet
 *		Tool Closet
 *		Radiation Closet
 *		Bombsuit Closet
 *		Hydrant
 *		First Aid
 */

/*
 * Emergency Closet
 */
/obj/structure/closet/emcloset
    name = "emergency closet"
    desc = "It's a storage unit for emergency breathmasks and o2 tanks."
    icon_state = "emergency"
    icon_closed = "emergency"
    icon_opened = "emergencyopen"

/obj/structure/closet/emcloset/anchored
    anchored = TRUE

/obj/structure/closet/emcloset/populate_contents()
    switch(pickweight(list("small" = 55, "aid" = 25, "tank" = 10, "both" = 10, "nothing" = 0, "delete" = 0)))
        if("small")
            new /obj/item/tank/internals/emergency_oxygen(src)
            new /obj/item/tank/internals/emergency_oxygen(src)
            new /obj/item/clothing/mask/breath(src)
            new /obj/item/clothing/mask/breath(src)
        if("aid")
            new /obj/item/tank/internals/emergency_oxygen(src)
            new /obj/item/storage/toolbox/emergency(src)
            new /obj/item/clothing/mask/breath(src)
            new /obj/item/storage/firstaid/o2(src)
        if("tank")
            new /obj/item/tank/internals/emergency_oxygen/engi(src)
            new /obj/item/clothing/mask/breath(src)
            new /obj/item/tank/internals/emergency_oxygen/engi(src)
            new /obj/item/clothing/mask/breath(src)
        if("both")
            new /obj/item/storage/toolbox/emergency(src)
            new /obj/item/tank/internals/emergency_oxygen/engi(src)
            new /obj/item/clothing/mask/breath(src)
            new /obj/item/storage/firstaid/o2(src)
        if("nothing")
            // doot

        // teehee - Ah, tg coders...
        if("delete")
            qdel(src)

        //If you want to re-add fire, just add "fire" = 15 to the pick list.
        /*if("fire")
            new /obj/structure/closet/firecloset(src.loc)
            qdel(src)*/

/obj/structure/closet/emcloset/legacy/populate_contents()
    new /obj/item/tank/internals/oxygen(src)
    new /obj/item/clothing/mask/gas(src)

/*
 * Fire Closet
 */
/obj/structure/closet/firecloset
    name = "fire-safety closet"
    desc = "It's a storage unit for fire-fighting supplies."
    icon_state = "firecloset"
    icon_closed = "firecloset"
    icon_opened = "fireclosetopen"

/obj/structure/closet/firecloset/populate_contents()
    new /obj/item/extinguisher(src)
    new /obj/item/clothing/suit/fire/firefighter(src)
    new /obj/item/clothing/mask/gas(src)
    new /obj/item/tank/internals/oxygen/red(src)
    new /obj/item/clothing/head/hardhat/red(src)

/obj/structure/closet/firecloset/full/populate_contents()
    new /obj/item/extinguisher(src)
    new /obj/item/clothing/suit/fire/firefighter(src)
    new /obj/item/clothing/mask/gas(src)
    new /obj/item/flashlight(src)
    new /obj/item/tank/internals/oxygen/red(src)
    new /obj/item/clothing/head/hardhat/red(src)


/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
    name = "tool closet"
    desc = "It's a storage unit for tools."
    icon_state = "toolcloset"
    icon_closed = "toolcloset"
    icon_opened = "toolclosetopen"

/obj/structure/closet/toolcloset/populate_contents()
    if(prob(40))
        new /obj/item/clothing/suit/storage/hazardvest(src)
    if(prob(70))
        new /obj/item/flashlight(src)
    if(prob(70))
        new /obj/item/screwdriver(src)
    if(prob(70))
        new /obj/item/wrench(src)
    if(prob(70))
        new /obj/item/weldingtool(src)
    if(prob(70))
        new /obj/item/crowbar(src)
    if(prob(70))
        new /obj/item/wirecutters(src)
    if(prob(70))
        new /obj/item/t_scanner(src)
    if(prob(20))
        new /obj/item/storage/belt/utility(src)
    if(prob(30))
        new /obj/item/stack/cable_coil/random(src)
    if(prob(30))
        new /obj/item/stack/cable_coil/random(src)
    if(prob(30))
        new /obj/item/stack/cable_coil/random(src)
    if(prob(20))
        new /obj/item/multitool(src)
    if(prob(5))
        new /obj/item/clothing/gloves/color/yellow(src)
    if(prob(40))
        new /obj/item/clothing/head/hardhat(src)


/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
    name = "radiation suit closet"
    desc = "It's a storage unit for rad-protective suits."
    icon_state = "radsuitcloset"
    icon_opened = "toolclosetopen"
    icon_closed = "radsuitcloset"

/obj/structure/closet/radiation/populate_contents()
    new /obj/item/geiger_counter(src)
    new /obj/item/clothing/suit/radiation(src)
    new /obj/item/clothing/head/radiation(src)

/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
    name = "\improper EOD closet"
    desc = "It's a storage unit for explosion-protective suits."
    icon_state = "bombsuit"
    icon_closed = "bombsuit"
    icon_opened = "bombsuitopen"

/obj/structure/closet/bombcloset/populate_contents()
    new /obj/item/clothing/suit/bomb_suit( src )
    new /obj/item/clothing/under/color/black( src )
    new /obj/item/clothing/shoes/black( src )
    new /obj/item/clothing/head/bomb_hood( src )


/obj/structure/closet/bombclosetsecurity
    name = "\improper EOD closet"
    desc = "It's a storage unit for explosion-protective suits."
    icon_state = "bombsuitsec"
    icon_closed = "bombsuitsec"
    icon_opened = "bombsuitsecopen"

/obj/structure/closet/bombclosetsecurity/populate_contents()
    new /obj/item/clothing/suit/bomb_suit/security( src )
    new /obj/item/clothing/under/rank/security( src )
    new /obj/item/clothing/shoes/brown( src )
    new /obj/item/clothing/head/bomb_hood/security( src )

/*
 * Hydrant
 */
/obj/structure/closet/hydrant //wall mounted fire closet
    name = "fire-safety closet"
    desc = "It's a storage unit for fire-fighting supplies."
    icon_state = "hydrant"
    icon_closed = "hydrant"
    icon_opened = "hydrant_open"
    anchored = 1
    density = 0
    wall_mounted = 1

/obj/structure/closet/hydrant/populate_contents()
    new /obj/item/clothing/suit/fire/firefighter(src)
    new /obj/item/clothing/mask/gas(src)
    new /obj/item/flashlight(src)
    new /obj/item/tank/internals/oxygen/red(src)
    new /obj/item/extinguisher(src)
    new /obj/item/clothing/head/hardhat/red(src)

/*
 * First Aid
 */
/obj/structure/closet/medical_wall //wall mounted medical closet
    name = "first-aid closet"
    desc = "It's wall-mounted storage unit for first aid supplies."
    icon_state = "medical_wall"
    icon_closed = "medical_wall"
    icon_opened = "medical_wall_open"
    anchored = 1
    density = 0
    wall_mounted = 1

/obj/structure/closet/medical_wall/update_icon()
    if(!opened)
        icon_state = icon_closed
    else
        icon_state = icon_opened
