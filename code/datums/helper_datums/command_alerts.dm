/datum/command_alert
	var/name //Descriptive name - it's not shown to anybody, so feel free to make it OOC

	var/alert_title = "Comando Central" //Traduzido por Anaonimo, FrostBleidd, Stingray e zero
	var/message

	var/force_report = 0
	var/alert = 'sound/AI/commandreport.ogg'//sound
	var/noalert = 0

/datum/command_alert/proc/announce()
	command_alert(message, alert_title, force_report, alert, noalert)

//////BIOHAZARD

/datum/command_alert/biohazard_alert
	name = "Alerta de Risco Biol�gico"
	alert_title = "Alerta de Risco Biol�gico"
	noalert = 1
	force_report = 1

	var/level = 1

/datum/command_alert/biohazard_alert/announce()
	level = rand(4,7)
	message = "Confirmado surto de risco biol�gico n�vel [level] a bordo da [station_name()]. Toda a tripula��o deve conter o surto."

	..()

	var/list/vox_sentence=list(
	'sound/AI/outbreak_before.ogg',
	outbreak_level_words[level],
	'sound/AI/outbreak_after.ogg',
	)

	for(var/word in vox_sentence)
		play_vox_sound(word,STATION_Z,null)

///////BIOHAZARD UPDATED

/datum/command_alert/biohazard_station_lockdown
	name = "N�vel de Risco Biol�gico Atualizado - Esta��o Trancada"
	alert_title = "Diretiva 7-10 Iniciada"
	alert = 'sound/AI/blob_confirmed.ogg'
	force_report = 1

/datum/command_alert/biohazard_station_lockdown/announce()
	message = "Alerta de surto de risco biol�gico elevado para o n�vel 9. [station_name()] est� agora trancada, sob a Diretiva 7-10, at� nova ordem."

	..()

/datum/command_alert/biohazard_station_nuke
	name = "N�vel de Perigo Biol�gico Atualizado - For�a Nuclear Autorizada"
	alert_title = "Medida Final"
	noalert = 1

/datum/command_alert/biohazard_station_nuke/announce()
	message = "O estado de conten��o do surto de risco biol�gico atingir� uma massa cr�tica, sendo agora poss�vel uma falha total da quarentena. Como tal, a Diretiva 7-12 foi agora autorizada para [station_name()]."

	..()

////////BLOB (mini)

/datum/command_alert/biohazard_level_5
	name = "Alerta de Risco Biol�gico (n�vel 5)"
	alert_title = "Alerta de Risco Biol�gico"
	alert = 'sound/AI/outbreak5.ogg'
	force_report = 1

/datum/command_alert/biohazard_level_5/announce()
	message = "Confirmado surto de risco biol�gico de n�vel 5 a bordo da [station_name()]. Toda a tripula��o deve conter o surto."

	..()

/////////ERT

/datum/command_alert/ert_fail
	name = "ERT - Incapaz de Enviar"

/datum/command_alert/ert_fail/announce()
	message = "Parece que foi solicitada uma equipa de resposta a emerg�ncias para [station_name()]. Infelizmente, n�o conseguimos enviar uma neste momento."

	..()

/datum/command_alert/ert_success
	name = "ERT - Time Enviado"

/datum/command_alert/ert_success/announce()
	message = "Parece que foi solicitada uma equipa de resposta a emerg�ncias para a [station_name()]. Vamos preparar e enviar uma o mais r�pido poss�vel."

	..()

////////AYY

/datum/command_alert/xenomorphs
	name = "Alerta de sinais de vida n�o identificados"
	alert_title = "Alerta de sinais de vida"
	alert = 'sound/AI/aliens.ogg'

/datum/command_alert/xenomorphs/announce()
	message = "Sinais de vida n�o identificados detectados a bordo da [station_name()]. Proteger qualquer acesso exterior, incluindo dutos e ventila��o."

	..()

///////RADIATION

/datum/command_alert/radiation_storm
	name = "Tempestade de Radia��o - Aviso"
	alert_title = "Alerta de Anomalia"
	alert = 'sound/AI/radiation.ogg'
	message = "N�veis elevados de radia��o detectados perto da esta��o, ETA em 30 segundos. Por favor, evacuar para um dos t�neis de manuten��o blindados."

/datum/command_alert/radiation_storm/start
	name = "Tempestade de Radia��o - In�cio"
	alert = null
	message = "A esta��o entrou no cintur�o de radia��o. Por favor, permane�a em uma �rea protegida at� que tenhamos passado pelo cintur�o de radia��o."

/datum/command_alert/radiation_storm/end
	name = "Tempestade de Radia��o - Fim"
	alert = null
	message = "A esta��o passou o cintur�o de radia��o. Por favor, dirija-se � Medbay se tiver quaisquer sintomas incomuns. A manuten��o perder� todo o acesso novamente em breve."

/datum/command_alert/radiation
	name = "Altos N�veis de Radia��o"
	alert_title = "Alerta de Anomalia"
	alert = 'sound/AI/radiation.ogg'

	message = "Altos n�veis de radia��o detectados perto da esta��o. Se voc� se sentir estranho, dirija-se � Enfermaria M�dica."


///////GRAYTIDE VIRUS

/datum/command_alert/graytide
	name = "Gr3y.T1d3 v�rus"
	alert_title = "Alerta de Seguran�a"

/datum/command_alert/graytide/announce()
	message = "[pick("Gr3y.T1d3 virus", "Trojan Maligno")] detectado nas subrotinas de aprisionamento da [station_name()]. Recomendamos o envolvimento da IA da esta��o."

	..()

//////CARP

/datum/command_alert/carp
	name = "Migra��o de Carpas"
	alert_title = "Alerta de sinais de vida"

/datum/command_alert/carp/announce()
	message = "Entidades biol�gicas desconhecidas foram detectadas perto da [station_name()], por favor aguarde."

	..()

////////ELECTRICAL STORM

/datum/command_alert/electrical_storm
	name = "Tempestade El�trica"
	alert_title = "Alerta de Tempestade El�trica"
	message = "Foi detectada uma tempestade el�ctrica na sua �rea, por favor repare potenciais sobrecargas eletr�nicas."

///////SUMMARY DOWNLOADED AND PRINTED AT COMMS

/datum/command_alert/enemy_comms_interception
	name = "Comunica��es Inimigas Interceptadas"
	alert_title = "Intercep��o de comunica��es inimigas"
	message = "Resumo baixado e impresso em todos os consoles de comunica��o."

//////////SUPERMATTER CASCADE

/datum/command_alert/supermatter_cascade
	name = "In�cio da Cascata de Supermat�ria"
	alert_title = "CASCATA DE SUPERMAT�RIA DETECTADA"

/datum/command_alert/supermatter_cascade/announce()
	message = {"
Ocorreu um pulso eletromagn�tico intergal�ctico. Todos os nossos sistemas foram severamente danificados e muitos da equipe est�o mortos ou morrendo. Estamos observando indica��es crescentes de que o pr�prio universo est� come�ando a se desfazer.

[station_name()], voc� � a �nica instala��o perto de uma fenda no Bluespace, a qual � perto do seu posto avan�ado de pesquisa. Voc�s foram designados a entrar na fenda usando todos os meios necess�rios, possivelmente como os �ltimos humanos vivos.

Voc�s tem cinco minutos antes do universo entrar em colapso. Boa s\[\[###!!!-

ALERTA AUTOMATIZADO: O link para [command_name()] foi perdido.

Os requisitos de acesso aos consoles das Shuttles do Aster�ide foram revogados.
"}

	..()

/////////////POWER OUTAGE

/datum/command_alert/power_outage
	name = "Queda de Energia - In�cio"
	alert_title = "Falha de Energia Cr�tica"
	alert ='sound/AI/poweroff.ogg'

/datum/command_alert/power_outage/announce()
	message = "Atividade anormal detectada na rede de energia de [station_name()]. Como medida precaut�ria, a energia da esta��o ser� desligada por dura��o indeterminada."

	..()

/datum/command_alert/power_restored
	name = "Queda de Energia - Fim"
	alert_title = "Sistemas de Energia Nominais"
	alert = 'sound/AI/poweron.ogg'

/datum/command_alert/power_restored/announce()
	message = "A energia foi restaurada na [station_name()]. Nos desculpamos pela inconveni�ncia."

	..()

/datum/command_alert/smes_charged
	name = "SMES Recarregada"
	alert_title = "Sistemas de Energia Nominais"
	alert = 'sound/AI/poweron.ogg'

/datum/command_alert/smes_charged/announce()
	message = "Todas as SMES na [station_name()] foram recarregadas. Nos desculpamos pela inconveni�ncia."

	..()

////////////////WORMHOLES

/datum/command_alert/wormholes
	name = "Anomalias no Espa�o-Tempo Detectadas"
	alert_title = "Alerta de Anomalia"
	alert = 'sound/AI/spanomalies.ogg'
	message = "Anomalias no espa�o-tempo detectadas na esta��o. N�o h� dados adicionais."

//////////////MALF ANNOUNCEMENT

/datum/command_alert/malf_announce
	name = "Aviso de AI Defeituosa"
	alert_title = "Alerta de Anomalia"
	alert = 'sound/AI/aimalf.ogg'
	message = "Programas hostis detectados em todos os sistemas da esta��o, favor desativar a AI para prevenir poss�vel dano ao seu n�cleo moral."

/////////////METEOR STORM

/datum/command_alert/meteor_round
	name = "Aviso de Tempestade de Meteoros Grave"
	alert_title = "An�ncios Automatizados de Meteorologia Espacial"
	alert = 'sound/AI/meteorround.ogg'

	var/meteor_delay = 2000
	var/supply_delay = 100

/datum/command_alert/meteor_round/announce()
	meteor_delay = rand(4500, 6000)
	if(prob(70)) //slightly off-scale
		message = "Uma tempestade de meteoros foi detectada na proximidade da [station_name()] e espera-se que a atinja dentro de [round((rand(meteor_delay - 600, meteor_delay + 600))/600)] minutos. Uma shuttle emergencial reserva est� sendo despachada e o equipamento de emerg�ncia deve ser teletransportado para a �rea do Bar de sua esta��o em [supply_delay/10] segundos."
	else
		message = "Uma tempestade de meteoros foi detectada na proximidade da [station_name()] e espera-se que a atinja dentro de [round((rand(meteor_delay - 1800, meteor_delay + 1800))/600)] minutos. Uma shuttle emergencial reserva est� sendo despachada e o equipamento de emerg�ncia deve ser teletransportado para a �rea do Bar de sua esta��o em [supply_delay/10] segundos."

	..()

////small meteor storm

/datum/command_alert/meteor_wave
	name = "Aviso de Tempestade de Meteoros"
	alert_title = "Alerta de Meteoro"
	alert = 'sound/AI/meteors.ogg'
	message = "Uma tempestade de meteoros foi detectada em rota de colis�o com a esta��o. Procure abrigo dentro do n�cleo da esta��o imediatamente."


/////meteor storm end
/datum/command_alert/meteor_wave_end
	name = "Tempestade de Meteoros Eliminada"
	alert_title = "Alerta de Meteoro"
	message = "A esta��o eliminou a tempestade de meteoros."

/datum/command_alert/meteor_storm
	name = "Aviso de Tempestade de Meteoros de Pequena Intensidade"
	alert_title = "Alerta de Meteoro"
	message = "A esta��o est� prestes a ser atingida por uma pequena tempestade de meteoros. Procure abrigo dentro do n�cleo da esta��o imediatamente."

//////blob storm
/datum/command_alert/blob_storm
	name = "Meteoro com aglomerado de Blob - Sem Overminds"
	alert_title = "Aglomerado de Blob"
	message = "A esta��o est� prestes a passar por um aglomerado de Blob. Nenhuma onda cerebral do Overmind detectadas."

/datum/command_alert/blob_storm/end
	name = "Meteoro com aglomerado de Blob encerrado (Zero Overminds)"
	message = "A esta��o limpou o aglomerado de Blob. Erradicar o Blob das �reas atingidas."

/datum/command_alert/blob_storm/overminds
	name = "Meteoro com aglomerado de Blob - Overminds!"
	alert_title = "Conglomerado de Blob"
	message = "A esta��o est� prestes a passar por um conglomerado de Blob. Ondas cerebrais do Overmind possivelmente detectadas."

/datum/command_alert/blob_storm/overminds/end
	name = "Meteoro com aglomerado de Blob encerrado (Overminds!)"
	message = "A esta��o eliminou o conglomerado de Blob. Investigue as �reas atingidas imediatamente e limpe-as. Seja cuidadoso com a poss�vel presen�a de Overmind."

/////////////GRAVITY

/datum/command_alert/gravity_enabled
	name = "Gravidade - Ativada"
	message = "Geradores de gravidade est�o novamente funcionando dentro dos par�metros normais. Sinceras desculpas por qualquer inconveni�ncia."

/datum/command_alert/gravity_disabled
	name = "Gravidade - Desativada"
	message = "Surtos de realimenta��o detectados em sistemas de distribui��o de massa. A gravidade artificial foi desativada enquanto o sistema reinicializa. Outras falhas podem resultar em colapso gravitacional e forma��o de buracos negros. Tenha um bom dia."

//////////////////////////////ION STORM

/datum/command_alert/ion_storm
	name = "Tempestade I�nica - IA afetado"
	alert_title = "Alerta de Anomalia"
	alert = 'sound/AI/ionstorm.ogg'
	message = "Tempestade i�nica detectada perto da esta��o. Por favor, verifique se h� erros em todos os equipamentos controlados por AI."

/datum/command_alert/ion_storm_large
	name = "Tempestade I�nica - Todos os equipamentos afetados"
	alert_title = "Alerta de Anomalia"
	message = "N�s detectamos que a esta��o acabou de passar por uma tempestade i�nica. Por favor, monitore todos os equipamentos eletr�nicos por erros em potencial."

///////////BLUESPACE ANOMALY

/datum/command_alert/bluespace_anomaly
	name = "Anomalia de Bluespace"
	alert_title = "Alerta de Anomalia"

/datum/command_alert/bluespace_anomaly/New(impact_area_name)
	message = "Anomalia de Bluespace detectada nos arredores da [station_name()]. [impact_area_name || "Uma �rea desconhecida"] foi afetada."
	..()

//////////POWER DISABLED

/datum/command_alert/power_disabled
	name = "Energia da Esta��o - Desativada"
	alert_title = "Exame de Rede Automatizado"
	alert = 'sound/AI/poweroff.ogg'

/datum/command_alert/power_disabled/announce()
	message = "Atividade anormal foi detectada na rede de energia da [station_name()]. A energia ser� desligada por tempo indeterminado por quest�es de seguran�a."
	..()

/datum/command_alert/power_restored
	name = "Energia da Esta��o - Restaurada"
	alert_title = "Pot�ncia Nominal"
	alert = 'sound/AI/poweron.ogg'

/datum/command_alert/power_restored/announce()
	message = "Energia foi restaurada na [station_name()]. Sinceras desculpas pela inconveni�ncia."
	..()

//////////////CENTCOM LINK

/datum/command_alert/command_link_lost
	name = "Conex�o Perdida com a CentCom"
	alert_title = "Alerta Autom�tico"
	alert = 'sound/AI/loss.ogg'
	message = "Isso � um alerta autom�tico. A conex�o com o comando central foi perdida. Novamente: A conex�o com o comando central foi perdida. Tentando a re-estabelecer comunica��es em T-10."

/datum/command_alert/command_link_restored
	name = "Conex�o com a CentCom Restaurada"
	alert_title = "Conex�o Estabelecida"

/datum/command_alert/command_link_restored/announce()
	message = "Conex�o com o comando central foi estabelecida na [station_name()]."
	..()

/////////HOSTILE CREATURES

/datum/command_alert/hostile_creatures
	name = "Alerta de Criaturas Hostis"
	alert_title = "AVISO: Criatura(s) Hostis"

/datum/command_alert/hostile_creatures/New(localestring = "um local desconhecido", monsterstring = "inten��o maliciosa")
	..()

	message = "Uma ou mais criatura(s) hostil(is) invadiram a esta��o em [localestring]. C�meras de seguran�a externas indicam que a criatura possui [monsterstring]."

/datum/command_alert/vermin
	name = "Alerta de Vermes"
	alert_title = "Infesta��o de Vermes"

/datum/command_alert/vermin/New(vermstring = "v�rios vermes", locstring = "t�neis de manuten��o da esta��o")
	..()

	message = "Bioscans indicam que [vermstring] tem se reproduzido nos [locstring]. Esvazie-os, antes que isso comece a afetar a produtividade."

/datum/command_alert/mob_swarm
	name = "Enxame de Criaturas"

/datum/command_alert/mob_swarm/New(mob_name = "animais")
	..()

	message = "Devido a anomalias de origem desconhecidas no espa�o-tempo, a [station_name] agora � a hospedeira de v�rios [mob_name], mais do que havia h� pouco."

////////MISC STUFF

/datum/command_alert/eagles
	name = "Acesso da Airlock Removido"
	message = "Controle da Airlock da Centcomm sobreposto. Por favor, tome este tempo para se familiarizar com seus colegas de trabalho."

/datum/command_alert/bluespace_artillery
	name = "Ataque de Artilharia Bluespace Detectado"
	message = "Fogo de artilharia Bluespace detectado. Preparar para impacto."

/datum/command_alert/vending_machines
	name = "Intelig�ncia de Marca Rampante Detectada"
	alert_title = "Alerta de aprendizado de m�quina"

/datum/command_alert/vending_machines/announce()
	message = "A intelig�ncia da marca Rampant foi detectada a bordo de [station_name()], por favor, aguarde."

/datum/command_alert/comms_blackout
	name = "Anomalias Ionosf�ricas - Falha nas Telecomunica��es"
	message = "Anomalias ionosf�ricas detectadas. Falha tempor�ria de telecomunica��es iminente. Favor entrar em contato com seu-BZZT"

/datum/command_alert/comms_blackout/announce()
	message = pick(	"Anomalias ionosf�ricas detectadas. Falha tempor�ria na telecomunica��o iminente. Por favor contate seu%fj00)`5vc-BZZT", \
						"Anomalias ionosf�ricas detectadas. Falha tempor�ria na telecomun3mga;b4;'1v�-BZZZT", \
						"Anomalias ionosf�ricas detectadas. Falha tempor�r#MCi46:5.;@63-BZZZZT", \
						"Anomalias ionosf�ricas detec'fZ\\kg5_0-BZZZZZT", \
						"Anomali:%� MCayj^j<.3-BZZZZZZT", \
						"#4nd%;f4y6,>�%-BZZZZZZZT")
	..()

/datum/command_alert/electrical_storm
	name = "Alerta de Tempestade El�trica"
	alert_title = "Alerta de Tempestade El�trica"
	message = "Uma tempestade el�ctrica foi detectada na sua �rea, por favor repare potenciais sobrecargas eletr�nicas."

/datum/command_alert/immovable_rod
	name = "Haste Im�vel (\"Que diabos foi isso?\")"
	alert_title = "Alerta Geral"
	message = "Que diabos foi isso?!"

/datum/command_alert/rogue_drone
	name = "Drones Rebeldes - Alerta"
	alert_title = "Alerta de Drones Rebeldes"

/datum/command_alert/rogue_drone/announce()
	if(prob(33))
		message = "Um drone de combate operando fora da NMV Icarus falhou em retornar de uma varredura nesse setor, se algum for avistado aproxime-se com cuidado."
	else if(prob(50))
		message = "Contato foi perdido com um drone de combate operando fora da NMV Icarus. Se alguma for avistada na �rea, aproxime-se com cuidado."
	else
		message = "Hackers n�o identificados atacaram um drone de combate enviado da NMV Icarus. Se algum for avistado, aproxime-se com cuidado."

	..()

/datum/command_alert/drones_recovered
	name = "Drones Rebeldes - Recuperados com Sucesso"
	alert_title = "Alerta de Drones Rebeldes"
	message = "Icarus reporta que seu drone com malfuncionamento foi recuperado com seguran�a."

/datum/command_alert/drones_recovered/failure
	name = "Drones Rebeldes - Falha em recuperar"
	message = "Icarus registra desapontamento pela perda de seus drones, mas os sobreviventes foram recuperados."

/datum/command_alert/wall_fungi
	name = "Parede de Fungos"
	alert_title = "Alerta de Risco Biol�gico"
	message = "Fungos perigosos detectados na esta��o. Estruturas da esta��o podem estar contaminadas."
