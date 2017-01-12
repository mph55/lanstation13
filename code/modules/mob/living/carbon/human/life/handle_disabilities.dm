//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_disabilities()
	if(disabilities & EPILEPSY)
		if((prob(1)) && (paralysis < 1))
			visible_message("<span class='danger'>\[src] come�a a ter um ataque epil�ptico!</span>", \
							"<span class='warning'>Voc� tem um ataque!</span>")
			Paralyse(10)
			Jitter(1000) //Godness

	//If we have the gene for being crazy, have random events.
	if(dna.GetSEState(HALLUCINATIONBLOCK))
		if(prob(1) && hallucination < 1)
			hallucination += 20

	if(disabilities & COUGHING)
		if((prob(5) && paralysis <= 1))
			drop_item()
			audible_cough(src)
	if(disabilities & TOURETTES)
		if((prob(10) && paralysis <= 1))
			//Stun(10)
			switch(rand(1, 9))
				if(1)
					emote("pigarreia")
				if(2)
					emote("come�a a tremer")
				if(3)
					emote("faz barulhos estranhos")
				if(4 to 9)
					say("[prob(50) ? ";" : ""][pick("MERDA", "BOSTA", "PUTA QUE PARIU", "FILHO DA PUTA", "SUGADOR DE CARALHOS", "PORRA", "BUCETA", "CORNO", "QUEIJIN MINAS", "C�", "EU QUERO � FUDER", "MERDALHER", "VAGABUNDA", "COMPLETAMENTE RIVOTRILADO", "CUCKOLD")]")

			var/x_offset_change = rand(-2,2) * PIXEL_MULTIPLIER
			var/y_offset_change = rand(-1,1) * PIXEL_MULTIPLIER

			animate(src, pixel_x = (pixel_x + x_offset_change), pixel_y = (pixel_y + y_offset_change), time = 1)
			animate(pixel_x = (pixel_x - x_offset_change), pixel_y = (pixel_y - y_offset_change), time = 1)

	if(getBrainLoss() >= 60 && stat != DEAD)
		if(prob(3))
			switch(pick(1,2,3)) //All of those REALLY ought to be variable lists, but that would be too smart I guess
				if(1)
					say(pick("haha, esquece, eu gosto de chupar pintos", \
					"se a terra eh uma esferica por que a agua naum cai?", \
					"O CAPIT�O � UM PRESERVATIVO", "[pick("", "manda chamar o viado do")] [pick("somelia", "milha", "mirolha", "esmeralha")]", \
					"algu�m mim d� [pick("telikesis","huque","epilapsia", "choquito")]?", \
					"me v� 2 kilos de mu�arela, por favor", "bis s�o os melhores de todos os mundos>", \
					"macaquinho bonitinho", "N�O TOCA EM MIM!!!!", \
					"SAI DAQUI CARALHO REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"))
				if(2)
					say(pick("EMERSON EDUARDO RODRIGUES SETIM MATOU ROG�RIO GASPAR!!", \
						"VOC�S N�O CONSEGUEM PENETRAR MEU PROLAPSO T�O R�PIDO QUANTO EU GOSTARIA!", \
						"minha cara quando", \
						"deixem o macaco em paz", \
						"esses an�es viu, sei n�o", \
						"mija a� que eu tomo aqui", \
						"acalmisi respiri fundo", \
						"to trancado", \
						"ei vei advinha vou sair daqui", \
						"quando eu sai vou pegar essa arma e te mata", \
						"temos tres pe�oas na area de evacuassaum", \
						"ta vendo ces sao tudo racista", \
						"seus bando de doente", \
						"me fas o remedio de selebro", \
						"cres�a crian�a", \
						"sou inteligente demais para trabalhar", \
						"voce nao eh dur�o ne", \
						"FINALMENTE PUTARIA!", \
						"DIMENSION", \
						"o qu�����?????", \
						"fiquei com medo deles e de voc�", \
						"estamos sem material sirurg�co , e vamos ter que ir na medbay comprar", \
						"qualquer coisa vc me liga ou manda um email (dr_nettoh@homail.com) fone: xxxx.xxxx", \
						"o que vc esta dizendo porraaaaa", \
						"meu deusssss", \
						"Por favor nao tire a vida dos seus filho(a) D� a chance deles viver como vc teve a sua.", \
						"comotira as augemas", \
						"prendi o sapato", \
						"pelo amor de deus algu�m chama a seguran�a"))
				if(3)
					emote("come�a a babar")

	if(species.name == "Tajaran")
		if(prob(1)) //Was 3
			vomit(1) //Hairball

	if(stat != DEAD)
		var/rn = rand(0, 200) //This is fucking retarded, but I'm only doing sanitization, I don't have three months to spare to fix everything
		if(getBrainLoss() >= 5)
			if(0 <= rn && rn <= 3)
				custom_pain("Voc� sente fortes dores de cabe�a.")
		if(getBrainLoss() >= 15)
			if(4 <= rn && rn <= 6)
				if(eye_blurry <= 0)
					to_chat(src, "<span class='warning'>Voc� tem dificuldades para enxergar.</span>")
					eye_blurry = 10
		if(getBrainLoss() >= 35)
			if(7 <= rn && rn <= 9)
				if(get_active_hand())
					to_chat(src, "<span class='warning'>Voc� n�o sente sua m�o e acaba derrubando o que estava segurando.</span>")
					drop_item()
		if(getBrainLoss() >= 50)
			if(10 <= rn && rn <= 12)
				if(canmove)
					to_chat(src, "<span class='warning'>Voc� n�o sente suas pernas e acaba caindo.</span>")
					Knockdown(3)
