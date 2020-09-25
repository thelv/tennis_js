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

		
		//	if(ball.v[0]+ball.v[1]<1) bv=[0.01,0.01,0.01]; else bv=ball.v;
		/*bv=ball.v;
			var dv=V.d(bv, [player0.vx*1000/36, player0.vy*1000/36, 0]);
			var dv=bv;
			if(dv[0]!=0) player0.a=Math.atan(dv[1]/dv[0])-Math.PI/2;
			else player0.a=-Math.PI/2;*/
			
			//if(Math.abs(ball.v[1])>ball.v[0]*0.5 && ball.v[0]>0) player0.a=Math.PI/6*Math.sign(ball.v[1])-Math.PI/2; else player0.a=-Math.PI/2;

/*var an=Math.atan((player0.y/36)/(player0.x/36+5));
//if(an<0) an+=Math.PI;
//player0.a=-Math.PI/2+(Math.PI/2-an)*Math.min(1, Math.max(0, (7-player0.x/36)));
an=Math.sign(an)*Math.max(0, Math.abs(an)-Math.PI/ 18);//15
player0.a=Math.PI/2+an;*/

/*var an=Math.atan((player0.y/36)/(player0.x/36+8));
//if(an<0) an+=Math.PI;
//player0.a=-Math.PI/2+(Math.PI/2-an)*Math.min(1, Math.max(0, (7-player0.x/36)));
an=Math.sign(an)*Math.max(0, Math.abs(an)-Math.PI/ 23);//15
player0.a=Math.PI/2+an;*/

var an=Math.atan((player0.y/36)/(player0.x/36+6.5));
//if(an<0) an+=Math.PI;
//player0.a=-Math.PI/2+(Math.PI/2-an)*Math.min(1, Math.max(0, (7-player0.x/36)));
an=Math.sign(an)*Math.max(0, Math.abs(an)-Math.PI/ 20);//15
//player0.a=Math.PI/2+an;

			//viewBall.rotation.y=t*0.001;
			camera.position.z=100+player0.x/360*10-cameraOffset*Math.cos(/*player0.a*/-Math.PI/2-Math.PI/2);
			camera.position.x=player0.y/360*10-cameraOffset*Math.sin(/*player0.a*/-Math.PI/2-Math.PI/2);
			camera.lookAt(player0.y/36, camera.position.y, 100+player0.x/36);
			//camera.lookAt(0, camera.position.y-1, 0);
			
	/*	camera.lookAt(0,0,0);
		camera.position.x=0;
		camera.position.y=8.5;
		camera.position.z=127;*/
			viewBall.position.x=ball.r[1];
			viewBall.position.z=100+ball.r[0];
			viewBall.position.y=ball.r[2];
			var wAbs=V.abs(ball.w);
			if(wAbs && ! hitPromise)
			{
				var wNorm=V.ps(1/wAbs, ball.w);
				viewBall.rotateOnWorldAxis(new THREE.Vector3(wNorm[1], wNorm[2], wNorm[0]), wAbs*(t-t_)/1000);
			}
			//viewBall.rotateOnWorldAxis(new THREE.Vector3(0, 0, 1), 0001);
			//viewBall.rotation.y=ball.a;
			
			ballShadow.position.x=ball.r[1];
			ballShadow.position.z=100+ball.r[0];	
			
			//ballShadow2.position.x=player0.y/36;
			ballShadow2.position.z=99.9+player0.x/36;	
			ballShadow2.position.y=ball.r[2];
			ballShadow2.position.x=ball.r[1];
			
			if(player0.x/36-ball.r[0]<2) ballShadow2.material.opacity=0.4; else ballShadow2.material.opacity=0.0;
			
//			ballShadow2.rotation.y=Math.atan(hitN[1]/hitN[0]);
	//		ballShadow2.rotation.x=Math.asin(-hitN[2]);
			
			viewPlayer0.position.z=100+player0.x/36;
			viewPlayer0.position.x=player0.y/36;
			viewPlayer0.rotation.y=player0.a-Math.PI/2;
			
			/*var d=V.d(ball.r, [player0.x/36, player0.y/36, ball.r[2]]);
			if(V.absSquare(d)>2)
			{
				var n=V.norm(V.d(ball.r, [player0.x/36, player0.y/36, ball.r[2]]));
				var na=Math.atan(n[1]/n[0]);				
				viewPlayer0.rotation.y=na;//;
				racketSpeed2.rotation.y=na;
				racketSpeed.rotation.y=na;
			}*/	
			
			viewPlayer1.position.z=100+player1.x/36;
			viewPlayer1.position.x=player1.y/36;
			viewPlayer1.rotation.y=player1.a-Math.PI/2;
			
			racket.position.z=100+player0.x/36-0.01;
			racket.position.x=player0.y/36;
			
			racketSpeed.position.z=100+player0.x/36;
			racketSpeed.position.x=player0.y/36;
			racketSpeed.rotation.y=player0.a-Math.PI/2;
			
			racketSpeed2.position.z=100+player0.x/36;
			racketSpeed2.position.x=player0.y/36;			
			racketSpeed2.rotation.y=player0.a-Math.PI/2;
						
									
			viewHitAxy.position.z=100+player0.x/36;
			viewHitAxy.position.x=player0.y/36;						
			var l=Math.sin(hitN[2])/2;
			if(hitN[2]<0) viewHitAxy.material.color.setHex(0x225522);//0x009900);
			else viewHitAxy.material.color.setHex(0x000099);
			viewHitAxy.position.y=-l+1;		
			viewHitAxy.scale.set(1, l, 1);			
						
			//racket.rotation.y=Math.atan(hitN[1]/hitN[0]);
			//racket.rotation.x=Math.asin(-hitN[2])+Math.PI/2;
			//racket.rotation.z=Math.PI/2+hitNAz;
			racket.rotation.z=-Math.atan(hitN[1]/hitN[0]);
			
						
			var hitVAbs=Math.sqrt(hitV[0]*hitV[0]+hitV[1]*hitV[1]+hitV[2]*hitV[2]);
			//racketSpeed.scale.set(1, hitVAbs/5, 1);
			//racketSpeed.scale.set(1, hitVAbs/4, 1);
			//racketSpeed.position.y=1+hitVAbs/4;
			//if(hitV[0]!=0) racketSpeed.rotation.y=Math.atan(hitV[1]/hitV[0]);
			//racketSpeed.rotation.x=Math.asin(hitV[2]/hitVAbs)+Math.PI/2;
			
			if(hitFrozeView)
			{
				hitVAbs=hitFrozeV;
				racketSpeed2.material.color.setHex(0x229922);
			}
			else
			{
				racketSpeed2.material.color.setHex(0x009900);
			}
			racketSpeed2.scale.set(1, Math.max(0.0225, 0/*hitVAbs*// /*8*/2), 1);
			
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