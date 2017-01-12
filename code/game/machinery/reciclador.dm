#define SAFETY_COOLDOWN 100

/obj/machinery/recycler
	name = "crusher"
	desc = "A large crushing machine which is used to recycle small items ineffeciently; there are lights on the side of it."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	plane = ABOVE_HUMAN_PLANE
	anchored = 1
	density = 1
	var/safety_mode = 0 // Temporality stops the machine if it detects a mob
	var/grinding = 0
	var/icon_name = "grinder-o"
	var/blood = 0
	var/eat_dir = WEST

/obj/machinery/recycler/New()
	// On us
	..()
	update_icon()

/obj/machinery/recycler/examine(var/mob/user)
	..()
	to_chat(user, "The power light is [(stat & NOPOWER) ? "off" : "on"].")
	to_chat(user, "The safety-mode light is [safety_mode ? "on" : "off"].")
	to_chat(user, "The safety-sensors status light is [emagged ? "off" : "on"].")

/obj/machinery/recycler/power_change()
	..()
	update_icon()


/obj/machinery/recycler/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/card/emag) && !emagged)
		emagged = 1
		if(safety_mode)
			safety_mode = 0
			update_icon()
		playsound(src.loc, "sparks", 75, 1, -1)
	else if(istype(I, /obj/item/weapon/screwdriver) && emagged)
		emagged = 0
		update_icon()
		playsound(src.loc, "sparks", 75, 1, -1)
		to_chat("<span class='notice'>You reset the crusher to its default factory settings.</span>", user)
	else
		..()
		return
	add_fingerprint(user)

/obj/machinery/recycler/update_icon()
	..()
	var/is_powered = !(stat & (BROKEN|NOPOWER))
	if(safety_mode)
		is_powered = 0
	icon_state = icon_name + "[is_powered]" + "[(blood ? "bld" : "")]" // add the blood tag at the end

// This is purely for admin possession !FUN!.
/obj/machinery/recycler/Bump(var/atom/movable/AM)
	..()
	if(AM)
		Bumped(AM)


/obj/machinery/recycler/Cross(var/atom/movable/AM)

	if(stat & (BROKEN|NOPOWER))
		return 0

	if(safety_mode)
		return 0
	// If we're not already grinding something.
	if(!grinding)
		grinding = 1
		spawn(1)
			grinding = 0
	else
		return 0

	var/move_dir = get_dir(loc, AM.loc)
	if(move_dir == eat_dir)
		if(isliving(AM))
			if(emagged)
				eat(AM)
			else
				stop(AM)
		else if(istype(AM, /obj/item))
			_recycle(AM)
		else // Can't recycle
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			AM.loc = src.loc

/obj/machinery/recycler/proc/_recycle(var/obj/item/I, var/sound = 1)
	I.forceMove(loc)

	if(!istype(I, /obj/item/weapon/disk/nuclear))
		qdel(I)
		if(prob(25))
			new /obj/item/stack/sheet/metal(loc)
		if(prob(20))
			new /obj/item/stack/sheet/glass/glass(loc)
		if(prob(5))
			new /obj/item/stack/sheet/plasteel(loc)
		if(prob(5))
			new /obj/item/stack/sheet/glass/rglass(loc)
		if(sound)
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)


/obj/machinery/recycler/proc/stop(var/mob/living/L)
	playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
	safety_mode = 1
	update_icon()
	L.forceMove(loc)

	spawn(SAFETY_COOLDOWN)
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
		safety_mode = 0
		update_icon()

/obj/machinery/recycler/proc/eat(var/mob/living/L)

	L.forceMove(loc)

	if(issilicon(L))
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	else
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)

	var/gib = 1
	// By default, the emagged recycler will gib all non-carbons. (human simple animal mobs don't count)
	if(iscarbon(L))
		gib = 0
		if(L.stat == CONSCIOUS)
			L.audible_scream()
		add_blood(L)

	if(!blood && !issilicon(L))
		blood = 1
		update_icon()

	// Remove and recycle the equipped items.
	for(var/obj/item/I in L.get_equipped_items())
		L.drop_from_inventory(I)
		_recycle(I, 0)

	// Instantly lie down, also go unconscious from the pain, before you die.
	L.Paralyse(5)

	// For admin fun, var edit emagged to 2.
	if(gib || emagged == 2)
		L.gib()
	else if(emagged == 1)
		L.adjustBruteLoss(1000)

#undef SAFETY_COOLDOWN

/obj/item/weapon/paper/recycler
	name = "paper - 'instru��es'"
	info = "<h2>Novo Zelador</h2> O seu trabalho � coletar o lixo da esta��o encontrado nas lixeiras e o reciclar no reciclador na manuten��o ao lado de sua sala. Os tripulantes colocar�o o lixo nas lixeiras e voc� ter� de coletar.<br><br>Use a m�quina de reciclagem na manuten��o a direita de sua sala para conseguir min�rios e delivere esses pra cargo ou pra engenharia quando tiver bastante. Voc� � a nossa �ltima esperan�a para uma esta��o limpa! Contamos com voc�!"