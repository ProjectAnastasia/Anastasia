/obj/effect/proc_holder/spell/aoe_turf/conjure
    name = "Conjure"
    desc = "This spell conjures objs of the specified types in range."

    var/list/summon_type = list() //determines what exactly will be summoned
    //should be text, like list("/mob/simple_animal/bot/ed209")

    var/summon_lifespan = 0 // 0=permanent, any other time in deciseconds
    var/summon_amt = 1 //amount of objects summoned
    var/summon_ignore_density = 0 //if set to 1, adds dense tiles to possible spawn places
    var/summon_ignore_prev_spawn_points = 0 //if set to 1, each new object is summoned on a new spawn point

    var/list/newVars = list() //vars of the summoned objects will be replaced with those where they meet
    //should have format of list("emagged" = 1,"name" = "Wizard's Justicebot"), for example
    var/delay = 1//Go Go Gadget Inheritance

    var/cast_sound = 'sound/items/welder.ogg'

/obj/effect/proc_holder/spell/aoe_turf/conjure/cast(list/targets,mob/living/user = usr)
    playsound(get_turf(user), cast_sound, 50,1)
    for(var/turf/T in targets)
        if(T.density && !summon_ignore_density)
            targets -= T
    playsound(get_turf(src), cast_sound, 50, 1)

    if(do_after(user, delay, target = user))
        for(var/i=0,i<summon_amt,i++)
            if(!targets.len)
                break
            var/summoned_object_type = pick(summon_type)
            var/spawn_place = pick(targets)
            if(summon_ignore_prev_spawn_points)
                targets -= spawn_place
            if(ispath(summoned_object_type,/turf))
                var/turf/O = spawn_place
                var/N = summoned_object_type
                O.ChangeTurf(N)
            else
                var/atom/summoned_object = new summoned_object_type(spawn_place)

                for(var/varName in newVars)
                    if(varName in summoned_object.vars)
                        summoned_object.vars[varName] = newVars[varName]
                summoned_object.admin_spawned = TRUE

                if(summon_lifespan)
                    QDEL_IN(summoned_object, summon_lifespan)
    else
        switch(charge_type)
            if("recharge")
                charge_counter = charge_max - 5//So you don't lose charge for a failed spell(Also prevents most over-fill)
            if("charges")
                charge_counter++//Ditto, just for different spell types


    return

/obj/effect/proc_holder/spell/aoe_turf/conjure/summonEdSwarm //test purposes
    name = "Dispense Wizard Justice"
    desc = "This spell dispenses wizard justice."

    summon_type = list(/mob/living/simple_animal/bot/ed209)
    summon_amt = 10
    range = 3
    newVars = list("emagged" = 1,"name" = "Wizard's Justicebot")
