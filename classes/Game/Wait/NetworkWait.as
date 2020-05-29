Game.Wait.NetworkWait=function(game)
{
	
	var isReadyWe=0, isReadyHe=0, timer=0, startTime=0, readyWe=0;
	var waitNode=document.querySelector('#wait');
	var waitReadyNode=document.querySelector('#wait_ready');
	
	var res=
	{	
		get game(){return game;}, set game(a){game=a;},
		get isReadyWe(){return isReadyWe;}, set isReadyWe(a){isReadyWe=a;},
		get isReadyHe(){return isReadyHe;}, set isReadyHe(a){isReadyHe=a;},
		get timer(){return timer;}, set timer(a){timer=a;},
		get startTime(){return startTime;}, set startTime(a){startTime=a;},
	
		ready: function(event)
		{
			if (event.keyCode == 32)
			{					
			///	Main.stage.removeEventListener(KeyboardEvent.KEY_UP, ready);
				game.referee.rallyStart(game.rally.time.get());
				
				//view
				//view.visible = false;
				event.preventDefault();
				return true;
			}		
		},
	
		NetworkWait: function(game) 
		{
			//super(game);			
			this.game=game;
						
			
			isReadyWe = false;
			isReadyHe = false;			
			this.viewShowReady();
			waitNode.style.display='block';
			//timer = new Timer(100, 1);
			//timer.addEventListener(TimerEvent.TIMER, startImmediately);
			
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
				height = 62; 
				multiline = true; 
				wordWrap = true; 
				x = -150;
				y = -100;
			}
			game.view.addChild(view);*/
		},
		
		wait: function()
		{
			//Main.stage.addEventListener(KeyboardEvent.KEY_UP, readyWe);			
			document.body.addEventListener('keydown', readyWe);
			//view
			this.viewShowReady();
			waitNode.style.display='block';
			//view.visible = true;
		},
		
		readyWe: function(event)
		{			
			if (event.keyCode == 32 && ! keySpaceOccupied)
			{								
				isReadyWe = ! isReadyWe;
				res.start(-1);
				event.preventDefault();
				return true;
			}
		},
		
		start: function(time)
		{
			this.viewShowReady();
			
			if (time < 0)
			{
				if (! isReadyWe || ! isReadyHe)
				{
					if (time == -1) 
					{
						this.messageSendReady(isReadyWe, -2);
					}
					return;
				}
				else
				{					
					time = game.rally.time.get();
					this.messageSendReady(true, time);
				}
			}			
			
			//Main.stage.removeEventListener(KeyboardEvent.KEY_UP, this.ready);
			document.body.removeEventListener('keydown', readyWe);
			isReadyWe = false;
			isReadyHe = false;
			waitNode.style.display='none';
			
			//timer.reset();
			startTime = time + 1000;
			var delay = startTime-game.rally.time.get();
			if(delay<=0)
			{
				this.startImmediately(null);
			}
			else
			{
				//timer.reset();
				//timer.delay = delay;
				//timer.start();
				setTimeout(this.startImmediately, delay);
			}
			
			//view
			//view.visible = false;
			game.referee.view.visible = false;
		},
		
		startImmediately: function(event)
		{
			game.referee.rallyStart(startTime);
		},
		
		messageReceive: function(message)
		{
			switch(message.tp)
			{
				case 'wr':										
					isReadyHe = message.r;
					this.start(message.t);					
					break;
			}
		},
		
		messageSendReady: function(ready, time)
		{
			game.messageSend(
				{tp: 'wr', r: ready, t: time}
			);
			//"wr" == "wait ready (or not)"
		},
		
		viewShowReady: function()
		{
			//view.htmlText="<span class='wait'>Press <u>space</u> if you're "+(isReadyWe ? "not " : "")+"ready (you're "+(isReadyWe ? "" : "not ")+"ready).<br>Your opponent is "+(isReadyHe ? "" : "not ")+"ready.</span>";
			waitReadyNode.innerHTML='Нажмите пробел, если '+(isReadyWe ? 'не' : '')+' готовы. <br> Оппонент '+(isReadyHe ? '' : 'не')+' готов.';
		},
		
		unbind: function()
		{
			document.body.removeEventListener('keydown', readyWe);
		},
		
		opponentLeave: function()
		{
			this.unbind();
			waitNode.classList.remove('success');
			waitNode.classList.remove('fail');
			advice.hide();
			waitReadyNode.innerHTML='Оппонент покинул игру';
		}		
	}
	
	res.NetworkWait(game);
	readyWe=res.readyWe;

	return res;

}