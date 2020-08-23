Game.Rally.Ball.BallCollisions.BallCollisions=function(game, ball)
{
	var Ball=Game.Rally.Ball.Ball;
	
	var r0=0, t0=0, m=0.0585, R=0.0667, I=m*R*R*0.92;
	
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
			r0=ball.r;
			t0=t;			
		},			
		
		collise: function(t)
		{	
			var [k, r1]=segmentPlaneIntersection(r0, V.d(ball.r, r0), [0, 0, R/2], [0, 0, 1]);
			//console.log(k, ball.v[2]);
			if(k>0 && k<=1)
			{
				var t1=t0+(t-t0)*k;
				var h=hit(ball.v, ball.w, R, m, I, [0, 0, 0], [0, 0, 1], 1, 1);
				ball.setControlPoint(r1, h.v, h.w, t1);
				console.log(m.w);
				ball.viewShowPos();	
				this.init(t1);					
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