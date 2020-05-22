Game.Rally.Referee.Referee=function(game)
{
		

	var wasOurHit=0, stage=0, whoServe=0;
	
	res=
	{				
		get wasOurHit(){return wasOurHit;}, set wasOurHit(a){wasOurHit=a;},
		get stage(){return stage;}, set stage(a){stage=a;},
		get whoServe(){return whoServe;}, set whoServe(a){whoServe=a;},
	
		Referee: function(game) 
		{
			this.game = game;
		},
		
		start: function(whoServe, t)
		{						
			wasOurHit = ! whoServe;
			stage = 'on win';
			this.whoServe = whoServe;	
			
			game.rally.player0.hold(false, t);
			game.rally.player1.hold(false, t);
			game.rally.ball.serve(true, whoServe, t);
			game.rally.ball.collisions.reset();
			
			game.rally.viewShowServeLines(false);			
		},
		
		collision: function(type, number)
		{			
			if ((game.type == 'local') || (! wasOurHit) || (type=='player'))
			{									
				if (type == 'player')
				{
					wasOurHit = (number == 0);
					stage = 'after hit';
				}
				else 
				{				
					if (stage == 'on win')
					{
						this.rallyEnd(wasOurHit);
					}
					else if (type == 'border')
					{										
						this.rallyEnd(! wasOurHit);
					}
					else
					{
						if ((number == 0 || number == 1) == wasOurHit)
						{
							this.rallyEnd(! wasOurHit);
						}
						else
						{
							stage = 'on win';
						}
					}
				}
			}
		},
		
		rallyEnd: function(whoWin, isMessageFromHe=false)
		{									
			if (! isMessageFromHe)
			{
				this.messageSendRallyEnd(whoWin);
			}
			game.referee.rallyEnd(whoWin);
			
			var t = game.rally.time.get();
			game.rally.player0.hold(true, t);
			game.rally.player1.hold(true, t);
			game.rally.ball.serve(false, false, t);
			
			game.rally.viewShowServeLines(true);
			game.rally.middleLines.init();
		},
		
		messageSendRallyEnd: function(whoWin)
		{
			game.messageSend({mt: 'rw', w: whoWin});
			//"rw"=="rally_win (or loose)"
		},
		
		messageReceive: function(message)
		{
			switch(message.mt)
			{
				case 'rw':
					this.rallyEnd(! message.w, true);
					break;
			}
		}
	}
	
	res.Referee(game);
	
	return res;

}