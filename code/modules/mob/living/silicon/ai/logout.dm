/mob/living/silicon/ai/Logout()
    ..()
    for(var/obj/machinery/ai_status_display/O in GLOB.machines) //change status
        O.mode = 0
    src.view_core()
    return
