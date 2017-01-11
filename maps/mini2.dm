
//**************************************************************
// Map Datum -- MiniStation 2
//**************************************************************

/datum/map/active
	nameShort = "Mini2"
	nameLong  = "Mini2"
	map_dir   = "mini2"
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
			}
		)
	unavailable_items = list(
		/obj/item/clothing/shoes/magboots/elite,
		/obj/item/clothing/suit/space/nasavoid,
		/obj/item/clothing/under/rank/research_director,
		/obj/item/clothing/under/rank/chief_engineer,
		/obj/item/clothing/under/rank/chief_medical_officer,
		/obj/item/clothing/under/rank/head_of_security
		)
////////////////////////////////////////////////////////////////

#include "mini2.dmm"

#if !defined(MAP_OVERRIDE_FILES)
	#define MAP_OVERRIDE_FILES
	#include "mini2\misc.dm"
	#include "mini2\telecomms.dm"
	#include "mini2\uplink.dm"
	#include "mini2\job\jobs.dm"
	#include "mini2\job\removed.dm"

//#elif !defined(MAP_OVERRIDE)
	//#warn a map has already been included, ignoring ministation.