Game.Wait.Wait=function(game)
{
	
	var view=0;
	
	res=
	{
		
		get game(){return game;}, set game(a){game=a;},
		get view(){return view;}, set view(a){view=a;},
		
		Wait: function(game)
		{		
			this.game = game;
			
			//view
			/*var style:StyleSheet = new StyleSheet(); 
			
			var styleObj:Object = new Object(); 			
			styleObj.textAlign = "center";
			styleObj.fontFamily = "_typewriter";			
			styleObj.fontSize = 16;
			style.setStyle(".wait", styleObj); 
			
			view = new TextField();
			view.visible = false;
			view.background = true;			
			view.backgroundColor = 0xAAAAAA;
			view.border = true;
			view.borderColor = 0x888888;
			view.styleSheet = style;
			with (view)
			{
				width = 300; 
				height = 27; 
				multiline = true; 
				wordWrap = true; 
				htmlText = "<span class='wait'>Press <u>space</u> to continue.</span>";
				x = -150;
				y = -100;
			}
			game.view.addChild(view);*/
		},
		
		wait: function()
		{			
		//	Main.stage.addEventListener(KeyboardEvent.KEY_UP, ready);
			document.body.addEventListener('keyup', this.ready);
			//view
			view.visible = true;
		},
		
		ready: function(event)
		{
			if (event.keyCode == 32)
			{					
			///	Main.stage.removeEventListener(KeyboardEvent.KEY_UP, ready);
				game.referee.rallyStart(game.rally.time.get());
				
				//view
				view.visible = false;
			}		
		}
		
	}
	
	res.Wait(game);
	
	return res;

}