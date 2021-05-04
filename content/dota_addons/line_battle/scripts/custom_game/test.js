abilitiesCount = 0;
function buttonsCreate(){
	var panel = $.CreatePanel('Panel', $('#Tst'),'');
	panel.style.width = "100px";
	panel.style.height = "100px" ;
	panel.style.backgroundColor = "red";
}
var maxAbilities = 5;
function onBtnTestClick(event){
	$.Msg(event) ;
    $.Msg("onBtnTestClick");
	$('#'+event).style.visibility = "collapse"; 
    var plyID = Game.GetLocalPlayerID();

    var data = {		// Обьект для передачи в Луа
        playerID: plyID, 
        AbilityId: event       // аргумен, который указывали в хмл onactivate="onBtnTestClick('myArgument')
    };
	$.Msg(data) ;
    GameEvents.SendCustomGameEventToServer( "add_ability", data); 
	abilitiesCount+=1;
	if(abilitiesCount>=maxAbilities) {
		$('#AbilitiesPickScreen').style.visibility = "collapse"; 
		$('#PickText').style.visibility = "collapse"; 
		var data = {
			playerID: plyID,      
		};
		GameEvents.SendCustomGameEventToServer("Ready",data);
	}
}

var cameradist = 1300;   //start camera distance in dota
var speed = 15;
var minCameraDist = 400;
var maxCameraDist = 2200;
GameUI.SetCameraDistance(cameradist);
GameUI.SetMouseCallback( function( eventName, arg ) {      //mouse wheel call event "wheeled", and arg means wheel direction  
	if ( eventName === "wheeled" )
	{
		if ( arg < 0 && cameradist >= minCameraDist)
		{
			cameradist -= speed;
			GameUI.SetCameraDistance(cameradist);
		}
		else if ( arg > 0 && cameradist <= maxCameraDist)
		{
			cameradist += speed;
			GameUI.SetCameraDistance(cameradist);
		}
	}
	return false;
} );
