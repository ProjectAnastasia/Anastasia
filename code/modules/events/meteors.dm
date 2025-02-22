/datum/event/meteor_wave
    startWhen		= 5
    endWhen 		= 7
    var/next_meteor = 6
    var/waves = 1

/datum/event/meteor_wave/setup()
    waves = severity * rand(1,3)

/datum/event/meteor_wave/announce()
    switch(severity)
        if(EVENT_LEVEL_MAJOR)
            GLOB.event_announcement.Announce("Meteors have been detected on collision course with the station.", "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')
        else
            GLOB.event_announcement.Announce("The station is now in a meteor shower.", "Meteor Alert")

//meteor showers are lighter and more common,
/datum/event/meteor_wave/tick()
    if(waves && activeFor >= next_meteor)
        INVOKE_ASYNC(GLOBAL_PROC, .proc/spawn_meteors, get_meteor_count(), get_meteors())
        next_meteor += rand(15, 30) / severity
        waves--
        endWhen = (waves ? next_meteor + 1 : activeFor + 15)

/datum/event/meteor_wave/end()
    switch(severity)
        if(EVENT_LEVEL_MAJOR)
            GLOB.event_announcement.Announce("The station has cleared the meteor storm.", "Meteor Alert")
        else
            GLOB.event_announcement.Announce("The station has cleared the meteor shower", "Meteor Alert")

/datum/event/meteor_wave/proc/get_meteors()
    switch(severity)
        if(EVENT_LEVEL_MAJOR)
            return GLOB.meteors_catastrophic
        if(EVENT_LEVEL_MODERATE)
            return GLOB.meteors_threatening
        else
            return GLOB.meteors_normal

/datum/event/meteor_wave/proc/get_meteor_count()
    return severity * rand(1, 2)
