Game.Rally.Rally=function(game)
{	
	var Referee=Game.Rally.Referee.Referee;
	var FieldLines=Game.Rally.FieldLines.FieldLines;
	var BorderLines=Game.Rally.BorderLines.BorderLines;
	var MiddleLines=Game.Rally.MiddleLines.MiddleLines;
	var ServeLines=Game.Rally.ServeLines.ServeLines;
	var Time=Game.Rally.Time.Time;
	var Timer=Game.Rally.Timer.Timer;
	var Player=Game.Rally.Player.Player;
	var LocalPlayer=Game.Rally.Player.LocalPlayer;
	var RemotePlayer=Game.Rally.Player.RemotePlayer;
	var Ball=Game.Rally.Ball.Ball;

	var referee=0, fieldLines=0, borderLines=0, middleLines=0, serveLines=0, time=0, timer=0, ball=0, player0=0, player1=0;

	var serveLinesNode=document.querySelector('#border_serve');

	var res=
	{				
		get game(){return game;}, set game(a){game=a;},
		get referee(){return referee;}, set referee(a){referee=a;},
		get fieldLines(){return fieldLines;}, set fieldLines(a){fieldLines=a;},
		get borderLines(){return borderLines;}, set borderLines(a){borderLines=a;},
		get middleLines(){return middleLines;}, set middleLines(a){middleLines=a;},
		get serveLines(){return serveLines;}, set serveLines(a){serveLines=a;},
		get time(){return time;}, set time(a){time=a;},
		get timer(){return timer;}, set timer(a){timer=a;},
		get ball(){return ball;}, set ball(a){ball=a;},
		get player0(){return player0;}, set player0(a){player0=a;},
		get player1(){return player1;}, set player1(a){player1=a;},
	
		Rally: function(game)
		{
			this.game = game;
			
			time = Time(game);
			fieldLines = FieldLines();
			borderLines = BorderLines();
			middleLines = MiddleLines();
			serveLines = ServeLines();
			referee = Referee(game);
			ball = Ball(game);
			player0 = LocalPlayer(game, true);
			player1 = (game.type == 'local') ? LocalPlayer(game, false) : RemotePlayer(game, false);
			
			//view
			/*game.view.addChild(middleLines.view);
			game.view.addChild(serveLines.view);
			game.view.addChild(fieldLines.view);
			game.view.addChild(borderLines.view);*/
			game.view.addChild(player0.view);
			game.view.addChild(player1.view);
			game.view.addChild(ball.view);
			
			//start
			timer = Timer(game);
		},
		
		shiftTime: function(t)
		{						
			middleLines.lines[0].shiftTime(t);
			middleLines.lines[1].shiftTime(t);
			player0.shiftTime(t);
			player1.shiftTime(t);
			ball.shiftTime(t);			
		},
		
		viewShowServeLines: function(show)
		{
			if (show)
			{
				serveLines.view.visible = true;
				serveLinesNode.style.display='block';
			}
			else
			{
				serveLines.view.visible = false;
				serveLinesNode.style.display='none';
			}
		}
	}

	res.Rally(game);
	
	return res;
}