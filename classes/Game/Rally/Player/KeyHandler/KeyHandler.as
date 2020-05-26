Game.Rally.Player.KeyHandler.KeyHandler=function(localPlayer, keyLeft, keyRight, keyDown, keyUp, keyTurnCounterClockWise, keyTurnClockWise)
{
	
	var LocalPlayer=Game.Rally.Player.LocalPlayer;
	
	var keyLeftPressed=0, keyRightPressed=0, keyDownPressed=0, keyUpPressed=0, keyTurnClockWisePressed=0, keyTurnCounterClockWisePressed=0;
	
	var res=
	{
		//vars			
			get localPlayer(){return localPlayer;}, set localPlayer(a){localPlayer=a;},
			get keyLeft(){return keyLeft;}, set keyLeft(a){keyLeft=a;},
			get keyRight(){return keyRight;}, set keyRight(a){keyRight=a;},
			get keyDown(){return keyDown;}, set keyDown(a){keyDown=a;},
			get keyUp(){return keyUp;}, set keyUp(a){keyUp=a;},
			get keyTurnCounterClockWise(){return keyTurnCounterClockWise;}, set keyTurnCounterClockWise(a){keyTurnCounterClockWise=a;},
			get keyTurnClockWise(){return keyTurnClockWise;}, set keyTurnClockWise(a){keyTurnClockWise=a;},
			get keyLeftPressed(){return keyLeftPressed;}, set keyLeftPressed(a){keyLeftPressed=a;},
			get keyRightPressed(){return keyRightPressed;}, set keyRightPressed(a){keyRightPressed=a;},
			get keyDownPressed(){return keyDownPressed;}, set keyDownPressed(a){keyDownPressed=a;},
			get keyUpPressed(){return keyUpPressed;}, set keyUpPressed(a){keyUpPressed=a;},
			get keyTurnClockWisePressed(){return keyTurnClockWisePressed;}, set keyTurnClockWisePressed(a){keyTurnClockWisePressed=a;},
			get keyTurnCounterClockWisePressed(){return keyTurnCounterClockWisePressed;}, set keyTurnCounterClockWisePressed(a){keyTurnCounterClockWisePressed=a;},
		//constructor
		
			KeyHandler: function(localPlayer, keyLeft, keyRight, keyDown, keyUp, keyTurnCounterClockWise, keyTurnClockWise)
			{
				//logic
				this.localPlayer = localPlayer;
				
				this.keyLeft=keyLeft;
				this.keyRight=keyRight;
				this.keyDown=keyDown;
				this.keyUp=keyUp;		
				this.keyTurnCounterClockWise=keyTurnCounterClockWise;
				this.keyTurnClockWise = keyTurnClockWise;	
				
				this.keyLeftPressed=false;
				this.keyRightPressed=false;
				this.keyDownPressed=false;
				this.keyUpPressed = false;
				this.keyTurnClockWisePressed = false;
				this.keyTurnCounterClockWisePressed = false;
				
				//ui
				//Main.stage.addEventListener(KeyboardEvent.KEY_DOWN, uiKeyDown);
				//Main.stage.addEventListener(KeyboardEvent.KEY_UP, uiKeyUp);
				var this_=this;
				var m=this_.uiKeyDown;
				document.body.addEventListener('keydown', res.uiKeyDown);
				document.body.addEventListener('keyup', res.uiKeyUp);
			},		
		
		//ui methods
			
			uiKeyDown: function(event)
			{								
				res.keyDownF(event.keyCode);
			},
			
			uiKeyUp: function(event)
			{
				res.keyUpF(event.keyCode);
			},
			
			unbind: function()
			{
				document.body.removeEventListener('keydown', res.uiKeyDown);
				document.body.removeEventListener('keyup', res.uiKeyUp);
			},
			
		//logic methods
			
			keyDownF: function(keyCode)
			{				
				if(keyCode==keyLeft){keyLeftPressed=true;}
				if(keyCode==keyRight){keyRightPressed=true;}
				if(keyCode==keyDown){keyDownPressed=true;}
				if(keyCode==keyUp){keyUpPressed=true;}
				if(keyCode==keyTurnCounterClockWise){keyTurnCounterClockWisePressed=true;}
				if(keyCode==keyTurnClockWise){keyTurnClockWisePressed=true;}
				localPlayer.afterKeyPressedChange();
			},
			
			keyUpF: function(keyCode)
			{
				if (keyCode==keyLeft){keyLeftPressed=false;}
				if (keyCode==keyRight){keyRightPressed=false;}
				if(keyCode==keyDown){keyDownPressed=false;}
				if(keyCode==keyUp){keyUpPressed=false;}
				if (keyCode == keyTurnCounterClockWise){keyTurnCounterClockWisePressed=false;}
				if(keyCode==keyTurnClockWise){keyTurnClockWisePressed=false;}	
				localPlayer.afterKeyPressedChange();
			}
	}
	
	res.KeyHandler(localPlayer, keyLeft, keyRight, keyDown, keyUp, keyTurnCounterClockWise, keyTurnClockWise);
	
	return res;

}