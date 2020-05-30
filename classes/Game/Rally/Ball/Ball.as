Game.Rally.Ball.Ball=function(game)
{
	var BallEval=Game.Rally.Ball.BallEval.BallEval;
	var BallCollisions=Game.Rally.Ball.BallCollisions.BallCollisions;
	
	var eval=0,	collisions=0, x=0, y=0, vx=0, vy=0, va=0, a=0, r=4, view=0;
	
	var res= 
	{			
	
		get game(){return game;}, set game(a){game=a;},
		get eval(){return eval;}, set eval(a){eval=a;},
		get collisions(){return collisions;}, set collisions(a){collisions=a;},
		get x(){return x;}, set x(a){x=a;},
		get y(){return y;}, set y(a){y=a;},
		get vx(){return vx;}, set vx(a){vx=a;},
		get vy(){return vy;}, set vy(a){vy=a;},
		get va(){return va;}, set va(a){va=a;},
		get a(){return a;}, set a(b){a=b;},
		get r(){return r;}, set r(a){r=a;},
		get view(){return view;}, set view(a){view=a;},
				
		//constructor
		
			Ball: function(game)
			{
				this.game = game;
				
				this.eval = BallEval(this);
				this.a = 0;
				this.setControlPoint(0, 0, 0, 0, 0, 0);				
				this.collisions = BallCollisions(game, this);
				
				//view
				view = Game.Rally.Ball.BallView(this);
				this.viewShowPos();				
			},

		//view methods
		
			viewShowPos: function()
			{					
				view.showPosition(this.x, this.y, this.a);
			},
			
		//logic methods
			
			setControlPoint(x, y, vx, vy, va, t)
			{
				this.x = x;
				this.y = y;
				this.vx = vx;
				this.vy = vy;
				this.va = va;
				eval.init(t);
			},
			
			shiftTime: function(t)
			{								
				eval.eval(t);
				collisions.collise(t);
				this.viewShowPos(); //view
				
				//game.rally.middleLines.ballPos(x);
			},
			
			serve: function(start, who, t)
			{								
				if (start)
				{
					this.setControlPoint(0, 0, 0.25 * (who ? 1: -1), 0, 0, t);
					collisions.init(t);
				}
				else
				{
					this.setControlPoint(0, 0, 0, 0, 0, game.rally.time.get());
					collisions.init(t);
				}
			},
			
			messageSendHit: function(t)
			{					
				game.messageSend(
					{tp: 'bh', t: t, x: this.x, y: this.y, vx: this.vx, vy: this.vy, va: this.va}
					,{firstConnection: 9, connectionsRange: 3, connectionsCount: 2, seriesName: 'bh'}
				);
				//"bh" == "ball hit"
			},		
			
			messageReceive: function(message)
			{
				switch(message.tp)
				{
					case 'bh':
						this.setControlPoint( -message.x, -message.y, -message.vx, -message.vy, message.va, message.t);
						game.rally.middleLines.hit(1, -message.x, message.t);
						game.rally.referee.collision('player', 1);
						collisions.hitWas(1);
						this.shiftTime(game.rally.time.get());
						break;
				}
			},
			
			destroy: function()
			{
				view.remove();
			},
			
			opponentLeave: function()
			{
				this.setControlPoint(x, y, 0, 0, va, game.rally.time.get());
			}
						
	}
	
	res.Ball(game);
		
	return res;

}