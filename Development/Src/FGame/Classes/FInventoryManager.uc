/**
 * Manages the player's equipment.
 * 
 * Copyright 2012 Factions Team. All Rights Reserved.
 */
class FInventoryManager extends InventoryManager;

/**
 * @extends
 */
simulated function DrawHud(HUD H)
{
	Super.DrawHud(H);

	// Draw overlays for active weapon
	if (FWeapon(Instigator.Weapon) != None)
	{
		FWeapon(Instigator.Weapon).ActiveRenderOverlays(H);
	}
}

/**
 * Spawns the loadout items and adds them to the inventory.
 */
function EquipLoadout()
{
	local FPlayerController PlayerController;
	local FWeapon SpawnedWeapon;
	local FWeapon WeaponArchetype;
	local Inventory Inv;
	local array<Inventory> OldInventory;
	local int i;

	PlayerController = FPlayerController(Pawn(Owner).Controller);

	// Track old equipment
	foreach InventoryActors(class'Inventory', Inv)
	{
		OldInventory.AddItem(Inv);
	}

	// Equip each requested equipment
	for (i = 0; i < class'FPlayerController'.const.MaxLoadoutSlots; i++)
	{
		WeaponArchetype = PlayerController.CurrentWeaponArchetypes[i];

		if (WeaponArchetype != None)
		{
			SpawnedWeapon = Spawn(WeaponArchetype.Class, Owner,,,, WeaponArchetype);
			AddInventory(SpawnedWeapon);
		}
	}

	// Remove old equipment
	foreach OldInventory(Inv)
	{
		RemoveFromInventory(Inv);
	}
}

defaultproperties
{
	PendingFire(0)=0
	PendingFire(1)=0
}
