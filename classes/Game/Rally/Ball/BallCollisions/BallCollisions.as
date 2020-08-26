Game.Rally.Ball.BallCollisions.BallCollisions=function(game, ball, player)
{
	var Ball=Game.Rally.Ball.Ball;
	
	var r0=0, t0=0, m=0.0585, R=0.03335*2, I=m*R*R*0.92,  pr0=0, pa0=0;
	
	var res=
	{		
		get game(){return game;}, set game(a){game=a;},
		get ball(){return ball;}, set ball(a){ball=a;},
		get prevX(){return prevX;}, set prevX(a){prevX=a;},
		get prevY(){return prevY;}, set prevY(a){prevY=a;},
		get prevT(){return prevT;}, set prevT(a){prevT=a;},
		get excludeLine(){return excludeLine;}, set excludeLine(a){excludeLine=a;},	
	
		BallCollisions: function(game, ball)
		{
			this.game=game;
			this.ball=ball;
			this.init(0);			
		},
		
		init: function(t)
		{	
			//player=game.rally.player0;
			r0=ball.r;
			t0=t;
			pr0=[player.x/36, player.y/36, 0];
			pa0=player.a;
		},			
		
		collise: function(t)
		{				
			var [k, r1]=segmentPlaneIntersection(r0, V.d(ball.r, r0), [0, 0, R], [0, 0, 1]);
			if(k>0 && k<=1)
			{
				//tttt=1;
				var t1=t0+(t-t0)*k;
				var [v_, w_]=hit(ball.v, ball.w, R, m, I, [0, 0, 0], [0, 0, 1], 0.2, 0, 0.8);
				ball.setControlPoint(r1, v_, w_, t1);
				ball.shiftTime(t);
				return;
			}
			
			/*var [k, r1]=segmentPlaneIntersection(r0, V.d(ball.r, r0), [0, 0, (r0>0 ? R : -R)], [0, 0, 1]);
			if(k>0 && k<=1)
			{
				var t1=t0+(t-t0)*k;
				var [v_, w_]=hit(ball.v, ball.w, R, m, I, [0, 0, 0], [0, 0, 1], 0.25, 0, 0.25);
				ball.setControlPoint(r1, v_, w_, t1);
				ball.shiftTime(t);
				return;
			}*/
	
			/*[k, r1]=segmentPlaneIntersection(r0, V.d(ball.r, r0), [player.x/36, player.y/36, 0], [1, 0, 0]);
			if(k>0 && k<=1)
			{
				t1=t0+(t-t0)*k;
				[v_, w_]=hit(ball.v, ball.w, R, m, I, [player.vx/0.036, player.vy/0.036, 0], [1, 0, 0], 0.16, 0, 0.85);
				ball.setControlPoint(r1, v_, w_, t1);
				ball.shiftTime(t);
				return;
			}*/
			//if(window.tttt) return;				
			var pn=[Math.cos(player.a+Math.PI/2), Math.sin(player.a+Math.PI/2), 0];
			[k, r1, pr1]=segmentPlayerIntersection(r0, ball.r, pr0, [Math.cos(pa0+Math.PI/2), Math.sin(pa0+Math.PI/2)], [player.x/36, player.y/36, 0], pn, [1, 2]);
			//console.log(k);			
			if(k!==false && ! window.tttt)
			{
				tttt=1;
				t1=t0+(t-t0)*k;
				[v_, w_]=hit(ball.v, ball.w, R, m, I, V.s([player.vx/0.036, player.vy/0.036, 0], V.ps(5, hitV)), hitN, 0.2, 0.2, 0.5);
				console.log(hitV);
				ball.setControlPoint(r1, v_, w_, t1);
				pr0=pr1;
				ball.shiftTime(t);
				return;
			}
			
			this.init(t);
		},
		
		hitWas: function(playerNumber)
		{
			//
		},
		
		reset: function()
		{
			//
		}
	}
	
	res.BallCollisions(game, ball);

	return res;
}