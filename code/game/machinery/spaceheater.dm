/obj/machinery/space_heater
    anchored = 0
    density = 1
    icon = 'icons/obj/atmos.dmi'
    icon_state = "sheater0"
    name = "space heater"
    desc = "Made by Space Amish using traditional space techniques, this heater is guaranteed not to set the station on fire."
    max_integrity = 250
    armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 10)
    var/obj/item/stock_parts/cell/cell
    var/on = 0
    var/open = 0
    var/set_temperature = 50		// in celcius, add T0C for kelvin
    var/heating_power = 40000

/obj/machinery/space_heater/get_cell()
    return cell

/obj/machinery/space_heater/New()
    ..()
    cell = new /obj/item/stock_parts/cell(src)
    update_icon()
    return

/obj/machinery/space_heater/Destroy()
    QDEL_NULL(cell)
    return ..()

/obj/machinery/space_heater/update_icon()
    overlays.Cut()
    icon_state = "sheater[on]"
    if(open)
        overlays  += "sheater-open"
    return

/obj/machinery/space_heater/examine(mob/user)
    . = ..()
    . += "The heater is [on ? "on" : "off"] and the hatch is [open ? "open" : "closed"]."
    if(open)
        . += "The power cell is [cell ? "installed" : "missing"]."
    else
        . += "The charge meter reads [cell ? round(cell.percent(),1) : 0]%"

/obj/machinery/space_heater/emp_act(severity)
    if(stat & (BROKEN|NOPOWER))
        ..(severity)
        return
    if(cell)
        cell.emp_act(severity)
    ..(severity)

/obj/machinery/space_heater/attackby(obj/item/I, mob/user, params)
    if(istype(I, /obj/item/stock_parts/cell))
        if(open)
            if(cell)
                to_chat(user, "There is already a power cell inside.")
                return
            else
                // insert cell
                var/obj/item/stock_parts/cell/C = user.get_active_hand()
                if(istype(C))
                    if(user.drop_item())
                        cell = C
                        C.forceMove(src)
                        C.add_fingerprint(user)

                        user.visible_message("<span class='notice'>[user] inserts a power cell into [src].</span>", "<span class='notice'>You insert the power cell into [src].</span>")
        else
            to_chat(user, "The hatch must be open to insert a power cell.")
            return

    else
        return ..()

/obj/machinery/space_heater/screwdriver_act(mob/user, obj/item/I)
    . = TRUE
    if(!I.use_tool(src, user, 0, volume = I.tool_volume))
        return
    open = !open
    if(open)
        SCREWDRIVER_OPEN_PANEL_MESSAGE
    else
        SCREWDRIVER_CLOSE_PANEL_MESSAGE
    update_icon()
    if(!open && user.machine == src)
        user << browse(null, "window=spaceheater")
        user.unset_machine()

/obj/machinery/space_heater/attack_hand(mob/user as mob)
    src.add_fingerprint(user)
    interact(user)

/obj/machinery/space_heater/interact(mob/user as mob)
    if(open)
        var/dat
        dat = "Power cell: "
        if(cell)
            dat += "<A href='byond://?src=[UID()];op=cellremove'>Installed</A><BR>"
        else
            dat += "<A href='byond://?src=[UID()];op=cellinstall'>Removed</A><BR>"

        dat += "Power Level: [cell ? round(cell.percent(),1) : 0]%<BR><BR>"

        dat += "Set Temperature: "

        dat += "<A href='?src=[UID()];op=temp;val=-5'>-</A>"

        dat += " [set_temperature]&deg;C "
        dat += "<A href='?src=[UID()];op=temp;val=5'>+</A><BR>"

        user.set_machine(src)
        user << browse("<HEAD><TITLE>Space Heater Control Panel</TITLE></HEAD><TT>[dat]</TT>", "window=spaceheater")
        onclose(user, "spaceheater")

    else
        on = !on
        user.visible_message("<span class='notice'>[user] switches [on ? "on" : "off"] [src].</span>","<span class='notice'>You switch [on ? "on" : "off"] [src].</span>")
        update_icon()
    return


/obj/machinery/space_heater/Topic(href, href_list)
    if(..())
        return 1
    if((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
        usr.set_machine(src)

        switch(href_list["op"])

            if("temp")
                var/value = text2num(href_list["val"])

                // limit to 20-90 degC
                set_temperature = dd_range(0, 90, set_temperature + value)

            if("cellremove")
                if(open && cell && !usr.get_active_hand())
                    cell.update_icon()
                    usr.put_in_hands(cell)
                    cell.add_fingerprint(usr)
                    cell = null
                    usr.visible_message("<span class='notice'>[usr] removes the power cell from [src].</span>", "<span class='notice'>You remove the power cell from [src].</span>")


            if("cellinstall")
                if(open && !cell)
                    var/obj/item/stock_parts/cell/C = usr.get_active_hand()
                    if(istype(C))
                        usr.drop_item()
                        cell = C
                        C.loc = src
                        C.add_fingerprint(usr)

                        usr.visible_message("<span class='notice'>[usr] inserts a power cell into [src].</span>", "<span class='notice'>You insert the power cell into [src].</span>")

        updateDialog()
    else
        usr << browse(null, "window=spaceheater")
        usr.unset_machine()
    return



/obj/machinery/space_heater/process()
    if(on)
        if(cell && cell.charge > 0)
            var/turf/simulated/L = loc
            if(istype(L))
                var/datum/gas_mixture/env = L.return_air()
                if(env.temperature != set_temperature + T0C)
                    var/transfer_moles = 0.25 * env.total_moles()

                    var/datum/gas_mixture/removed = env.remove(transfer_moles)

                    if(removed)
                        var/heat_capacity = removed.heat_capacity()

                        if(heat_capacity) // Added check to avoid divide by zero (oshi-) runtime errors -- TLE
                            if(removed.temperature < set_temperature + T0C)
                                removed.temperature = min(removed.temperature + heating_power/heat_capacity, 1000) // Added min() check to try and avoid wacky superheating issues in low gas scenarios -- TLE
                            else
                                removed.temperature = max(removed.temperature - heating_power/heat_capacity, TCMB)
                            cell.use(heating_power/20000)
                    env.merge(removed)
                    air_update_turf()
        else
            on = 0
            update_icon()
