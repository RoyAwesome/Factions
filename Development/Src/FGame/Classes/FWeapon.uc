/**
 * Equippable inventory items such as rifles or repair tools.
 * 
 * Copyright 2012 Factions Team. All Rights Reserved.
 */
class FWeapon extends UDKWeapon
	perobjectlocalized;

var() FWeaponAttachment AttachmentArchetype;

// First-person model location offset relative to the pawn view location
var() Vector DrawOffset;

// Loaded magazine
var FMagazine Magazine;

replication
{
	if (bNetDirty)
		Magazine;
}

/**
 * @extends
 */
function ConsumeAmmo(byte FireModeNum)
{
	AddAmmo(-1);
}

/**
 * @extends
 */
function int AddAmmo(int Amount)
{
	AmmoCount = Magazine.AddAmmo(Amount);
	return AmmoCount;
}

/**
 * @extends
 */
simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
	if (Amount != 0)
		return (AmmoCount >= Amount);
	else
		return (AmmoCount > 0);
}

/**
 * @extends
 */
simulated function bool HasAnyAmmo()
{
	return AmmoCount > 0;
}

/**
 * @extends
 */
simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
	local FPawn PlayerPawn;

	PlayerPawn = FPawn(Instigator);
	if (PlayerPawn.IsFirstPerson())
	{
		AttachComponent(Mesh);
		EnsureWeaponOverlayComponentLast();
		Mesh.SetLightEnvironment(PlayerPawn.LightEnvironment);
	}

	// Update equipment name on the pawn to replicate to clients
	if (PlayerPawn != None && Role == ROLE_Authority)
	{
		PlayerPawn.WeaponAttachmentArchetype = AttachmentArchetype;

		// Update weapon attachment when in single player mode
		if (PlayerPawn.IsLocallyControlled())
			PlayerPawn.UpdateWeaponAttachment();
	}
}

/**
 * @extends
 */
simulated function DetachWeapon()
{
	local FPawn PlayerPawn;

	DetachComponent(Mesh);
	if (OverlayMesh != None)
		DetachComponent(OverlayMesh);

	PlayerPawn = FPawn(Instigator);

	// Clear equipment name on pawn
	if (PlayerPawn != None && Role == ROLE_Authority && FPawn(Instigator).WeaponAttachmentArchetype == AttachmentArchetype)
	{
		PlayerPawn.WeaponAttachmentArchetype = None;

		// Update weapon attachment when in single player mode
		if (Instigator.IsLocallyControlled())
			PlayerPawn.UpdateWeaponAttachment();
	}

	SetBase(None);
	SetHidden(True);
	Mesh.SetLightEnvironment(None);
}

/**
 * Toggles visibility of the first-person weapon model.
 */
simulated function ChangeVisibility(bool bIsVisible)
{
	local SkeletalMeshComponent WeaponSkeletalMesh;
	local PrimitiveComponent SkeletalMeshPrimitive;

	if (Mesh != None)
	{
		if (bIsVisible && !Mesh.bAttached)
		{
			AttachComponent(Mesh);
			EnsureWeaponOverlayComponentLast();
		}

		SetHidden(!bIsVisible);

		WeaponSkeletalMesh = SkeletalMeshComponent(Mesh);
		if (WeaponSkeletalMesh != None)
			foreach WeaponSkeletalMesh.AttachedComponents(class'PrimitiveComponent', SkeletalMeshPrimitive)
				SkeletalMeshPrimitive.SetHidden(!bIsVisible);
	}
}

/**
 * @extends
 */
simulated event SetPosition(UDKPawn Holder)
{
	local Vector DrawLocation;

	if (!Holder.IsFirstPerson())
		return;
	
	DrawLocation = Holder.GetPawnViewLocation();
	DrawLocation += DrawOffset >> Holder.Controller.Rotation;
	DrawLocation += FPawn(Holder).WeaponBob(0.85);
	DrawLocation += UDKPlayerController(Holder.Controller).ShakeOffset >> Holder.Controller.Rotation;
	SetLocation(DrawLocation);

	SetHidden(False);
	SetBase(Holder);

	SetRotation(Holder.Controller.Rotation);
}

/**
 * @extends
 */
simulated function TimeWeaponEquipping()
{
	AttachWeaponTo(Instigator.Mesh);

	Super.TimeWeaponEquipping();
}

/**
 * Executes reloading the weapon.
 */
reliable server function ServerReload()
{
	local FMagazine NextMagazine;

	// Get the next magazine of the equipment's type
	foreach InvManager.InventoryActors(class'FMagazine', NextMagazine)
		if (NextMagazine.AmmoFor == Name)
			break;

	// Abort reloading if no magazine was found
	if (NextMagazine == None)
		return;

	if (Magazine != None)
	{
		// Throw away old magazine
		Magazine.Destroy();
		AmmoCount = 0;
	}

	// Remove next magazine from inventory
	InvManager.RemoveFromInventory(NextMagazine);

	// Insert magazine into weapon
	Magazine = NextMagazine;
	AmmoCount = Magazine.AmmoCount;
}

defaultproperties
{
	Begin Object Class=UDKSkeletalMeshComponent Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		bOnlyOwnerSee=True
		bOverrideAttachmentOwnerVisibility=True
		Rotation=(Yaw=-16384)
	End Object
	Mesh=FirstPersonMesh

	bCanThrow=False
}
