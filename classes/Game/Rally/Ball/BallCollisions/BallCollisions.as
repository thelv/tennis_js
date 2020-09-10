hitSense=20;
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
		
		collise: async function(t)
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
			
			var [k, r1]=segmentPlaneIntersection(r0, V.d(ball.r, r0), [0, 0, 0], [1, 0, 0]);
			if(k>0 && k<=1 && Math.abs(ball.r[2]-0.5)<0.5 && Math.abs(ball.r[1]<5.75))
			//if(k>0 && k<=1 && Math.abs(ball.r[2]-2)<2 && Math.abs(ball.r[1]<5.75))
			{
				window.tttt1=false;
				var t1=t0+(t-t0)*k;
				var [v_, w_]=hit(ball.v, ball.w, R, m, I, [0, 0, 0], [1, 0, 0], 0.3, 0, 0.11);
				//var [v_, w_]=hit(ball.v, ball.w, R, m, I, [0, 0, 0], [1, 0, 0], 0.2, 0, 0.8);
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
			if(k!==false && ! window.tttt1)
			{
				tttt1=1;
				t1=t0+(t-t0)*k;		
console.log(t-hitReceiveTime);		
				if(t1-hitReceiveTime>50)
				{
					await new Promise(function(s, e)
					{
						//setTimeout(function(){
						//phoneSocket.send('hit');
						//}, 1000);
						hitPromise=s;
						hitPromiseTime=t1;
						
					});
					t1=time.get();
				}
				hitFrozeView=true; 
				hitFrozeV=Math.sqrt(hitV[0]*hitV[0]+hitV[1]*hitV[1]+hitV[2]*hitV[2]);
				setTimeout(function(){hitFrozeView=false;}, 1000);
				//[v_, w_]=hit(ball.v, ball.w, R, m, I, V.s([player.vx/0.036, player.vy/0.036, 0], V.ps(/*5*/0.9, hitV)), hitN, 0.22, 0.2, 0.5);
				[v_, w_]=hit(ball.v, ball.w, R, m, I, V.s([player.vx/0.036, player.vy/0.036, 0], V.ps(/*5*//*1.5*//*0.9*/hitSense, hitV)), hitN, 0.22, 0.2, /*0.5*/0.3);
				//var hitForce=Math.max(0, Math.round(V.abs(V.d(v_, ball.v))-20)*10);
				var hitForce=Math.max(0, Math.round(V.abs(V.d(v_, ball.v)))*5);
				console.log(hitV);
				phoneSocket.send('hit'+hitForce);
				//racket.material.opacity=0;
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