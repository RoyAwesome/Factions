/**
 * Copyright 2012 Factions Team. All Rights Reserved.
 */
class FSVehicle_Jeep extends FSVehicle;

const TireRadius=46.f;

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_Jeep.Mesh.SK_VH_Jeep'
		AnimTreeTemplate=AnimTree'VH_Jeep.Anims.AT_VH_Jeep'
		PhysicsAsset=PhysicsAsset'VH_Jeep.Mesh.SK_VH_Jeep_Physics'
	End Object

	Begin Object Class=UDKVehicleSimCar Name=SimObject
	End Object
	SimObj=SimObject
	Components.Add(SimObject);

	Begin Object Class=UDKVehicleWheel Name=FLWheel
		BoneName="F_L_Tire"
		SkelControlName="F_L_Tire_Cont"
		WheelRadius=TireRadius
		bPoweredWheel=true
	End Object
	Wheels(0)=FLWheel

	Begin Object Class=UDKVehicleWheel Name=FRWheel
		BoneName="F_R_Tire"
		SkelControlName="F_R_Tire_Cont"
		WheelRadius=TireRadius
		bPoweredWheel=true
	End Object
	Wheels(1)=FRWheel

	Begin Object Class=UDKVehicleWheel Name=BLWheel
		BoneName="B_L_Tire"
		SkelControlName="B_L_Tire_Cont"
		WheelRadius=TireRadius
		bPoweredWheel=true
	End Object
	Wheels(2)=BLWheel

	Begin Object Class=UDKVehicleWheel Name=BRWheel
		BoneName="B_R_Tire"
		SkelControlName="B_R_Tire_Cont"
		WheelRadius=TireRadius
		bPoweredWheel=true
	End Object
	Wheels(3)=BRWheel

	Seats(0)={(CameraTag=Main_Root)}

	DrawScale=1.5
}
