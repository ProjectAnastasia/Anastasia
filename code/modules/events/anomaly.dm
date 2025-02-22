/datum/event/anomaly
    name = "Anomaly: Energetic Flux"
    var/obj/effect/anomaly/anomaly_path = /obj/effect/anomaly/flux
    announceWhen = 1

/datum/event/anomaly/proc/findEventArea()
    var/static/list/allowed_areas
    var/static/list/existing_areas
    if(!existing_areas)
        existing_areas = list()
        for(var/area/AR in world)
            var/turf/picked = safepick(get_area_turfs(AR.type))
            if(picked && is_station_level(picked.z))
                existing_areas += AR
    if(!allowed_areas)
        //Places that shouldn't explode
        var/list/safe_area_types = typecacheof(list(
        /area/turret_protected/ai,
        /area/turret_protected/ai_upload,
        /area/ai_monitored/storage/emergency,
        /area/engine,
        /area/solar,
        /area/holodeck,
        /area/shuttle,
        /area/maintenance,
        /area/toxins/test_area)
        )

        //Subtypes from the above that actually should explode.
        var/list/unsafe_area_subtypes = typecacheof(list(
        /area/engine/break_room,
        /area/engine/equipmentstorage,
        /area/engine/chiefs_office,
        /area/engine/controlroom,
        /area/engine/mechanic_workshop
        ))

        allowed_areas = typecacheof(GLOB.the_station_areas) - safe_area_types + unsafe_area_subtypes
    var/list/possible_areas = typecache_filter_list(existing_areas, allowed_areas)
    if(length(possible_areas))
        return pick(possible_areas)

/datum/event/anomaly/setup()
    impact_area = findEventArea()
    if(!impact_area)
        CRASH("No valid areas for anomaly found.")
    var/list/turf_test = get_area_turfs(impact_area)
    if(!length(turf_test))
        CRASH("Anomaly: No valid turfs found for [impact_area] - [impact_area.type]")

/datum/event/anomaly/announce()
    GLOB.event_announcement.Announce("Localized hyper-energetic flux wave detected on long range scanners. Expected location of impact: [impact_area.name].", "Anomaly Alert", 'sound/AI/anomaly.ogg')

/datum/event/anomaly/start()
    var/turf/T = pick(get_area_turfs(impact_area))
    var/newAnomaly
    if(T)
        newAnomaly = new anomaly_path(T)
    if(newAnomaly)
        announce_to_ghosts(newAnomaly)
