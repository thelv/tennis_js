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
	var BotPlayer=Game.Rally.Player.BotPlayer;
	var RemotePlayer=Game.Rally.Player.RemotePlayer;
	var Ball=Game.Rally.Ball.Ball;

	var referee=0, fieldLines=0, borderLines=0, middleLines=0, serveLines=0, time=0, timer=0, ball=0, player0=0, player1=0;

	var t_=0;

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
			
			time = window.time;
			fieldLines = FieldLines();
			borderLines = BorderLines();
			middleLines = MiddleLines();
			serveLines = ServeLines();
			referee = Referee(game);		
			player0 =  (game.type!=='view') ? LocalPlayer(game, true) : RemotePlayer(game, true);
			player1 = (game.type == 'local') ? BotPlayer(game, false) : RemotePlayer(game, false);
			ball = Ball(game, player0);
			
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


			//viewBall.rotation.y=t*0.001;
			camera.position.z=100+player0.x/360*10-cameraOffset*Math.cos(player0.a-Math.PI/2);
			camera.position.x=player0.y/360*10-cameraOffset*Math.sin(player0.a-Math.PI/2);
			camera.lookAt(player0.y/36, camera.position.y, 100+player0.x/36);
			//camera.lookAt(0, camera.position.y-1, 0);
			viewBall.position.x=ball.r[1];
			viewBall.position.z=100+ball.r[0];
			viewBall.position.y=ball.r[2];
			var wAbs=V.abs(ball.w);
			if(wAbs)
			{
				var wNorm=V.ps(1/wAbs, ball.w);
				viewBall.rotateOnWorldAxis(new THREE.Vector3(wNorm[1], wNorm[2], wNorm[0]), wAbs*(t-t_)/1000);
			}
			//viewBall.rotateOnWorldAxis(new THREE.Vector3(0, 0, 1), 0001);
			//viewBall.rotation.y=ball.a;
			
			ballShadow.position.x=ball.r[1];
			ballShadow.position.z=100+ball.r[0];	
			
			viewPlayer0.position.z=100+player0.x/36;
			viewPlayer0.position.x=player0.y/36;
			viewPlayer0.rotation.y=player0.a-Math.PI/2;
			
			viewPlayer1.position.z=100+player1.x/36;
			viewPlayer1.position.x=player1.y/36;
			viewPlayer1.rotation.y=player1.a-Math.PI/2;
			
			//viewPlayer0.position.z=-2;//player1.x/36;
			
			
			renderer.render(scene, camera);
			
			t_=t;
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