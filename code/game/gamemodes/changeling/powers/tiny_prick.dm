/datum/action/changeling/sting
    name = "Tiny Prick"
    desc = "Stabby stabby"
    var/sting_icon = null
    /// A middle click override used to intercept changeling stings performed on a target.
    var/datum/middleClickOverride/callback_invoker/click_override

/datum/action/changeling/sting/New(Target)
    . = ..()
    click_override = new /datum/middleClickOverride/callback_invoker(CALLBACK(src, .proc/try_to_sting))

/datum/action/changeling/sting/Trigger()
    var/mob/user = owner
    if(!user || !user.mind || !user.mind.changeling)
        return
    if(!(user.mind.changeling.chosen_sting))
        set_sting(user)
    else
        unset_sting(user)
    return

/datum/action/changeling/sting/proc/set_sting(mob/living/user)
    to_chat(user, "<span class='notice'>We prepare our sting, use alt+click or middle mouse button on target to sting them.</span>")
    user.middleClickOverride = click_override
    user.mind.changeling.chosen_sting = src
    user.hud_used.lingstingdisplay.icon_state = sting_icon
    user.hud_used.lingstingdisplay.invisibility = 0

/datum/action/changeling/sting/proc/unset_sting(mob/living/user)
    to_chat(user, "<span class='warning'>We retract our sting, we can't sting anyone for now.</span>")
    user.middleClickOverride = null
    user.mind.changeling.chosen_sting = null
    user.hud_used.lingstingdisplay.icon_state = null
    user.hud_used.lingstingdisplay.invisibility = 101

/mob/living/carbon/proc/unset_sting()
    if(mind && mind.changeling && mind.changeling.chosen_sting)
        mind.changeling.chosen_sting.unset_sting(src)

/datum/action/changeling/sting/can_sting(mob/user, mob/target)
    if(!..())
        return
    if(!user.mind.changeling.chosen_sting)
        to_chat(user, "We haven't prepared our sting yet!")
    if(!iscarbon(target))
        return
    if(ismachineperson(target))
        to_chat(user, "<span class='warning'>This won't work on synthetics.</span>")
        return
    if(!isturf(user.loc))
        return
    if(!AStar(user, target.loc, /turf/proc/Distance, user.mind.changeling.sting_range, simulated_only = 0))
        return
    if(target.mind && target.mind.changeling)
        sting_feedback(user,target)
        take_chemical_cost(user.mind.changeling)
        return
    return 1

/datum/action/changeling/sting/sting_feedback(mob/user, mob/target)
    if(!target)
        return
    to_chat(user, "<span class='notice'>We stealthily sting [target.name].</span>")
    if(target.mind && target.mind.changeling)
        to_chat(target, "<span class='warning'>You feel a tiny prick.</span>")
        add_attack_logs(user, target, "Unsuccessful sting (changeling)")
    return 1

/datum/action/changeling/sting/extract_dna
    name = "Extract DNA Sting"
    desc = "We stealthily sting a target and extract their DNA. Costs 25 chemicals."
    helptext = "Will give you the DNA of your target, allowing you to transform into them."
    button_icon_state = "sting_extract"
    sting_icon = "sting_extract"
    chemical_cost = 25
    dna_cost = 0

/datum/action/changeling/sting/extract_dna/can_sting(mob/user, mob/target)
    if(..())
        return user.mind.changeling.can_absorb_dna(user, target)

/datum/action/changeling/sting/extract_dna/sting_action(mob/user, mob/living/carbon/human/target)
    add_attack_logs(user, target, "Extraction sting (changeling)")
    if(!(user.mind.changeling.has_dna(target.dna)))
        user.mind.changeling.absorb_dna(target, user)
    SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("[name]"))
    return 1

/datum/action/changeling/sting/mute
    name = "Mute Sting"
    desc = "We silently sting a human, completely silencing them for a short time. Costs 20 chemicals."
    helptext = "Does not provide a warning to the victim that they have been stung, until they try to speak and cannot."
    button_icon_state = "sting_mute"
    sting_icon = "sting_mute"
    chemical_cost = 20
    dna_cost = 2

/datum/action/changeling/sting/mute/sting_action(mob/user, mob/living/carbon/target)
    add_attack_logs(user, target, "Mute sting (changeling)")
    target.AdjustSilence(30)
    SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("[name]"))
    return 1

/datum/action/changeling/sting/blind
    name = "Blind Sting"
    desc = "We temporarily blind our victim. Costs 25 chemicals."
    helptext = "This sting completely blinds a target for a short time, and leaves them with blurred vision for a long time."
    button_icon_state = "sting_blind"
    sting_icon = "sting_blind"
    chemical_cost = 25
    dna_cost = 1

/datum/action/changeling/sting/blind/sting_action(mob/living/user, mob/living/target)
    add_attack_logs(user, target, "Blind sting (changeling)")
    to_chat(target, "<span class='danger'>Your eyes burn horrifically!</span>")
    target.become_nearsighted(EYE_DAMAGE)
    target.EyeBlind(20)
    target.EyeBlurry(40)
    SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("[name]"))
    return 1

/datum/action/changeling/sting/LSD
    name = "Hallucination Sting"
    desc = "We cause mass terror to our victim. Costs 10 chemicals."
    helptext = "We evolve the ability to sting a target with a powerful hallucinogenic chemical. The target does not notice they have been stung, and the effect occurs after 30 to 60 seconds."
    button_icon_state = "sting_lsd"
    sting_icon = "sting_lsd"
    chemical_cost = 10
    dna_cost = 1

/datum/action/changeling/sting/LSD/sting_action(mob/user, mob/living/carbon/target)
    add_attack_logs(user, target, "LSD sting (changeling)")
    spawn(rand(300,600))
        if(target)
            target.Hallucinate(400)
    SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("[name]"))
    return 1

/datum/action/changeling/sting/cryo //Enable when mob cooling is fixed so that frostoil actually makes you cold, instead of mostly just hungry.
    name = "Cryogenic Sting"
    desc = "We silently sting our victim with a cocktail of chemicals that freezes them from the inside. Costs 15 chemicals."
    helptext = "Does not provide a warning to the victim, though they will likely realize they are suddenly freezing."
    button_icon_state = "sting_cryo"
    sting_icon = "sting_cryo"
    chemical_cost = 15
    dna_cost = 2

/datum/action/changeling/sting/cryo/sting_action(mob/user, mob/target)
    add_attack_logs(user, target, "Cryo sting (changeling)")
    if(target.reagents)
        target.reagents.add_reagent("frostoil", 30)
        target.reagents.add_reagent("ice", 30)
    SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("[name]"))
    return 1
