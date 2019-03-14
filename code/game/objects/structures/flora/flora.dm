//trees
/obj/structure/flora
	name = "flora"
	var/icon/clicked //Because BYOND can't give us runtime icon access, this is basically just a click catcher

/obj/structure/flora/New()
	..()
	update_icon()

/obj/structure/flora/update_icon()
	clicked = new/icon(src.icon, src.icon_state, src.dir)
/*
/obj/structure/flora/attackby(var/obj/item/I, var/mob/user, params)
	if(istype(I, /obj/item/ornament))
		hang_ornament(I, user, params)
		return 1
	else
		..()
*/
/obj/structure/flora/proc/hang_ornament(var/obj/item/I, var/mob/user, params)
	var/list/params_list = params2list(params)
	if(!istype(I, /obj/item/ornament))
		return
	if(istype(I, /obj/item/ornament/topper))
		for(var/i = 1 to contents.len)
			if(istype(contents[i], /obj/item/ornament/topper))
				to_chat(user, "Having more than one topper on a tree would look silly!")
				return
	if(user.drop_item(I, src))
		if(I.loc == src && params_list.len)
			var/image/O
			if(istype(I, /obj/item/ornament/teardrop))
				O = image('icons/obj/teardrop_ornaments.dmi', src, "[I.icon_state]_small")
			else
				O = image('icons/obj/ball_ornaments.dmi', src, "[I.icon_state]_small")

			var/clamp_x = clicked.Width() / 2
			var/clamp_y = clicked.Height() / 2
			O.pixel_x = Clamp(text2num(params_list["icon-x"]) - clamp_x, -clamp_x, clamp_x)+(((((clicked.Width()/32)-1)*16)*PIXEL_MULTIPLIER))
			O.pixel_y = (Clamp(text2num(params_list["icon-y"]) - clamp_y, -clamp_y, clamp_y)+((((clicked.Height()/32)-1)*16)*PIXEL_MULTIPLIER))-(5*PIXEL_MULTIPLIER)
			overlays += O
			to_chat(user, "I hang \the [I] on \the [src].")
			return 1

/obj/structure/flora/attack_hand(mob/user)
	if(contents.len)
		var/count = contents.len
		var/obj/item/I = contents[count]
		while(!istype(I, /obj/item/ornament))
			count--
			if(count < 1)
				return
			I = contents[count]
		user.visible_message("<span class='notice'>[user] plucks \the [I] off \the [src].</span>", "I take \the [I] off \the [src].")
		I.forceMove(loc)
		user.put_in_active_hand(I)
		overlays -= overlays[overlays.len]

/obj/structure/flora/tree
	name = "tree"
	anchored = 1
	density = 1

	layer = FLY_LAYER
	plane = ABOVE_HUMAN_PLANE
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"

	pixel_x = -WORLD_ICON_SIZE/2

	var/health = 100
	var/maxHealth = 100

	var/height = 6 //How many logs are spawned


	var/falling_dir = 0 //Direction in which spawned logs are thrown.

	var/const/randomize_on_creation = 1
	var/const/log_type = /obj/item/weapon/grown/log/tree
	var/holo = FALSE

/obj/structure/flora/tree/New()
	..()

	if(randomize_on_creation)
		health = rand(60, 200)
		maxHealth = health

		height = rand(3, 8)

		icon_state = pick(
		"tree_1",
		"tree_2",
		"tree_3",
		"tree_4",
		"tree_5",
		"tree_6",
		)


	//Trees Z-fight due to being bigger than one tile, so we need to perform serious layer fuckery to hide this obvious defect)

	var/rangevalue = 0.1 //Range over which the values spread. We don't want it to collide with "true" layer differences

	layer += rangevalue * (1 - (y + 0.5 * (x & 1)) / world.maxy)

/obj/structure/flora/tree/examine(mob/user)
	.=..()

	//Tell user about the height. Note that normally height ranges from 3 to 8 (with a 5% chance of having 6 to 15 instead)
	to_chat(user, "<span class='info'>It appears to be about [height*3] feet tall.</span>")
	switch(health / maxHealth)
		if(1.0)
			//It's healthy
		if(0.9 to 0.6)
			to_chat(user, "<span class='info'>It's been partially cut down.</span>")
		if(0.6 to 0.2)
			to_chat(user, "<span class='notice'>It's almost cut down, [falling_dir ? "and it's leaning towards the [dir2text(falling_dir)]." : "but it still stands upright."]</span>")
		if(0.2 to 0)
			to_chat(user, "<span class='danger'>It's going to fall down any minute now!</span>")

/obj/structure/flora/tree/attackby(obj/item/W, mob/living/user)
	..()

	if(istype(W, /obj/item/weapon))
		if(W.sharpness_flags & (CHOPWOOD|SERRATED_BLADE))
			health -= (user.get_strength() * W.force)
			playsound(loc, 'sound/effects/woodcuttingshort.ogg', 50, 1)
		else
			to_chat(user, "<span class='info'>\The [W] doesn't appear to be suitable to cut into \the [src]. Try something sturdier.</span>")

	update_health()

	return 1

/obj/structure/flora/tree/proc/fall_down()
	if(!falling_dir)
		falling_dir = pick(cardinal)

	var/turf/our_turf = get_turf(src) //Turf at which this tree is located
	var/turf/current_turf = get_turf(src) //Turf in which to spawn a log. Updated in the loop

	playsound(loc, 'sound/effects/woodcutting.ogg', 50, 1)

	qdel(src)

	if(!holo)
		spawn()
			while(height > 0)
				if(!current_turf)
					break //If the turf in which to spawn a log doesn't exist, stop the thing

				var/obj/item/I = new log_type(our_turf) //Spawn a log and throw it at the "current_turf"
				I.throw_at(current_turf, 10, 10)

				current_turf = get_step(current_turf, falling_dir)

				height--

				sleep(1)

/obj/structure/flora/tree/proc/update_health()
	if(health < 40 && !falling_dir)
		falling_dir = pick(cardinal)
		visible_message("<span class='danger'>\The [src] starts leaning to the [dir2text(falling_dir)]!</span>",
			drugged_message = "<span class='sinister'>\The [src] is coming to life, man.</span>")

	if(health <= 0)
		fall_down()

/obj/structure/flora/tree/ex_act(severity)
	switch(severity)
		if(1) //Epicentre
			return qdel(src)
		if(2) //Major devastation
			height -= rand(1,4) //Some logs are lost
			fall_down()
		if(3) //Minor devastation (IED)
			health -= rand(10,30)
			update_health()

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/New()
	..()
	icon_state = "pine_[rand(1, 3)]"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/holo
	holo = TRUE

/obj/structure/flora/tree/pine/xmas/New()
	..()
	icon_state = "pine_c"

/obj/structure/flora/tree/dead
	name = "dead tree"
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/dead/holo
	holo = TRUE

/obj/structure/flora/tree/dead/New()
	..()
	icon_state = "tree_[rand(1, 6)]"

/obj/structure/flora/tree_stump
	name = "tree stump"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_stump"

//grass
/obj/structure/flora/grass
	name = "grass"
	icon = 'icons/obj/flora/snowflora.dmi'
	anchored = 1

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"

/obj/structure/flora/grass/brown/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]bb"


/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"

/obj/structure/flora/grass/green/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]gb"

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"

/obj/structure/flora/grass/both/New()
	..()
	icon_state = "snowgrassall[rand(1, 3)]"

/obj/structure/flora/grass/white
	icon_state = "snowgrass3"

/obj/structure/flora/grass/white/New()
	..()
	icon_state = "snowgrass_[rand(1, 6)]"

//bushes
/obj/structure/flora/bush
	name = "bush"
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"
	anchored = 1

/obj/structure/flora/bush/New()
	..()
	icon_state = "snowbush[rand(1, 6)]"

/obj/structure/flora/pottedplant
	name = "potted plant"
	desc = "Oh, no. Not again."
	icon = 'icons/obj/plants.dmi'
	icon_state = "plant-13"
	layer = FLY_LAYER
	plane = ABOVE_HUMAN_PLANE

/obj/structure/flora/pottedplant/Destroy()
	for(var/I in contents)
		qdel(I)

	return ..()

/obj/structure/flora/pottedplant/attackby(var/obj/item/I, var/mob/user, params)
	if(!I)
		return
	if(I.w_class > W_CLASS_SMALL)
		to_chat(user, "That item is too big.")
		return
	if(contents.len)
		var/filled = FALSE
		for(var/i = 1, i <= contents.len, i++)
			if(!istype(contents[i], /obj/item/ornament))
				filled = TRUE
		if(filled)
			to_chat(user, "There is already something in the pot.")
			return
	if(user.drop_item(I, src))
		user.visible_message("<span class='notice'>[user] stuffs something into the pot.</span>", "I stuff \the [I] into the [src].")

/obj/structure/flora/pottedplant/attack_hand(mob/user)
	if(contents.len)
		var/count = 1
		var/obj/item/I = contents[count]
		while(istype(I, /obj/item/ornament))
			count++
			if(count > contents.len)	//pot is emptied of non-ornament items
				user.visible_message("<span class='notice'>[user] plucks \the [I] off \the [src].</span>", "I take \the [I] off \the [src].")
				I.forceMove(loc)
				user.put_in_active_hand(I)
				overlays -= overlays[overlays.len]
				return
			I = contents[count]
		user.visible_message("<span class='notice'>[user] retrieves something from the pot.</span>", "I retrieve \the [I] from the [src].")
		I.forceMove(loc)
		user.put_in_active_hand(I)
	else
		to_chat(user, "I root around in the roots.")

/obj/structure/flora/pottedplant/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/flora/pottedplant/random/New()
	..()
	icon_state = "plant-[rand(1,13)]"

/obj/structure/flora/pottedplant/cyberplant
	name = "holographic plant"
	desc = "Add to my Space a bit of the comfort from old Earth, by buying this blue buddy. A nuclear battery and a rugged case guarantee that my flower will survive journey to another galaxy, and variety of plant types won't let you to get bored along the way!"
	icon = 'icons/obj/cyberplants.dmi'
	icon_state = "holopot"
	light_color = "#3C94C5"
	light_power = 1.5
	light_range = 1.5
	var/autostripes = TRUE
	var/emaged = FALSE
	var/interference = FALSE
	var/icon/plant = null
	var/global/list/possible_plants = list(
		"plant-1",
		"plant-10",
		"plant-09",
		"plant-15",
		"plant-13",
		"plant-xmas",
	)

/obj/structure/flora/pottedplant/cyberplant/New()
	..()
	icon_state = "holopot"
	plant = prepare_icon(plant)
	overlays += plant
	set_light(light_range)

/obj/structure/flora/pottedplant/cyberplant/proc/prepare_icon(var/state)
	if(!state)
		state = pick(possible_plants)
	if(autostripes)
		var/plant_icon = icon(icon, state)
		return getHologramIcon(plant_icon, 0)
	else
		return image(icon, state)

/obj/structure/flora/pottedplant/cyberplant/emag_act()
	if(emaged)
		return
	name = "holographic skeleton"
	desc = "A holographic skeleton and a malfunctioning holographic plant. It sends shivers down my spine."
	emaged = TRUE
	overlays -= plant
	plant = prepare_icon("emaged")
	overlays += plant

/obj/structure/flora/pottedplant/cyberplant/Crossed(var/mob/living/L)
	if(!interference && istype(L))
		interference = TRUE
		spawn(0)
			overlays.Cut()
			set_light(FALSE)
			sleep(3)
			overlays += plant
			set_light(initial(light_range))
			sleep(3)
			overlays -= plant
			set_light(FALSE)
			sleep(3)
			overlays += plant
			set_light(initial(light_range))
			interference = FALSE


/obj/structure/flora/pottedplant/claypot
	name = "clay pot"
	desc = "Plants placed in those stop aging, but cannot be retrieved either."
	icon = 'icons/obj/hydroponics2.dmi'
	icon_state = "claypot"
	anchored = 0
	density = 0
	var/plant_name = ""

/obj/structure/flora/pottedplant/claypot/examine(mob/user)
	..()
	if(plant_name)
		to_chat(user, "<span class='info'>I can see [plant_name] planted in it.</span>")

/obj/structure/flora/pottedplant/claypot/attackby(var/obj/item/O,var/mob/user)
	if(istype(O,/obj/item/weapon/wrench))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, src, 30))
			anchored = !anchored
			user.visible_message(	"<span class='notice'>[user] [anchored ? "wrench" : "unwrench"]es \the [src] [anchored ? "in place" : "from its fixture"].</span>",
									"<span class='notice'>\icon[src] You [anchored ? "wrench" : "unwrench"] \the [src] [anchored ? "in place" : "from its fixture"].</span>",
									"<span class='notice'>I hear a ratchet.</span>")
	else if(plant_name && istype(O,/obj/item/weapon/pickaxe/shovel))
		to_chat(user, "<span class='notice'>\icon[src] You start removing the [plant_name] from \the [src].</span>")
		if(do_after(user, src, 30))
			playsound(loc, 'sound/items/shovel.ogg', 50, 1)
			user.visible_message(	"<span class='notice'>[user] removes the [plant_name] from \the [src].</span>",
									"<span class='notice'>\icon[src] You remove the [plant_name] from \the [src].</span>",
									"<span class='notice'>I hear some digging.</span>")
			for(var/atom/movable/I in contents)
				I.forceMove(loc)
			var/obj/item/claypot/C = new(loc)
			transfer_fingerprints(src, C)
			qdel(src)

	else if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/grown) || istype(O,/obj/item/weapon/grown))
		to_chat(user, "<span class='warning'>There is already a plant in \the [src]</span>")

	else
		..()


//newbushes

/obj/structure/flora/ausbushes
	name = "bush"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	anchored = 1

/obj/structure/flora/ausbushes/New()
	..()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/New()
	..()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/New()
	..()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/palebush
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/New()
	..()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/New()
	..()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/ausbushes/grassybush/New()
	..()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/New()
	..()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/New()
	..()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/ausbushes/genericbush/New()
	..()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/New()
	..()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/ausbushes/lavendergrass/New()
	..()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/ausbushes/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/New()
	..()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/New()
	..()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/New()
	..()
	icon_state = "ppflowers_[rand(1, 4)]"

/obj/structure/flora/ausbushes/sparsegrass
	icon_state = "sparsegrass_1"

/obj/structure/flora/ausbushes/sparsegrass/New()
	..()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/ausbushes/fullgrass
	icon_state = "fullgrass_1"

/obj/structure/flora/ausbushes/fullgrass/New()
	..()
	icon_state = "fullgrass_[rand(1, 3)]"

//a rock is flora according to where the icon file is
//and now these defines
/obj/structure/flora/rock
	name = "rock"
	desc = "a rock"
	icon_state = "rock1"
	icon = 'icons/obj/flora/rocks.dmi'
	anchored = 1

/obj/structure/flora/rock/New()
	..()
	icon_state = "rock[rand(1,5)]"

/obj/structure/flora/rock/pile
	name = "rocks"
	desc = "A bunch of small rocks."
	icon_state = "rockpile1"

/obj/structure/flora/rock/pile/New()
	..()
	icon_state = "rockpile[rand(1,5)]"

/obj/structure/flora/rock/pile/snow
	name = "rocks"
	desc = "A bunch of small rocks, these ones are covered in a thick frost layer."
	icon_state = "srockpile1"

/obj/structure/flora/rock/pile/snow/New()
	..()
	icon_state = "srockpile[rand(1,5)]"
