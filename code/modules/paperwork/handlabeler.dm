/obj/item/hand_labeler
    name = "hand labeler"
    desc = "A combined label printer, applicator, and remover, all in a single portable device. Designed to be easy to operate and use."
    icon = 'icons/obj/bureaucracy.dmi'
    icon_state = "labeler0"
    item_state = "flight"
    var/label = null
    var/labels_left = 30
    var/mode = 0

/obj/item/hand_labeler/afterattack(atom/A, mob/user, proximity)
    if(!proximity)
        return
    if(!mode)	//if it's off, give up.
        return

    if(!labels_left)
        to_chat(user, "<span class='warning'>No labels left!</span>")
        return
    if(!label || !length(label))
        to_chat(user, "<span class='warning'>No text set!</span>")
        return
    if(length(A.name) + length(label) > 64)
        to_chat(user, "<span class='warning'>Label too big!</span>")
        return
    if(ismob(A))
        to_chat(user, "<span class='warning'>You can't label creatures!</span>") // use a collar
        return

    user.visible_message("<span class='notice'>[user] labels [A] as [label].</span>", \
                         "<span class='notice'>You label [A] as [label].</span>")
    investigate_log("[key_name(user)] labelled [A] as [label].", INVESTIGATE_LABEL) // Investigate goes BEFORE rename so the original name is preserved in the log
    A.AddComponent(/datum/component/label, label)
    playsound(A, 'sound/items/handling/component_pickup.ogg', 20, TRUE)
    labels_left--

/obj/item/hand_labeler/attack_self(mob/user as mob)
    mode = !mode
    icon_state = "labeler[mode]"
    if(mode)
        to_chat(user, "<span class='notice'>You turn on \the [src].</span>")
        //Now let them chose the text.
        var/str = copytext(reject_bad_text(input(user,"Label text?","Set label","")),1,MAX_NAME_LEN)
        if(!str || !length(str))
            to_chat(user, "<span class='notice'>Invalid text.</span>")
            return
        label = str
        to_chat(user, "<span class='notice'>You set the text to '[str]'.</span>")
    else
        to_chat(user, "<span class='notice'>You turn off \the [src].</span>")

/obj/item/hand_labeler/attackby(obj/item/I, mob/user, params)
    if(istype(I, /obj/item/hand_labeler_refill))
        to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
        user.drop_item()
        qdel(I)
        labels_left = initial(labels_left)	//Yes, it's capped at its initial value
    else
        return ..()

/obj/item/hand_labeler_refill
    name = "hand labeler paper roll"
    icon = 'icons/obj/bureaucracy.dmi'
    desc = "A roll of paper. Use it on a hand labeler to refill it."
    icon_state = "labeler_refill"
    item_state = "electropack"
    w_class = WEIGHT_CLASS_TINY
