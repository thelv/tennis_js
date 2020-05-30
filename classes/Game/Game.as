Game.Game=function(type, whoMain, t, opponent=false, state=false)
{		
	
	var 
		view=0,	
		rally=0,
		wait=0,
		referee=0;
		
	//view
	var gameHeadNode=document.querySelector((type=='local') ? '#game_local_head' : '#game_network_head');
	var gameCaptionNode=gameHeadNode.querySelector('._caption');
	
	
	var res=
	{
		get type(){return type;}, set type(a){type=a;},
		get whoMain(){return whoMain;}, set whoMain(a){whoMain=a;},
		get view(){return view;}, set view(a){view=a;},
		get rally(){return rally;}, set rally(a){rally=a;},
		get wait(){return wait;}, set wait(a){wait=a;},
		get referee(){return referee;}, set referee(a){referee=a;},
	
		stopped: false,
	
		Game: function(type, whoMain, t, state) 
		{
			//view
			this.type = type;
			this.whoMain = whoMain;
			view = Game.GameView();
			Main.stage.addChild(view);
			
			rally = Game.Rally.Rally(this);
			switch(type)
			{
				case 'local':
					wait =  Game.Wait.Wait(this);
					break;
					
				case 'network':
					wait=Game.Wait.NetworkWait(this);
					break;
					
				case 'view':
					wait=Game.Wait.ViewWait(this);
					break;				
			}
			referee=Game.Referee.Referee(this, whoMain);
			
			time.reset(t);
			if(type!='local') time.sync();
			referee.start();
			//referee.start() executes from string time.synchronize()
			
			gameHeadNode.style.display='block';
			if(type=='network') gameCaptionNode.innerText='Матч с '+opponent.name;
						
			rally.viewShowServeLines(true);						
			
			if(type=='view')
			{
				waitView.ready('Ожидание готовности игроков');
				this.setState(state.state);
				gameCaptionNode.innerText='Матч '+state.players[1].name+' с '+state.players[0].name;				
			}
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
		},
		
		destroy: function()
		{
			rally.ball.destroy();
			rally.timer.unbind();
			rally.player0.unbind();
			rally.player1.unbind();
			wait.unbind();
			
			gameHeadNode.style.display='none';
		},
		
		opponentLeave: function()
		{
			wait.opponentLeave();
			rally.ball.opponentLeave();
			rally.player1.hide();			
			this.stopped=true;
		}
	}		
	
	if(type=='view')
	{
		res.setState=function(state)
		{
			console.log(state);
			res.referee.scoreSet();
			if(state.wait>0)
			{
				wait.start(state.wait);
			}
			else if(state.wait==-1)
			{
				wait.wait();
			}
			else 
			{
				wait.start(0);
			}
			
			if(state.ball.h) res.messageReceive_(state.ball.h);
			if(state.players[0].cp) res.messageReceive_(state.players[0].cp);
			if(state.players[0].cpa) res.messageReceive_(state.players[0].cpa);
			if(state.players[1].cp) res.messageReceive_(state.players[1].cp);
			if(state.players[1].cpa) res.messageReceive_(state.players[1].cpa);
		}
	
		res.messageReceive_= function(message)
		{
			switch(message.tp)
			{
				case 'pcp':
					if(message.side)
					{
						message.x=-message.x;
						message.y=-message.y;	
						message.vx=-message.vx;
						message.vy=-message.vy;						
						message.mx=-message.mx;
						message.my=-message.my;						
						rally.player0.messageReceive(message);
					}
					else
					{
						rally.player1.messageReceive(message);
					}
					break;
				case 'pcpa':					
					if(message.side)
					{						
						//message.a=message.a-Math.PI;
						rally.player0.messageReceive(message);
					}
					else
					{
						rally.player1.messageReceive(message);
					}
					break;
				case 'bh':		
					if(message.side)
					{
						message.x=-message.x;
						message.y=-message.y;
						message.vx=-message.vx;
						message.vy=-message.vy;
					}
					rally.ball.messageReceive(message);
					break;
				case 'rw':
					if(! message.side)
					{
						message.w=! message.w;
					}
					rally.referee.messageReceive(message);
					break;
				case 'wr':
					if(message.t>0)
					{
						wait.messageReceive(message);
						break;
					}
				/*case 'ts':
					rally.time.messageReceive(message);
					break;*/
			}
		};
		
		res.messageReceive=function(message)
		{
			res.messageReceive_(message);
		}
	}
	
	res.Game(type, whoMain, t, state);
	
	return res;

}