Game.Referee.Referee=function(game, whoMain)
{
	
	var Scale=Game.Rally.Scale.Scale;

	var whoServe=0, score=0, scoreLimits=0, scoreAdv=0, scoreInc=0, winner=-1, setsNumber=-1, view=0;		
	
	var scoreNode=document.querySelector('#score');
	var waitNode=document.querySelector('#wait');

	var res=
	{		
		get game(){return game;}, set game(a){game=a;},
		get whoServe(){return whoServe;}, set whoServe(a){whoServe=a;},
		get score(){return score;}, set score(a){score=a;},
		get scoreLimits(){return scoreLimits;}, set scoreLimits(a){scoreLimits=a;},
		get scoreAdv(){return scoreAdv;}, set scoreAdv(a){scoreAdv=a;},
		get scoreInc(){return scoreInc;}, set scoreInc(a){scoreInc=a;},
		get winner(){return winner;}, set winner(a){winner=a;},
		get setsNumber(){return setsNumber;}, set setsNumber(a){setsNumber=a;},
		get view(){return view;}, set view(a){view=a;},
	
		Referee: function(game, whoMain) 
		{
			this.game = game;
			whoServe = ! whoMain;
			this.scoreInit();			
			
			//view
			/*var style:StyleSheet = new StyleSheet(); 
			 
			var styleObj:Object = new Object(); 			
			styleObj.textAlign = "center";
			styleObj.fontWeight = "normal";
			styleObj.fontFamily = "_typewriter";
			styleObj.fontSize = 16;			
			style.setStyle(".score", styleObj); 
			
			view = new TextField();
			view.styleSheet = style;
			with (view)
			{
				width = 800; 
				height = 30; 
				multiline = true; 
				wordWrap = true; 				
				x = -400;//-Scale.convertX(1);
				y = -Scale.convertY(1) - 33;
			}
			game.view.addChild(view);*/
			//Main.stage.addChild(view);
			
			waitView.status();
			advice.hide();
			
			this.viewShowScore();			
		},
	
		start: function()
		{
			game.wait.wait();
		},
		
		
		rallyEnd: function(whoWin)
		{
			whoServe = ! whoServe;
			this.scoreChange(whoWin);
			this.viewShowScore();
			if (score[2][0] == setsNumber)
			{
				winner = 0;
			}
			else if (score[2][0] == setsNumber) {
				winner = 1;
			}			
			game.wait.wait();
			
			//view
			view.visible = true;

		},
		
		rallyStart: function(t)
		{		
			if (winner>=0)
			{
				winner = -1;
				this.scoreInit();
			}
			game.rally.referee.start(whoServe, t);
			
			//view
			view.visible = false;

		},
		
		
		scoreChange: function(whoWin, type=0)
		{						
			var whoWinInt = whoWin ? 0 : 1;
			scoreInc = [type, whoWinInt];
			var notWhoWinInt = whoWin ? 1 : 0;
			var newScore = (score[type][whoWinInt] += 1)
			if (newScore > scoreLimits[type])			
			{
				if (type == 0 && score[type][notWhoWinInt] == scoreLimits[0])
				{
					score[type][whoWinInt] = scoreLimits[0];
					if (scoreAdv == whoWinInt)
					{						
						score[type] = [0, 0];
						this.scoreChange(whoWin, type + 1);
						scoreAdv = -1;
					}
					else if(scoreAdv==notWhoWinInt)
					{						
						scoreAdv = -1;
					}
					else
					{
						scoreAdv = whoWinInt;
					}				
				}
				else
				{
					score[type] = [0, 0];
					this.scoreChange(whoWin, type + 1);
				}
			}	

			if(game.type!='view')
			{
				if(whoWin)
				{	
					waitView.status('success');
				}
				else
				{
					waitView.status('fail');
				}						
				advice.refresh();
			}
			else
			{
				waitView.ready(whoWin ? 'Левый игрок выиграл очко' : 'Правый игрок выиграл очко');
			}
		},
		
		scoreInit: function()
		{
			score = [[0, 0], [0, 0], [0, 0]];
			scoreLimits = [7, 2];
			scoreAdv = -1;
			scoreInc = [0,-1];			
		},
		
		scoreSet: function(score_)
		{
			score=score_;
		},
		
		viewShowScore: function()
		{
			var str = '<span class=\'score\'>Счёт (сеты/геймы/подачи): ';
			for (var i = 2; i >= 0; i--)
			{
				if (i == 0 && scoreAdv == 1)
				{
					str += 'adv ';
				}
				
				if (i == 0 && ! whoServe)
				{
					str += '*';
				}
								
				if (scoreInc[0] == i && scoreInc[1] == 1)
				{
					str += '<u>'+score[i][1]+'</u>';
				}
				else
				{
					str += score[i][1];
				}
				
				str+=':'								
				
				if (scoreInc[0] == i && scoreInc[1] == 0)
				{
					str += '<u>'+score[i][0]+'</u>';
				}
				else
				{
					str += score[i][0];
				}
				
				if (i == 0 && scoreAdv == 0)
				{
					str += ' adv';
				}
				
				if (i == 0 && whoServe)
				{
					str += '*';
				}
				
				if (i !== 0)
				{
					str += ' / ';
				}
			}
			str += '</span>';
			//view.htmlText = str;			
			scoreNode.innerHTML=str;
		}
		
	}
	
	res.Referee(game, whoMain);
	
	return res;

}