SUBSYSTEM_DEF(vote)
    name = "Vote"
    wait = 10
    flags = SS_KEEP_TIMING|SS_NO_INIT
    runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
    offline_implications = "Votes (Endround shuttle) will no longer function. Shuttle call recommended."

    var/initiator = null
    var/started_time = null
    var/time_remaining = 0
    var/mode = null
    var/question = null
    var/list/choices = list()
    var/list/voted = list()
    var/list/voting = list()
    var/list/current_votes = list()
    var/list/round_voters = list()
    var/auto_muted = 0

/datum/controller/subsystem/vote/fire()
    if(mode)
        // No more change mode votes after the game has started.
        if(mode == "gamemode" && SSticker.current_state >= GAME_STATE_SETTING_UP)
            to_chat(world, "<b>Voting aborted due to game start.</b>")
            reset()
            return

        // Calculate how much time is remaining by comparing current time, to time of vote start,
        // plus vote duration
        time_remaining = round((started_time + GLOB.configuration.vote.vote_time - world.time)/10)

        if(time_remaining < 0)
            result()
            for(var/client/C in voting)
                if(C)
                    C << browse(null,"window=vote")
            reset()
        else
            for(var/client/C in voting)
                update_panel(C)
                CHECK_TICK

/datum/controller/subsystem/vote/proc/autotransfer()
    initiate_vote("crew transfer", "the server")

/datum/controller/subsystem/vote/proc/reset()
    initiator = null
    time_remaining = 0
    mode = null
    question = null
    choices.Cut()
    voted.Cut()
    voting.Cut()
    current_votes.Cut()

    if(auto_muted && !GLOB.ooc_enabled && !(GLOB.configuration.general.auto_disable_ooc && SSticker.current_state == GAME_STATE_PLAYING))
        auto_muted = 0
        GLOB.ooc_enabled = TRUE
        to_chat(world, "<b>The OOC channel has been automatically enabled due to vote end.</b>")
        log_admin("OOC was toggled automatically due to vote end.")
        message_admins("OOC has been toggled on automatically.")


/datum/controller/subsystem/vote/proc/get_result()
    var/greatest_votes = 0
    var/total_votes = 0
    var/list/sorted_choices = list()
    var/sorted_highest
    var/sorted_votes = -1
    //get the highest number of votes, while also sorting the list
    while(choices.len)
        // This is a very inefficient sorting method, but that's okay
        for(var/option in choices)
            var/votes = choices[option]
            if(sorted_votes < votes)
                sorted_highest = option
                sorted_votes = votes
            if(votes > greatest_votes)
                greatest_votes = votes
        sorted_votes = -1
        total_votes += choices[sorted_highest]
        sorted_choices[sorted_highest] = choices[sorted_highest] || 0
        choices -= sorted_highest
    choices = sorted_choices
    //default-vote for everyone who didn't vote
    if(!GLOB.configuration.vote.disable_default_vote && choices.len)
        var/non_voters = (GLOB.clients.len - total_votes)
        if(non_voters > 0)
            if(mode == "restart")
                choices["Continue Playing"] += non_voters
                if(choices["Continue Playing"] >= greatest_votes)
                    greatest_votes = choices["Continue Playing"]
            else if(mode == "gamemode")
                if(GLOB.master_mode in choices)
                    choices[GLOB.master_mode] += non_voters
                    if(choices[GLOB.master_mode] >= greatest_votes)
                        greatest_votes = choices[GLOB.master_mode]
            else if(mode == "crew transfer")
                var/factor = 0.5
                switch(world.time / (10 * 60)) // minutes
                    if(0 to 60)
                        factor = 0.5
                    if(61 to 120)
                        factor = 0.8
                    if(121 to 240)
                        factor = 1
                    if(241 to 300)
                        factor = 1.2
                    else
                        factor = 1.4
                choices["Initiate Crew Transfer"] = round(choices["Initiate Crew Transfer"] * factor)
                to_chat(world, "<font color='purple'>Crew Transfer Factor: [factor]</font>")
                greatest_votes = max(choices["Initiate Crew Transfer"], choices["Continue The Round"])


    //get all options with that many votes and return them in a list
    . = list()
    if(greatest_votes)
        for(var/option in choices)
            if(choices[option] == greatest_votes)
                . += option
    return .

/datum/controller/subsystem/vote/proc/announce_result()
    var/list/winners = get_result()
    var/text
    if(winners.len > 0)
        if(winners.len > 1)
            if(mode != "gamemode" || SSticker.hide_mode == 0) // Here we are making sure we don't announce potential game modes
                text = "<b>Vote Tied Between:</b>\n"
                for(var/option in winners)
                    text += "\t[option]\n"
        . = pick(winners)

        for(var/key in current_votes)
            if(choices[current_votes[key]] == .)
                round_voters += key // Keep track of who voted for the winning round.
        if(mode == "gamemode" && (. == "extended" || SSticker.hide_mode == 0)) // Announce Extended gamemode, but not other gamemodes
            text += "<b>Vote Result: [.] ([choices[.]] vote\s)</b>"
        else
            if(mode == "custom")
                // Completely replace text to show all results in custom votes
                text = "<b><span style='text-decoration: underline;'>[question]</span></b>\n"
                for(var/option in winners)
                    text += "\t<b>[option]: [choices[option]] vote\s</b>\n"
                for(var/option in (choices-winners))
                    text += "\t[option]: [choices[option]] vote\s\n"
            else if(mode != "gamemode")
                text += "<b>Vote Result: [.] ([choices[.]] vote\s)</b>"
            else
                text += "<b>The vote has ended.</b>" // What will be shown if it is a gamemode vote that isn't extended

    else
        text += "<b>Vote Result: Inconclusive - No Votes!</b>"
    log_vote(text)
    to_chat(world, "<font color='purple'>[text]</font>")
    return .

/datum/controller/subsystem/vote/proc/result()
    . = announce_result()
    var/restart = 0
    if(.)
        switch(mode)
            if("restart")
                if(. == "Restart Round")
                    restart = 1
            if("gamemode")
                if(GLOB.master_mode != .)
                    world.save_mode(.)
                    if(SSticker && SSticker.mode)
                        restart = 1
                    else
                        GLOB.master_mode = .
                if(!SSticker.ticker_going)
                    SSticker.ticker_going = TRUE
                    to_chat(world, "<font color='red'><b>The round will start soon.</b></font>")
            if("crew transfer")
                if(. == "Initiate Crew Transfer")
                    init_shift_change(null, TRUE)
            if("map")
                // Find target map.
                var/datum/map/top_voted_map
                for(var/x in subtypesof(/datum/map))
                    var/datum/map/M = x
                    // Set top voted map
                    if(. == "[initial(M.fluff_name)] ([initial(M.technical_name)])")
                        top_voted_map = M
                to_chat(world, "<font color='purple'>Map for next round: [initial(top_voted_map.fluff_name)] ([initial(top_voted_map.technical_name)])</font>")
                SSmapping.next_map = new top_voted_map


    if(restart)
        SSticker.reboot_helper("Restart vote successful.", "restart vote")

    return .

/datum/controller/subsystem/vote/proc/submit_vote(ckey, vote)
    if(mode)
        if(GLOB.configuration.vote.prevent_dead_voting && usr.stat == DEAD && !usr.client.holder)
            return 0
        if(current_votes[ckey])
            choices[choices[current_votes[ckey]]]--
        if(vote && 1<=vote && vote<=choices.len)
            voted += usr.ckey
            choices[choices[vote]]++	//check this
            current_votes[ckey] = vote
            return vote
    return 0

/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key, code_invoked = FALSE)
    if(!mode)
        if(started_time != null && !check_rights(R_ADMIN))
            var/next_allowed_time = (started_time + GLOB.configuration.vote.vote_delay)
            if(next_allowed_time > world.time)
                return 0

        reset()
        switch(vote_type)
            if("restart")
                choices.Add("Restart Round","Continue Playing")
            if("gamemode")
                if(SSticker.current_state >= 2)
                    return 0
                choices.Add(GLOB.configuration.gamemode.votable_modes)
            if("crew transfer")
                if(check_rights(R_ADMIN|R_MOD))
                    if(SSticker.current_state <= 2)
                        return 0
                    question = "End the shift?"
                    choices.Add("Initiate Crew Transfer", "Continue The Round")
                else
                    if(SSticker.current_state <= 2)
                        return 0
                    question = "End the shift?"
                    choices.Add("Initiate Crew Transfer", "Continue The Round")
            if("map")
                if(!(check_rights(R_SERVER) || code_invoked))
                    return FALSE
                question = "Map for next round"
                for(var/x in subtypesof(/datum/map))
                    var/datum/map/M = x
                    choices.Add("[initial(M.fluff_name)] ([initial(M.technical_name)])")

            if("custom")
                question = html_encode(input(usr,"What is the vote for?") as text|null)
                if(!question)	return 0
                for(var/i=1,i<=10,i++)
                    var/option = capitalize(html_encode(input(usr,"Please enter an option or hit cancel to finish") as text|null))
                    if(!option || mode || !usr.client)	break
                    choices.Add(option)
            else
                return 0
        mode = vote_type
        initiator = initiator_key
        started_time = world.time
        var/text = "[capitalize(mode)] vote started by [initiator]."
        if(mode == "custom")
            text += "\n[question]"
            if(usr)
                log_admin("[capitalize(mode)] ([question]) vote started by [key_name(usr)].")
        else if(usr)
            log_admin("[capitalize(mode)] vote started by [key_name(usr)].")

        log_vote(text)
        to_chat(world, {"<font color='purple'><b>[text]</b>
            <a href='?src=[UID()];vote=open'>Click here or type vote to place your vote.</a>
            You have [GLOB.configuration.vote.vote_time / 10] seconds to vote.</font>"})
        switch(vote_type)
            if("crew transfer", "gamemode", "custom", "map")
                SEND_SOUND(world, sound('sound/ambience/alarm4.ogg'))
        if(mode == "gamemode" && SSticker.ticker_going)
            SSticker.ticker_going = FALSE
            to_chat(world, "<font color='red'><b>Round start has been delayed.</b></font>")
        if(mode == "crew transfer" && GLOB.ooc_enabled)
            auto_muted = TRUE
            GLOB.ooc_enabled = FALSE
            to_chat(world, "<b>The OOC channel has been automatically disabled due to a crew transfer vote.</b>")
            log_admin("OOC was toggled automatically due to crew transfer vote.")
            message_admins("OOC has been toggled off automatically.")
        if(mode == "gamemode" && GLOB.ooc_enabled)
            auto_muted = TRUE
            GLOB.ooc_enabled = FALSE
            to_chat(world, "<b>The OOC channel has been automatically disabled due to the gamemode vote.</b>")
            log_admin("OOC was toggled automatically due to gamemode vote.")
            message_admins("OOC has been toggled off automatically.")
        if(mode == "custom" && GLOB.ooc_enabled)
            auto_muted = TRUE
            GLOB.ooc_enabled = FALSE
            to_chat(world, "<b>The OOC channel has been automatically disabled due to a custom vote.</b>")
            log_admin("OOC was toggled automatically due to custom vote.")
            message_admins("OOC has been toggled off automatically.")

        time_remaining = round(GLOB.configuration.vote.vote_time / 10)
        return 1
    return 0

/datum/controller/subsystem/vote/proc/browse_to(client/C)
    if(!C)
        return
    var/admin = check_rights(R_ADMIN, 0, user = C.mob)
    voting |= C

    var/dat = {"<script>
        function update_vote_div(new_content) {
            var votediv = document.getElementById("vote_div");
            if(votediv) {
                votediv.innerHTML = new_content;
            }
        }
        </script>"}
    if(mode)
        dat += "<div id='vote_div'>[vote_html(C)]</div><hr>"
        if(admin)
            dat += "(<a href='?src=[UID()];vote=cancel'>Cancel Vote</a>) "
    else
        dat += "<div id='vote_div'><h2>Start a vote:</h2><hr><ul><li>"
        // Crew transfer
        if(admin || GLOB.configuration.vote.allow_restart_votes)
            dat += "<a href='?src=[UID()];vote=crew_transfer'>Crew Transfer</a>"
        else
            dat += "<font color='grey'>Crew Transfer (Disallowed)</font>"
        dat += "</li><li>"

        // Restart
        if(admin || GLOB.configuration.vote.allow_restart_votes)
            dat += "<a href='?src=[UID()];vote=restart'>Restart</a>"
        else
            dat += "<font color='grey'>Restart (Disallowed)</font>"
        if(admin)
            dat += "\t(<a href='?src=[UID()];vote=toggle_restart'>[GLOB.configuration.vote.allow_restart_votes ? "Allowed" : "Disallowed"]</a>)"
        dat += "</li><li>"

        // Gamemode
        if(admin || GLOB.configuration.vote.allow_mode_votes)
            dat += "<a href='?src=[UID()];vote=gamemode'>Gamemode</a>"
        else
            dat += "<font color='grey'>Gamemode (Disallowed)</font>"
        if(admin)
            dat += "\t(<a href='?src=[UID()];vote=toggle_gamemode'>[GLOB.configuration.vote.allow_mode_votes ? "Allowed" : "Disallowed"]</a>)"
        dat += "</li><li>"

        // Map
        if(admin)
            dat += "<a href='?src=[UID()];vote=map'>Map</a>"
        else
            dat += "<font color='grey'>Map (Disallowed)</font>"
        dat += "</li><li>"

        // Custom
        if(admin)
            dat += "<a href='?src=[UID()];vote=custom'>Custom</a></li>"
        dat += "</ul></div><hr>"
    var/datum/browser/popup = new(C.mob, "vote", "Voting Panel", nref=src)
    popup.set_content(dat)
    popup.open()

/datum/controller/subsystem/vote/proc/update_panel(client/C)
    C << output(url_encode(vote_html(C)), "vote.browser:update_vote_div")

/datum/controller/subsystem/vote/proc/vote_html(client/C)
    . = ""
    if(question)
        . += "<h2>Vote: '[question]'</h2>"
    else
        . += "<h2>Vote: [capitalize(mode)]</h2>"
    . += "Time Left: [time_remaining] s<hr><ul>"
    for(var/i = 1, i <= choices.len, i++)
        var/votes = choices[choices[i]]
        if(!votes)
            votes = 0
        if(current_votes[C.ckey] == i)
            . += "<li><b><a href='?src=[UID()];vote=[i]'>[choices[i]] ([votes] vote\s)</a></b></li>"
        else
            . += "<li><a href='?src=[UID()];vote=[i]'>[choices[i]] ([votes] vote\s)</a></li>"

    . += "</ul>"


/datum/controller/subsystem/vote/Topic(href,href_list[],hsrc)
    if(!usr || !usr.client)
        return	//not necessary but meh...just in-case somebody does something stupid
    var/admin = check_rights(R_ADMIN,0)
    if(href_list["close"])
        voting -= usr.client
        return
    switch(href_list["vote"])
        if("open")
            // vote proc will automatically get called after this switch ends
        if("cancel")
            if(admin && mode)
                var/votedesc = capitalize(mode)
                if(mode == "custom")
                    votedesc += " ([question])"
                log_and_message_admins("cancelled the running '[votedesc]' vote.")
                reset()
        if("toggle_restart")
            if(admin)
                GLOB.configuration.vote.allow_restart_votes = !GLOB.configuration.vote.allow_restart_votes
                log_and_message_admins("has [GLOB.configuration.vote.allow_restart_votes ? "enabled" : "disabled"] public restart voting.")
        if("toggle_gamemode")
            if(admin)
                GLOB.configuration.vote.allow_mode_votes = !GLOB.configuration.vote.allow_mode_votes
                log_and_message_admins("has [GLOB.configuration.vote.allow_mode_votes ? "enabled" : "disabled"] public gamemode voting.")
        if("restart")
            if(GLOB.configuration.vote.allow_restart_votes || admin)
                initiate_vote("restart",usr.key)
        if("gamemode")
            if(GLOB.configuration.vote.allow_mode_votes || admin)
                initiate_vote("gamemode",usr.key)
        if("map")
            if(admin)
                initiate_vote("map", usr.key)
        if("crew_transfer")
            if(GLOB.configuration.vote.allow_restart_votes || admin)
                initiate_vote("crew transfer", usr.key)
        if("custom")
            if(admin)
                initiate_vote("custom",usr.key)
        else
            submit_vote(usr.ckey, round(text2num(href_list["vote"])))
            update_panel(usr.client)
            return
    usr.vote()


/mob/verb/vote()
    set category = "OOC"
    set name = "Vote"

    if(SSvote)
        SSvote.browse_to(client)
