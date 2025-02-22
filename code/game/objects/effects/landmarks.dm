/obj/effect/landmark
    name = "landmark"
    icon = 'icons/mob/screen_gen.dmi'
    icon_state = "x2"
    anchored = 1.0
    resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/effect/landmark/New()

    ..()
    set_tag()
    invisibility = 101

    switch(name)			//some of these are probably obsolete
        if("start")
            GLOB.newplayer_start += loc
            qdel(src)

        if("wizard")
            GLOB.wizardstart += loc
            qdel(src)

        if("JoinLate")
            GLOB.latejoin += loc
            qdel(src)

        if("JoinLateGateway")
            GLOB.latejoin_gateway += loc
            qdel(src)

        if("JoinLateCryo")
            GLOB.latejoin_cryo += loc
            qdel(src)

        if("JoinLateCyborg")
            GLOB.latejoin_cyborg += loc
            qdel(src)

        if("prisonwarp")
            GLOB.prisonwarp += loc
            qdel(src)

        if("syndieprisonwarp")
            GLOB.syndieprisonwarp += loc
            qdel(src)

        if("prisonsecuritywarp")
            GLOB.prisonsecuritywarp += loc
            qdel(src)

        if("tdome1")
            GLOB.tdome1	+= loc

        if("tdome2")
            GLOB.tdome2 += loc

        if("tdomeadmin")
            GLOB.tdomeadmin	+= loc

        if("tdomeobserve")
            GLOB.tdomeobserve += loc

        if("aroomwarp")
            GLOB.aroomwarp += loc

        if("blobstart")
            GLOB.blobstart += loc
            qdel(src)

        if("xeno_spawn")
            GLOB.xeno_spawn += loc
            qdel(src)

        if("ninjastart")
            GLOB.ninjastart += loc
            qdel(src)

        if("carpspawn")
            GLOB.carplist += loc

        if("voxstart")
            GLOB.raider_spawn += loc

        if("ERT Director")
            GLOB.ertdirector += loc
            qdel(src)

        if("Response Team")
            GLOB.emergencyresponseteamspawn += loc
            qdel(src)

        if("Syndicate Officer")
            GLOB.syndicateofficer += loc
            qdel(src)

    GLOB.landmarks_list += src
    return 1

/obj/effect/landmark/Destroy()
    GLOB.landmarks_list -= src
    ..()
    return QDEL_HINT_HARDDEL_NOW

/obj/effect/landmark/proc/set_tag()
    tag = text("landmark*[]", name)


/obj/effect/landmark/singularity_act()
    return

// Please stop bombing the Observer-Start landmark.
/obj/effect/landmark/ex_act()
    return

/obj/effect/landmark/singularity_pull()
    return

/obj/effect/landmark/start
    name = "start"
    icon = 'icons/mob/screen_gen.dmi'
    icon_state = "x"
    anchored = 1.0

/obj/effect/landmark/start/set_tag()
    tag = "start*[name]"


//Costume spawner landmarks

/obj/effect/landmark/costume/random/New() //costume spawner, selects a random subclass and disappears
    . = ..()
    var/list/options = (typesof(/obj/effect/landmark/costume) - /obj/effect/landmark/costume/random)
    var/PICK= options[rand(1,options.len)]
    new PICK(src.loc)
    qdel(src)

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/New()
    . = ..()
    new /obj/item/clothing/suit/chickensuit(src.loc)
    new /obj/item/clothing/head/chicken(src.loc)
    new /obj/item/reagent_containers/food/snacks/egg(src.loc)
    qdel(src)

/obj/effect/landmark/costume/gladiator/New()
    . = ..()
    new /obj/item/clothing/under/gladiator(src.loc)
    new /obj/item/clothing/head/helmet/gladiator(src.loc)
    qdel(src)

/obj/effect/landmark/costume/madscientist/New()
    . = ..()
    new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
    new /obj/item/clothing/head/flatcap(src.loc)
    new /obj/item/clothing/suit/storage/labcoat/mad(src.loc)
    new /obj/item/clothing/glasses/gglasses(src.loc)
    qdel(src)

/obj/effect/landmark/costume/elpresidente/New()
    . = ..()
    new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
    new /obj/item/clothing/head/flatcap(src.loc)
    new /obj/item/clothing/mask/cigarette/cigar/havana(src.loc)
    new /obj/item/clothing/shoes/jackboots(src.loc)
    qdel(src)

/obj/effect/landmark/costume/schoolgirl/New()
    . = ..()
    new /obj/item/clothing/under/schoolgirl(src.loc)
    qdel(src)

/obj/effect/landmark/costume/maid/New()
    . = ..()
    new /obj/item/clothing/under/blackskirt(src.loc)
    var/CHOICE = pick( /obj/item/clothing/head/beret , /obj/item/clothing/head/rabbitears )
    new CHOICE(src.loc)
    new /obj/item/clothing/glasses/sunglasses/blindfold(src.loc)
    qdel(src)

/obj/effect/landmark/costume/butler/New()
    . = ..()
    new /obj/item/clothing/suit/wcoat(src.loc)
    new /obj/item/clothing/under/suit_jacket(src.loc)
    new /obj/item/clothing/head/that(src.loc)
    qdel(src)

/obj/effect/landmark/costume/scratch/New()
    . = ..()
    new /obj/item/clothing/gloves/color/white(src.loc)
    new /obj/item/clothing/shoes/white(src.loc)
    new /obj/item/clothing/under/scratch(src.loc)
    if(prob(30))
        new /obj/item/clothing/head/cueball(src.loc)
    qdel(src)

/obj/effect/landmark/costume/highlander/New()
    . = ..()
    new /obj/item/clothing/under/kilt(src.loc)
    new /obj/item/clothing/head/beret(src.loc)
    qdel(src)

/obj/effect/landmark/costume/prig/New()
    . = ..()
    new /obj/item/clothing/suit/wcoat(src.loc)
    new /obj/item/clothing/glasses/monocle(src.loc)
    var/CHOICE= pick( /obj/item/clothing/head/bowlerhat, /obj/item/clothing/head/that)
    new CHOICE(src.loc)
    new /obj/item/clothing/shoes/black(src.loc)
    new /obj/item/cane(src.loc)
    new /obj/item/clothing/under/sl_suit(src.loc)
    new /obj/item/clothing/mask/fakemoustache(src.loc)
    qdel(src)

/obj/effect/landmark/costume/plaguedoctor/New()
    . = ..()
    new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
    new /obj/item/clothing/head/plaguedoctorhat(src.loc)
    qdel(src)

/obj/effect/landmark/costume/nightowl/New()
    . = ..()
    new /obj/item/clothing/under/owl(src.loc)
    new /obj/item/clothing/mask/gas/owl_mask(src.loc)
    qdel(src)

/obj/effect/landmark/costume/waiter/New()
    . = ..()
    new /obj/item/clothing/under/waiter(src.loc)
    var/CHOICE= pick( /obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
    new CHOICE(src.loc)
    new /obj/item/clothing/suit/apron(src.loc)
    qdel(src)

/obj/effect/landmark/costume/pirate/New()
    . = ..()
    new /obj/item/clothing/under/pirate(src.loc)
    new /obj/item/clothing/suit/pirate_black(src.loc)
    var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/head/bandana )
    new CHOICE(src.loc)
    new /obj/item/clothing/glasses/eyepatch(src.loc)
    qdel(src)

/obj/effect/landmark/costume/commie/New()
    . = ..()
    new /obj/item/clothing/under/soviet(src.loc)
    new /obj/item/clothing/head/ushanka(src.loc)
    qdel(src)


/obj/effect/landmark/costume/imperium_monk/New()
    . = ..()
    new /obj/item/clothing/suit/imperium_monk(src.loc)
    if(prob(25))
        new /obj/item/clothing/mask/gas/cyborg(src.loc)
    qdel(src)

/obj/effect/landmark/costume/holiday_priest/New()
    . = ..()
    new /obj/item/clothing/suit/holidaypriest(src.loc)
    qdel(src)

/obj/effect/landmark/costume/marisawizard/fake/New()
    . = ..()
    new /obj/item/clothing/head/wizard/marisa/fake(src.loc)
    new/obj/item/clothing/suit/wizrobe/marisa/fake(src.loc)
    qdel(src)

/obj/effect/landmark/costume/cutewitch/New()
    . = ..()
    new /obj/item/clothing/under/sundress(src.loc)
    new /obj/item/clothing/head/witchwig(src.loc)
    new /obj/item/twohanded/staff/broom(src.loc)
    qdel(src)

/obj/effect/landmark/costume/fakewizard/New()
    . = ..()
    new /obj/item/clothing/suit/wizrobe/fake(src.loc)
    new /obj/item/clothing/head/wizard/fake(src.loc)
    new /obj/item/twohanded/staff/(src.loc)
    qdel(src)

/obj/effect/landmark/costume/sexyclown/New()
    . = ..()
    new /obj/item/clothing/mask/gas/clown_hat/sexy(loc)
    new /obj/item/clothing/under/rank/clown/sexy(loc)
    qdel(src)

/obj/effect/landmark/costume/sexymime/New()
    . = ..()
    new /obj/item/clothing/mask/gas/sexymime(src.loc)
    new /obj/item/clothing/under/sexymime(src.loc)
    qdel(src)

/obj/effect/landmark/ruin
    var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/New(loc, my_ruin_template)
    name = "ruin_[GLOB.ruin_landmarks.len + 1]"
    ..(loc)
    ruin_template = my_ruin_template
    GLOB.ruin_landmarks |= src

/obj/effect/landmark/ruin/Destroy()
    GLOB.ruin_landmarks -= src
    ruin_template = null
    . = ..()

// Damage tiles
/obj/effect/landmark/damageturf
    icon_state = "damaged"

/obj/effect/landmark/damageturf/New()
    ..()
    var/turf/simulated/T = get_turf(src)
    if(istype(T))
        T.break_tile()

/obj/effect/landmark/burnturf
    icon_state = "burned"

/obj/effect/landmark/burnturf/New()
    ..()
    var/turf/simulated/T = get_turf(src)
    T.burn_tile()


/obj/effect/landmark/battle_mob_point
    name = "Nanomob Battle Avatar Spawn Point"

/obj/effect/landmark/free_golem_spawn
    name = "Free Golem Spawn Point"
