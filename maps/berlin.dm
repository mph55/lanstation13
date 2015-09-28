
//**************************************************************
// Map Datum -- Boxstation
//**************************************************************

/datum/map/active
	nameShort = "tgstation-berlin"
	nameLong = "Berlin Station"
	map_dir = "boxstation"
	tDomeX = 128
	tDomeY = 69
	tDomeZ = 2
	zLevels = list(
		/datum/zLevel/station,
		/datum/zLevel/centcomm,
		/datum/zLevel/space{
			name = "spaceOldSat" ;
			},
		/datum/zLevel/space{
			name = "derelict" ;
			},
		/datum/zLevel/mining,
		/datum/zLevel/space{
			name = "spacePirateShip" ;
			},
		)

////////////////////////////////////////////////////////////////
#include "defficiency/pipes.dm" // Atmos layered pipes.
#include "berlin/areas.dm" // Belin areas
#include "tgstation-berlin.dmm"