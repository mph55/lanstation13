/obj/effect/decal/cleanable
	var/list/random_icon_states = list()
	var/targeted_by = null	//Used so cleanbots can claim a mess.
	mouse_opacity = 0 //N3X made this 0, which made it impossible to click things, and in the current 510 version right-click things.
	w_type = NOT_RECYCLABLE
	anchored = 1

	// For tracking shit across the floor.
	var/amount=0 // 0 = don't track
	var/counts_as_blood=0 // Cult
	var/transfers_dna=0
	var/list/viruses = list()
	blood_DNA = list()
	var/basecolor=DEFAULT_BLOOD // Color when wet.
	var/list/datum/disease2/disease/virus2 = list()
	var/list/absorbs_types=list() // Types to aggregate.

	var/on_wall = 0 //Wall on which this decal is placed on

/obj/effect/decal/cleanable/New()
	if(random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	..()


/obj/effect/decal/cleanable/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O,/obj/item/weapon/mop))
		return ..()
	return 0 //No more "X HITS THE BLOOD WITH AN RCD"

/obj/effect/decal/cleanable/Destroy()
	blood_list -= src
	for(var/datum/disease/D in viruses)
		D.cure(0)
		D.holder = null

	if(counts_as_blood)
		var/datum/game_mode/cult/cult_round = find_active_mode("cult")
		if(cult_round)
			var/turf/T = get_turf(src)
			if(T && (T.z == map.zMainStation))
				cult_round.bloody_floors -= T
				cult_round.blood_check()
	..()

/obj/effect/decal/cleanable/proc/dry()
	name = "dried [src.name]"
	desc = "It's dry and crusty. Someone is not doing their job."
	color = adjust_brightness(color, -50)
	amount = 0

/obj/effect/decal/cleanable/Crossed(mob/living/carbon/human/perp)
	if(amount > 0)
		add_blood_to(perp, amount)

/obj/effect/decal/cleanable/attack_hand(mob/living/carbon/human/user)
	..()
	if (amount && istype(user))
		add_fingerprint(user)
		if (user.gloves)
			return
		var/taken = rand(1,amount)
		amount -= taken
		to_chat(user, "<span class='notice'>You get some of \the [src] on your hands.</span>")
		if(transfers_dna)
			if (!user.blood_DNA)
				user.blood_DNA = list()
			user.blood_DNA |= blood_DNA.Copy()
		user.bloody_hands += taken
		user.hand_blood_color = basecolor
		user.update_inv_gloves(1)
		user.verbs += /mob/living/carbon/human/proc/bloody_doodle

/obj/effect/decal/cleanable/resetVariables()
	Destroy()
	..("viruses","virus2", "blood_DNA", "random_icon_states", args)
	viruses = list()
	virus2 = list()
	blood_DNA = list()

/obj/effect/decal/cleanable/New()
	..()
	blood_list += src
	update_icon()

	if(counts_as_blood)
		var/datum/game_mode/cult/cult_round = find_active_mode("cult")
		if(cult_round)
			var/turf/T = get_turf(src)
			if(T && (T.z == map.zMainStation))//F I V E   T I L E S
				if(!(locate("\ref[T]") in cult_round.bloody_floors))
					cult_round.bloody_floors += T
					cult_round.bloody_floors[T] = T
					cult_round.blood_check()
		if(src.loc && isturf(src.loc))
			for(var/obj/effect/decal/cleanable/C in src.loc)
				if(C.type in absorbs_types && C != src)
					// Transfer DNA, if possible.
					if (transfers_dna && C.blood_DNA)
						blood_DNA |= C.blood_DNA.Copy()
					amount += C.amount
					returnToPool(C)

/obj/effect/decal/cleanable/proc/messcheck(var/obj/effect/decal/cleanable/M)
	return 1


/obj/effect/decal/cleanable/proc/add_blood_to(var/mob/living/carbon/human/perp, var/amount)
	if (!istype(perp))
		return

	if(amount < 1)
		return

	if(perp.shoes)
		var/obj/item/clothing/shoes/S = perp.shoes
		S.track_blood = max(0, amount, S.track_blood)	//Adding blood to the item
		add_blood_overlay_to_clothing(perp.shoes, amount)
		perp.update_inv_shoes(TRUE)
	else if(perp.lying)
		if(perp.wear_suit)
			add_blood_overlay_to_clothing(perp.wear_suit, amount)
			perp.update_inv_wear_suit(TRUE)
		else if(perp.w_uniform)
			add_blood_overlay_to_clothing(perp.w_uniform, amount)
			perp.update_inv_w_uniform(TRUE)
	else
		perp.track_blood = max(amount, 0, perp.track_blood) //Or feet
		if(!perp.feet_blood_DNA)
			perp.feet_blood_DNA = list()
		if(!istype(blood_DNA, /list))
			blood_DNA = list()
		else
			perp.feet_blood_DNA |= blood_DNA.Copy()
		perp.feet_blood_color=basecolor

	amount--

/obj/effect/decal/cleanable/proc/add_blood_overlay_to_clothing(var/obj/item/clothing/C, var/amount)
	if(!blood_overlays[C.type]) //If there isn't a precreated blood overlay make one
		C.generate_blood_overlay()

	if(C.blood_overlay != null) // Just if(blood_overlay) doesn't work.  Have to use isnull here.
		C.overlays.Remove(C.blood_overlay)
	else
		C.blood_overlay = blood_overlays[C.type]

	C.blood_overlay.color = basecolor
	C.overlays += C.blood_overlay
	C.blood_color=basecolor

	if(!C.blood_DNA)
		C.blood_DNA = list()
	if(blood_DNA)
		C.blood_DNA |= blood_DNA.Copy()
