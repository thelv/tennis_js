Game.Game=function(type, whoMain, t)
{		
	
	var 
		view=0,	
		rally=0,
		wait=0,
		referee=0;
	
	var res=
	{
		get type(){return type;}, set type(a){type=a;},
		get whoMain(){return whoMain;}, set whoMain(a){whoMain=a;},
		get view(){return view;}, set view(a){view=a;},
		get rally(){return rally;}, set rally(a){rally=a;},
		get wait(){return wait;}, set wait(a){wait=a;},
		get referee(){return referee;}, set referee(a){referee=a;},
	
		Game: function(type, whoMain, t) 
		{
			//view
			this.type = type;
			this.whoMain = whoMain;
			view = Game.GameView();
			Main.stage.addChild(view);
			
			rally = Game.Rally.Rally(this);
			wait = (type=='local') ? Game.Wait.Wait(this) : Game.Wait.NetworkWait(this);
			referee=Game.Referee.Referee(this, whoMain);
			
			time.reset(t);
			if(type!='local') time.sync();
			referee.start();
			//referee.start() executes from string time.synchronize()
		},
		
		messageReceive: function(message)
		{
			switch(message.tp)
			{
				case 'pcp':
				case 'pcpa':
					rally.player1.messageReceive(message);
					break;
				case 'bh':
					rally.ball.messageReceive(message);
					break;
				case 'rw':
					rally.referee.messageReceive(message);
					break;
				case 'wr':
					wait.messageReceive(message);
					break;
				/*case 'ts':
					rally.time.messageReceive(message);
					break;*/
			}
		},
		
		messageSend: function(message, sendType=null)
		{
			message.g=true;
			if (type=='network')
			{
				Main.networkClient.messageSend(message, sendType);
			}
		}
	}
	
	res.Game(type, whoMain, t);
	
	return res;

}