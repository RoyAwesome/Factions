class EmpGFxHUD extends GFxMoviePlayer;

var GFxObject HealthBar;
var GFxObject TopLeftHUD;
var GFxObject TopRightHUD;
var GFxObject BottomLeftHUD;
var GFxObject BottomRightHUD;

const HealthBarWidth=325;

function Init(optional LocalPlayer LocPlay)
{
	Super.Init(LocPlay);

	TopLeftHUD = GetVariableObject("_root.topLeftHUD");
	TopRightHUD = GetVariableObject("_root.topRightHUD");
	BottomLeftHUD = GetVariableObject("_root.bottomLeftHUD");
	BottomRightHUD = GetVariableObject("_root.bottomRightHUD");

	HealthBar = GetVariableObject("_root.bottomLeftHUD.healthBar");

	ResizeHUD();
}

function SetHealth(float Health, float MaxHealth)
{
	local ASDisplayInfo DI;

	DI.hasX = true;
	DI.X = -HealthBarWidth + (Health / MaxHealth * HealthBarWidth);

	HealthBar.SetDisplayInfo(DI);
}

function ResizeHUD()
{
	local float Left, Top, Right, Bottom;
	local ASDisplayInfo DI;

	GetVisibleFrameRect(Left, Top, Right, Bottom);

	DI.hasY = true;
	DI.Y = Bottom;
	BottomLeftHUD.SetDisplayInfo(DI);
	BottomRightHUD.SetDisplayInfo(DI);
	DI.hasY = false;

	DI.hasX = true;
	DI.X = Right;
	TopRightHUD.SetDisplayInfo(DI);
	BottomRightHUD.SetDisplayInfo(DI);
}

defaultproperties
{
	MovieInfo=SwfMovie'EmpFlashAssets.emp_hud'
	bDisplayWithHudOff=false
	bAutoPlay=true
}
