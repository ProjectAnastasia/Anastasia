/obj/effect/proc_holder/spell/targeted/summonitem
    name = "Instant Summons"
    desc = "This spell can be used to recall a previously marked item to your hand from anywhere in the universe."
    school = "transmutation"
    charge_max = 100
    clothes_req = 0
    invocation = "GAR YOK"
    invocation_type = "whisper"
    range = -1
    level_max = 0 //cannot be improved
    cooldown_min = 100
    include_user = 1

    var/obj/marked_item
    /// List of objects which will result in the spell stopping with the recursion search
    var/static/list/blacklisted_summons = list(/obj/machinery/computer/cryopod = TRUE, /obj/machinery/atmospherics = TRUE, /obj/structure/disposalholder = TRUE, /obj/machinery/disposal = TRUE)
    action_icon_state = "summons"

/obj/effect/proc_holder/spell/targeted/summonitem/cast(list/targets, mob/user = usr)
    for(var/mob/living/target in targets)
        var/list/hand_items = list(target.get_active_hand(),target.get_inactive_hand())
        var/butterfingers = 0
        var/message

        if(!marked_item) //linking item to the spell
            message = "<span class='notice'>"
            for(var/obj/item in hand_items)
                if(istype(item, /obj/item/organ/internal/brain)) //Yeah, sadly this doesn't work due to the organ system.
                    break
                if(ABSTRACT in item.flags)
                    continue
                if(NODROP in item.flags)
                    message += "This feels very redundant, but you go through with it anyway.<br>"
                marked_item = 		item
                message += "You mark [item] for recall.</span>"
                name = "Recall [item]"
                break

            if(!marked_item)
                if(hand_items)
                    message = "<span class='caution'>You aren't holding anything that can be marked for recall.</span>"
                else
                    message = "<span class='notice'>You must hold the desired item in your hands to mark it for recall.</span>"

        else if(marked_item && (marked_item in hand_items)) //unlinking item to the spell
            message = "<span class='notice'>You remove the mark on [marked_item] to use elsewhere.</span>"
            name = "Instant Summons"
            marked_item = 		null

        else if(marked_item && !marked_item.loc) //the item was destroyed at some point
            message = "<span class='warning'>You sense your marked item has been destroyed!</span>"
            name = "Instant Summons"
            marked_item = 		null

        else	//Getting previously marked item
            var/obj/item_to_retrieve = marked_item
            var/infinite_recursion = 0 //I don't want to know how someone could put something inside itself but these are wizards so let's be safe

            while(!isturf(item_to_retrieve.loc) && infinite_recursion < 10) //if it's in something you get the whole thing.
                if(ismob(item_to_retrieve.loc)) //If its on someone, properly drop it
                    var/mob/M = item_to_retrieve.loc

                    if(issilicon(M) || !M.unEquip(item_to_retrieve)) //Items in silicons warp the whole silicon
                        M.visible_message("<span class='warning'>[M] suddenly disappears!</span>", "<span class='danger'>A force suddenly pulls you away!</span>")
                        M.forceMove(target.loc)
                        M.loc.visible_message("<span class='caution'>[M] suddenly appears!</span>")
                        item_to_retrieve = null
                        break

                    if(ishuman(M)) //Edge case housekeeping
                        var/mob/living/carbon/human/C = M
                        /*if(C.internal_bodyparts_by_name  && item_to_retrieve in C.internal_bodyparts_by_name ) //This won't work, as we use organ datums instead of objects. --DZD
                            C.internal_bodyparts_by_name  -= item_to_retrieve
                            if(istype(marked_item, /obj/item/brain)) //If this code ever runs I will be happy
                                var/obj/item/brain/B = new /obj/item/brain(target.loc)
                                B.transfer_identity(C)
                                C.death()
                                add_attack_logs(target, C, "Magically debrained INTENT: [uppertext(target.a_intent)]")*/
                        for(var/X in C.bodyparts)
                            var/obj/item/organ/external/part = X
                            if(item_to_retrieve in part.embedded_objects)
                                part.embedded_objects -= item_to_retrieve
                                to_chat(C, "<span class='warning'>\The [item_to_retrieve] that was embedded in your [part] has mysteriously vanished. How fortunate!</span>")
                                if(!C.has_embedded_objects())
                                    C.clear_alert("embeddedobject")
                                break

                else
                    if(istype(item_to_retrieve.loc,/obj/machinery/portable_atmospherics/)) //Edge cases for moved machinery
                        var/obj/machinery/portable_atmospherics/P = item_to_retrieve.loc
                        P.disconnect()
                        P.update_icon()
                    if(is_type_in_typecache(item_to_retrieve.loc, blacklisted_summons))
                        break
                    item_to_retrieve = item_to_retrieve.loc

                infinite_recursion += 1

            if(!item_to_retrieve)
                return

            item_to_retrieve.loc.visible_message("<span class='warning'>\The [item_to_retrieve] suddenly disappears!</span>")


            if(target.hand) //left active hand
                if(!target.equip_to_slot_if_possible(item_to_retrieve, slot_l_hand, FALSE, TRUE))
                    if(!target.equip_to_slot_if_possible(item_to_retrieve, slot_r_hand, FALSE, TRUE))
                        butterfingers = 1
            else			//right active hand
                if(!target.equip_to_slot_if_possible(item_to_retrieve, slot_r_hand, FALSE, TRUE))
                    if(!target.equip_to_slot_if_possible(item_to_retrieve, slot_l_hand, FALSE, TRUE))
                        butterfingers = 1
            if(butterfingers)
                item_to_retrieve.loc = target.loc
                item_to_retrieve.loc.visible_message("<span class='caution'>\The [item_to_retrieve] suddenly appears!</span>")
                playsound(get_turf(target),'sound/magic/summonitems_generic.ogg',50,1)
            else
                item_to_retrieve.loc.visible_message("<span class='caution'>\The [item_to_retrieve] suddenly appears in [target]'s hand!</span>")
                playsound(get_turf(target),'sound/magic/summonitems_generic.ogg',50,1)

        if(message)
            to_chat(target, message)
