Game.Rally.Time.Time=function(game)
{

	var startTime=0, shiftTime=0, shiftTimes=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0], i=0, timer=0;
	
	var res=
	{
		
		get game(){return game;}, set game(a){game=a;},
		get startTime(){return startTime;}, set startTime(a){startTime=a;},
		get shiftTime(){return shiftTime;}, set shiftTime(a){shiftTime=a;},
		get shiftTimes(){return shiftTimes;}, set shiftTimes(a){shiftTimes=a;},
		get i(){return i;}, set i(a){i=a;},
		get timer(){return timer;}, set timer(a){timer=a;},	
		
		Time: function(game)
		{
			this.game = game;
			startTime = new Date().getTime();			
			//timer = new Timer(200, 10);
			//timer.addEventListener(TimerEvent.TIMER, messageSendSynchronizeRequest); 
			//timer.addEventListener(TimerEvent.TIMER_COMPLETE, synchronizeComplete);
		},
		
		get: function()
		{			
			return new Date().getTime() - startTime - shiftTime;
		},
		
		getAbs: function()
		{
			return new Date().getTime();
		},
		
		
		synchronize: function()
		{
			game.referee.start();
			return;
			//
			if (game.whoMain)
			{
				timer.start();
			}
			else
			{
				game.referee.start();
			}
		},
		
		messageSendSynchronizeRequest: function(event)
		{
			game.messageSend(
					{mt: 'ts', t0: getAbs()-startTime}
			);
			//"ts"=="time_synchronization"	
		},
		
		messageSendSynchronizeResponse: function(t0)
		{
			game.messageSend(
					{mt: 'ts', t0: t0, t1: get()}
			);
			//"rw"=="rally_win (or loose)"
		},
		
		messageReceive: function(message)
		{
			switch(message.mt)
			{
				case 'ts':
					if (game.whoMain)
					{
						shiftTimes[i] = (getAbs() - startTime + message.t0) / 2 - message.t1;
						
						var newShiftTime = 0;
						for (var j = 0; j <= 9; j++)
						{
							newShiftTime += shiftTimes[i];
						}
						shiftTime = newShiftTime / 10;
					}
					else
					{
						this.messageSendSynchronizeResponse(message.t0);
					}
			}
		},
		
		synchronizeComplete: function(event)
		{
			game.referee.start();
			timer.delay = 10000;
			timer.repeatCount = 0;
			timer.reset();
			timer.start();
		}
	}

	res.Time(game);
	
	return res;

}