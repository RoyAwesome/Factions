/**
 * Copyright 2012 Factions Team. All Rights Reserved.
 */
class FSPlayerController extends UDKPlayerController;

// Commander
var byte CommanderMoveSpeed;
var bool bPlacingStructure;
var byte PlacingStructureIndex;

// Minimap
var SceneCapture2DComponent MinimapCaptureComponent;
var Vector MinimapCapturePosition;
var Rotator MinimapCaptureRotation;
const MinimapCaptureFOV=90;

simulated state Commanding
{
	simulated function BeginState(name PreviousStateName)
	{
		local Vector ViewLocation;

		ViewLocation.X = Pawn.Location.X - 2048;
		ViewLocation.Y = Pawn.Location.Y;
		ViewLocation.Z = Pawn.Location.Z + 2048;

		SetLocation(ViewLocation);
		SetRotation(Rotator(Pawn.Location - ViewLocation));

		FSHUD(myHUD).GFxCommanderHUD.Start();
	}

	simulated function EndState(name NextStateName)
	{
		FSHUD(myHUD).GFxCommanderHUD.Close(false);
	}

	simulated function GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
	{
		out_Location = Location;
		out_Rotation = Rotation;
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector L;

		if (Pawn == None)
			GotoState('Dead');
		else
		{
			L = Location;

			if (PlayerInput.aForward > 0)
				L.X += CommanderMoveSpeed;
			else if (PlayerInput.aForward < 0)
				L.X -= CommanderMoveSpeed;

			if (PlayerInput.aStrafe > 0)
				L.Y += CommanderMoveSpeed;
			else if (PlayerInput.aStrafe < 0)
				L.Y -= CommanderMoveSpeed;

			SetLocation(L);
		}
	}

	exec function StartFire(optional byte FireModeNum)
	{
		FSHUD(myHUD).BeginDragging();
		PlaceStructure();
	}

	exec function StopFire(optional byte FireModeNum)
	{
		FSHUD(myHUD).EndDragging();
	}

	exec function ToggleCommandView()
	{
		GotoState('PlayerWalking');
	}

	exec function SelectStructure(byte StructureIndex)
	{
		PlacingStructureIndex = StructureIndex;
	}

	exec function PlaceStructure()
	{
		if (PlacingStructureIndex != 0)
			bPlacingStructure = true;
	}
}

simulated function PostBeginPlay()
{
	local FSMapInfo MI;

	Super.PostBeginPlay();

	MI = FSMapInfo(WorldInfo.GetMapInfo());
	if (MI != None && WorldInfo.NetMode != NM_DedicatedServer)
	{
		MinimapCaptureComponent = new(self) class'SceneCapture2DComponent';
		MinimapCaptureComponent.SetCaptureParameters(TextureRenderTarget2D'FSAssets.HUD.minimap_render_texture', MinimapCaptureFOV, , 0);
		MinimapCaptureComponent.bUpdateMatrices = false;
		AttachComponent(MinimapCaptureComponent);

		MinimapCapturePosition.X = MI.MapCenter.X;
		MinimapCapturePosition.Y = MI.MapCenter.Y;
		MinimapCapturePosition.Z = MI.MapRadius;
	}
}

function PlayerTick(float DeltaTime)
{
	Super.PlayerTick(DeltaTime);

	MinimapCaptureComponent.SetView(MinimapCapturePosition, MinimapCaptureRotation);
}

reliable server function RequestVehicle()
{
	local FSStruct_VehicleFactory VF;

	VF = FSStruct_VehicleFactory(Pawn.Base);

	if (VF != None)
		VF.BuildVehicle(FSPawn(Pawn));
}

reliable server function ServerSpawnStructure(Vector StructureLocation)
{
	local FSStructure S;

	S = Spawn(class'FSStructure'.static.GetStructureClass(PlacingStructureIndex), , , StructureLocation, rot(0, 0, 0), , );
	S.TeamNumber = PlayerReplicationInfo.Team.TeamIndex;
	bPlacingStructure = false;
	PlacingStructureIndex = 0;
}

exec function BuildVehicle()
{
	RequestVehicle();
}

exec function ToggleCommandView()
{
	if (PlayerReplicationInfo.Team != None)
		GotoState('Commanding');
}

defaultproperties
{
	InputClass=class'FSGame.FSPlayerInput'
	bPlacingStructure=false
	PlacingStructureIndex=0
	CommanderMoveSpeed=30
	SpectatorCameraSpeed=5000.0

	MinimapCaptureRotation=(Pitch=-16384,Yaw=-16384,Roll=0)
}