/mob/living/carbon/alien/larva/emote(act, m_type = 1, message = null, force)
    var/param = null
    if(findtext(act, "-", 1, null))
        var/t1 = findtext(act, "-", 1, null)
        param = copytext(act, t1 + 1, length(act) + 1)
        act = copytext(act, 1, t1)

    if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
        act = copytext(act,1,length(act))
    var/muzzled = is_muzzled()
    act = lowertext(act)
    switch(act)
        if("me")
            if(silent)
                return
            if(src.client)
                if(client.prefs.muted & MUTE_IC)
                    to_chat(src, "<span class='warning'>You cannot send IC messages (muted).</span>")
                    return
                if(src.client.handle_spam_prevention(message,MUTE_IC))
                    return
            if(stat)
                return
            if(!(message))
                return
            return custom_emote(m_type, message)

        if("custom")
            return custom_emote(m_type, message)
        if("sign")
            if(!src.restrained())
                message = text("<B>The alien</B> signs[].", (text2num(param) ? text(" the number []", text2num(param)) : null))
                m_type = 1
        if("burp")
            if(!muzzled)
                message = "<B>[src]</B> burps."
                m_type = 2
        if("scratch")
            if(!src.restrained())
                message = "<B>[src]</B> scratches."
                m_type = 1
        if("whimper")
            if(!muzzled)
                message = "<B>[src]</B> whimpers."
                m_type = 2
//		if("roar")
//			if(!muzzled)
//				message = "<B>[src]</B> roars." Commenting out since larva shouldn't roar /N
//				m_type = 2
        if("tail")
            message = "<B>[src]</B> waves its tail."
            m_type = 1
        if("gasp")
            message = "<B>[src]</B> gasps."
            m_type = 2
        if("shiver")
            message = "<B>[src]</B> shivers."
            m_type = 2
        if("drool")
            message = "<B>[src]</B> drools."
            m_type = 1
        if("scretch")
            if(!muzzled)
                message = "<B>[src]</B> scretches."
                m_type = 2
        if("choke")
            message = "<B>[src]</B> chokes."
            m_type = 2
        if("moan")
            message = "<B>[src]</B> moans!"
            m_type = 2
        if("nod")
            message = "<B>[src]</B> nods its head."
            m_type = 1
//		if("sit")
//			message = "<B>[src]</B> sits down." //Larvan can't sit down, /N
//			m_type = 1
        if("sway")
            message = "<B>[src]</B> sways around dizzily."
            m_type = 1
        if("sulk")
            message = "<B>[src]</B> sulks down sadly."
            m_type = 1
        if("twitch")
            message = "<B>[src]</B> twitches violently."
            m_type = 1
        if("dance")
            if(!src.restrained())
                message = "<B>[src]</B> dances around happily."
                m_type = 1
        if("roll")
            if(!src.restrained())
                message = "<B>[src]</B> rolls."
                m_type = 1
        if("shake")
            message = "<B>[src]</B> shakes its head."
            m_type = 1
        if("gnarl")
            if(!muzzled)
                message = "<B>[src]</B> gnarls and shows its teeth.."
                m_type = 2
        if("jump")
            message = "<B>[src]</B> jumps!"
            m_type = 1
        if("hiss_")
            message = "<B>[src]</B> hisses softly."
            m_type = 1
        if("collapse")
            Paralyse(2)
            message = text("<B>[]</B> collapses!", src)
            m_type = 2
        if("help")
            to_chat(src, "burp, choke, collapse, dance, drool, gasp, shiver, gnarl, jump, moan, nod, roll, scratch,\nscretch, shake, sign-#, sulk, sway, tail, twitch, whimper")
        else
            to_chat(src, text("Invalid Emote: []", act))
    if((message && src.stat == 0))
        log_emote(message, src)
        if(m_type & 1)
            for(var/mob/O in viewers(src, null))
                O.show_message(message, m_type)
                //Foreach goto(703)
        else
            for(var/mob/O in hearers(src, null))
                O.show_message(message, m_type)
                //Foreach goto(746)
    return
