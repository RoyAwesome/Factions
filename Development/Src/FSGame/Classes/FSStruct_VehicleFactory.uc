/**
 * Copyright 2012 Factions Team. All Rights Reserved.
 */
class FSStruct_VehicleFactory extends FSStructure
	dependson(FSVehicleInfo);

function BuildVehicle(name ChassisName, Pawn Builder)
{
	local FSTeamInfo TeamInfo;
	local FSVehicle V;
	local VehicleInfo VI;

	TeamInfo = FSTeamInfo(Builder.PlayerReplicationInfo.Team);

	VI = class'FSVehicleInfo'.default.Vehicles[class'FSVehicleInfo'.default.Vehicles.Find('Name', ChassisName)];

	if (TeamInfo != None && TeamInfo.Resources >= 100)
	{
		TeamInfo.Resources -= 100;
		V = Spawn(VI.Class,,, Location + vect(600, 600, 100));
		V.Team = Builder.GetTeamNum();
	}
}

defaultproperties
{
	Begin Object Name=StructureMesh
		SkeletalMesh=SkeletalMesh'ST_BarracksMash.Mesh.SK_ST_BarracksMash'
	End Object
}