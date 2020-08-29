Game.Rally.Timer.Timer=function(game)
{		
	var timer=0;
	
	var res=
	{				
		//var timer: flash.utils.Timer;
		
		Timer: function(game)
		{
			this.game = game;
			//timer = new flash.utils.Timer(10, 0);
			timer=setInterval(this.action, 100/6);
			//timer.start();
		},
		
		action: function(event)
		{
			if(hitPromise) return;
			game.rally.shiftTime(time.get());
		},
		
		unbind: function()
		{
			clearInterval(timer);
		}
	}
	
	res.Timer(game);
	
	return res;

}