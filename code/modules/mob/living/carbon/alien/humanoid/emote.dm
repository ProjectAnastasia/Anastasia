/mob/living/carbon/alien/humanoid/emote(act, m_type = 1, message = null, force)
    var/param = null
    if(findtext(act, "-", 1, null))
        var/t1 = findtext(act, "-", 1, null)
        param = copytext(act, t1 + 1, length(act) + 1)
        act = copytext(act, 1, t1)

//	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
//		act = copytext(act,1,length(act))	//seriously who the fuck wrote this
    var/muzzled = is_muzzled()

    var/on_CD = 0
    act = lowertext(act)

    //cooldown system handled by /code/modules/mob/emotes.dm
    switch(act)
        if("roar")
            on_CD = handle_emote_CD()
        if("deathgasp")
            on_CD = handle_emote_CD()
        if("hiss")
            on_CD = handle_emote_CD()
        if("gnarl")
            on_CD = handle_emote_CD()
        if("flip")
            on_CD = handle_emote_CD()

    if(!force && on_CD == 1)
        return

    switch(act)



        if("sign")
            if(!restrained())
                var/num = null
                if(text2num(param))
                    num = "the number [text2num(param)]"
                if(num)
                    message = "<B>\The [src]</B> signs [num]."
                    m_type = 1
        if("burp")
            if(!muzzled)
                message = "<B>\The [src]</B> burps."
                m_type = 2
        if("deathgasp")
            message = "<B>\The [src]</B> lets out a waning guttural screech, green blood bubbling from its maw..."
            m_type = 2
        if("scratch")
            if(!restrained())
                message = "<B>\The [src]</B> scratches."
                m_type = 1
        if("whimper")
            if(!muzzled)
                message = "<B>\The [src]</B> whimpers."
                m_type = 2
        if("roar")
            if(!muzzled)
                message = "<B>\The [src]</B> roars."
                m_type = 2
        if("hiss")
            if(!muzzled)
                message = "<B>\The [src]</B> hisses."
                m_type = 2
        if("tail")
            message = "<B>\The [src]</B> waves its tail."
            m_type = 1
        if("gasp")
            message = "<B>\The [src]</B> gasps."
            m_type = 2
        if("shiver")
            message = "<B>\The [src]</B> shivers."
            m_type = 2
        if("drool")
            message = "<B>\The [src]</B> drools."
            m_type = 1
        if("scretch")
            if(!muzzled)
                message = "<B>\The [src]</B> scretches."
                m_type = 2
        if("choke")
            message = "<B>\The [src]</B> chokes."
            m_type = 2
        if("moan")
            message = "<B>\The [src]</B> moans!"
            m_type = 2
        if("nod")
            message = "<B>\The [src]</B> nods its head."
            m_type = 1
        if("sit")
            message = "<B>\The [src]</B> sits down."
            m_type = 1
        if("sway")
            message = "<B>\The [src]</B> sways around dizzily."
            m_type = 1
        if("sulk")
            message = "<B>\The [src]</B> sulks down sadly."
            m_type = 1
        if("twitch")
            message = "<B>\The [src]</B> twitches violently."
            m_type = 1
        if("dance")
            if(!restrained())
                message = "<B>\The [src]</B> dances around happily."
                m_type = 1
        if("roll")
            if(!restrained())
                message = "<B>\The [src]</B> rolls."
                m_type = 1
        if("shake")
            message = "<B>\The [src]</B> shakes its head."
            m_type = 1
        if("gnarl")
            if(!muzzled)
                message = "<B>\The [src]</B> gnarls and shows its teeth.."
                m_type = 2
        if("jump")
            message = "<B>\The [src]</B> jumps!"
            m_type = 1
        if("collapse")
            Paralyse(2)
            message = "<B>\The [src]</B> collapses!"
            m_type = 2
        if("flip")
            m_type = 1
            message = "<B>\The [src]</B> does a flip!"
            SpinAnimation(5,1)
        if("help")
            to_chat(src, "burp, flip, deathgasp, choke, collapse, dance, drool, gasp, shiver, gnarl, jump, moan, nod, roar, roll, scratch,\nscretch, shake, sign-#, sit, sulk, sway, tail, twitch, whimper")

    if(!stat)
        if(act == "roar")
            playsound(src.loc, 'sound/voice/hiss5.ogg', 50, 1, 1)
        if(act == "deathgasp")
            playsound(src.loc, 'sound/voice/hiss6.ogg', 80, 1, 1)
        if(act == "hiss")
            playsound(src.loc, 'sound/voice/hiss1.ogg', 30, 1, 1)
        if(act == "gnarl")
            playsound(src.loc, 'sound/voice/hiss4.ogg', 30, 1, 1)
        ..()
