/obj/machinery/atmospherics/pipe/simple/visible
    icon_state = "intact"
    level = 2

/obj/machinery/atmospherics/pipe/simple/visible/scrubbers
    name = "Scrubbers pipe"
    desc = "A one meter section of scrubbers pipe"
    icon_state = "intact-scrubbers"
    connect_types = list(3)
    layer = 2.38
    icon_connect_type = "-scrubbers"
    color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/scrubbers/detailed_examine()
    return "This is a special 'scrubber' pipe, which does not connect to 'normal' pipes. If you want to connect it, use \
            a Universal Adapter pipe."

/obj/machinery/atmospherics/pipe/simple/visible/supply
    name = "Air supply pipe"
    desc = "A one meter section of supply pipe"
    icon_state = "intact-supply"
    connect_types = list(2)
    layer = 2.39
    icon_connect_type = "-supply"
    color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/visible/supply/detailed_examine()
    return "This is a special 'supply' pipe, which does not connect to 'normal' pipes. If you want to connect it, use \
            a Universal Adapter pipe."

/obj/machinery/atmospherics/pipe/simple/visible/yellow
    color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/visible/cyan
    color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/visible/green
    color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/simple/visible/purple
    color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/simple/visible/red
    color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/blue
    color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/visible/universal
    name="Universal pipe adapter"
    desc = "An adapter for regular, supply and scrubbers pipes"
    connect_types = list(1,2,3)
    icon_state = "map_universal"

/obj/machinery/atmospherics/pipe/simple/visible/universal/detailed_examine()
    return "This allows you to connect 'normal' pipes, red 'scrubber' pipes, and blue 'supply' pipes."

/obj/machinery/atmospherics/pipe/simple/visible/universal/update_icon(safety = 0)
    ..()

    if(!check_icon_cache())
        return

    alpha = 255

    overlays.Cut()
    overlays += SSair.icon_manager.get_atmos_icon("pipe", , pipe_color, "universal")
    underlays.Cut()

    if(node1)
        universal_underlays(node1)
        if(node2)
            universal_underlays(node2)
        else
            var/node1_dir = get_dir(node1,src)
            universal_underlays(,node1_dir)
    else if(node2)
        universal_underlays(node2)
    else
        universal_underlays(,dir)
        universal_underlays(,turn(dir, -180))

/obj/machinery/atmospherics/pipe/simple/visible/universal/update_underlays()
    ..()
    update_icon()
