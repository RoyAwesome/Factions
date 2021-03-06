class FCommanderGame extends FTeamGame;

/**
 * @extends
 */
function SetEndGameFocus(PlayerReplicationInfo Winner)
{
	local Controller P;
	local Actor EndGameFocus;

	if (Winner != None)
	{
		EndGameFocus = Controller(Winner.Owner).Pawn;
	}

	if (EndGameFocus != None)
	{
		EndGameFocus.bAlwaysRelevant = True;
	}

	foreach WorldInfo.AllControllers(class'Controller', P)
	{
		P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != None) && (P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner));
	}
}

/**
 * Called when a command vehicle is destroyed.
 */
function CommandVehicleDestroyed(FVehicle CommandVehicle, Controller Killer)
{
	if (CommandVehicle.bIsCommandVehicle)
	{
		EndGame(Killer.PlayerReplicationInfo, "CommandVehicleDestroyed");
	}
}

defaultproperties
{
}
