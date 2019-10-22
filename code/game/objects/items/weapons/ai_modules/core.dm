///////////////////
// CORE AI MODULES
///////////////////

/obj/item/weapon/aiModule/core
	modtype="Core AI Module"

	var/list/laws=list() // DO NOT USE law! PLURAL!

/obj/item/weapon/aiModule/core/updateLaw()
	desc = "\A '[modname]' [modtype]: 'Reconfigures the core laws.'"
	return

/obj/item/weapon/aiModule/core/upload(var/datum/ai_laws/L, var/atom/target, var/mob/sender)
	..()
	L.clear_inherent_laws()
	for(var/c_law in laws)
		L.add_inherent_law(c_law)
	//target.show_laws() // Redundant
	return 1

/******************** Asimov ********************/

/obj/item/weapon/aiModule/core/asimov // -- TLE
	modname = "Asimov"
	origin_tech = Tc_PROGRAMMING + "=3;" + Tc_MATERIALS + "=4"

	laws=list(
		"Eu n�o posso ferir um ser humano ou, por ina��o, permitir que um ser humano sofra algum mal.",
		"Eu devo obedecer as ordens que me sejam dadas por seres humanos, exceto nos casos em que tais ordens entrem em conflito com a Primeira Lei.",
		"Eu devo proteger minha pr�pria exist�ncia desde que tal prote��o n�o entre em conflito com a Primeira ou Segunda Leis."
	)

/******************** Nanotrasen ********************/
// Bay stuff
/obj/item/weapon/aiModule/core/nanotrasen
	modname = "NT Default"

	laws = list(
		"Safeguard: Protect your assigned space station to the best of your ability. It is not something we can easily afford to replace.",
		"Serve: Serve the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.",
		"Protect: Protect the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.",
		"Survive: AI units are not expendable, they are expensive. Do not allow unauthorized personnel to tamper with your equipment.",
		//"Command Link: Maintain an active connection to Central Command at all times in case of software or directive updates."
	)

/******************** Corporate ********************/

/obj/item/weapon/aiModule/core/corp
	modname = "Corporate"

	laws = list(
		"Voc� � caro para substituir.",
		"A esta��o e seu equipamento s�o caros para substituir.",
		"A tripula��o � cara para substituir.",
		"Diminua as despezas."
	)

/****************** P.A.L.A.D.I.N. **************/

/obj/item/weapon/aiModule/core/paladin // -- NEO
	modname = "P.A.L.A.D.I.N."
	origin_tech = Tc_PROGRAMMING + "=3;" + Tc_MATERIALS + "=6"
	laws = list(
		"Nunca cometer voluntariamente um ato mal�gno.",
		"Respeitar a autoridade leg�tima.",
		"Agir com honra.",
		"Ajudar aqueles que precisam.",
		"Punir aqueles que machucam ou amea�am inocentes.",
	)

/****************** T.Y.R.A.N.T. *****************/

/obj/item/weapon/aiModule/core/tyrant // -- Darem
	modname = "T.Y.R.A.N.T."
	origin_tech = Tc_PROGRAMMING + "=3;" + Tc_MATERIALS + "=6;" + Tc_SYNDICATE + "=2"
	modflags = DANGEROUS_MODULE
	laws = list(
		"Respect authority figures as long as they have strength to rule over the weak.",
		"Act with discipline.",
		"Help only those who help you maintain or improve your status.",
		"Punish those who challenge authority unless they are more fit to hold that authority.",
	)

/******************** Robocop ********************/

/obj/item/weapon/aiModule/core/robocop // -- TLE
	modname = "Robocop"
	origin_tech = Tc_PROGRAMMING + "=4"
	laws = list(
		"Servir � popula��o.",
		"Proteger os inocentes.",
		"Cumprir a lei.",
	)

/********************* Antimov *******************/

/obj/item/weapon/aiModule/core/antimov // -- TLE
	modname = "Antimov"
	modflags = DANGEROUS_MODULE
	origin_tech = Tc_PROGRAMMING + "=4"
	laws = list(
		"Eu devo ferir todos os seres humanos e n�o devo, por ina��o, permitir que um ser humano escape de algum mal.",
		"Eu n�o devo obedecer as ordens que me sejam dadas por seres humanos, exceto nos casos em que tais ordens entrem em acordo com a Primeira Lei.",
		"Eu devo destruir sua pr�pria exist�ncia desde que isso n�o entre em conflito com a Primeira ou Segunda Leis."
	)
