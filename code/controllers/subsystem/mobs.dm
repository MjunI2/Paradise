SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = FIRE_PRIORITY_MOBS
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	offline_implications = "Mobs will no longer process. Immediate server restart recommended."

	var/list/currentrun = list()
	var/static/list/clients_by_zlevel[][]
	var/static/list/dead_players_by_zlevel[][] = list(list()) // Needs to support zlevel 1 here, MaxZChanged only happens when z2 is created and new_players can login before that.
	var/static/list/cubemonkeys = list()

/datum/controller/subsystem/mobs/stat_entry()
	..("P:[GLOB.mob_list.len]")

/datum/controller/subsystem/mobs/Initialize(start_timeofday)
	clients_by_zlevel = new /list(world.maxz,0)
	dead_players_by_zlevel = new /list(world.maxz,0)
	return ..()

/datum/controller/subsystem/mobs/fire(resumed = 0)
	var/seconds = wait * 0.1
	if(!resumed)
		src.currentrun = GLOB.mob_list.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--
		if(M)
			M.Life(seconds, times_fired)
		else
			GLOB.mob_list.Remove(M)
		if(MC_TICK_CHECK)
			return
