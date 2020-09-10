Game.Rally.Ball.Ball=function(game, player0)
{
	var BallEval=Game.Rally.Ball.BallEval.BallEval;
	var BallCollisions=Game.Rally.Ball.BallCollisions.BallCollisions;
	
	var a=[0, 0, 0], eval=0, collisions=0, r=[0, 0, 0], v=[0, 0, 0], w=[0, 0, 0], view=0, R=0.03335*2;
	
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
				this.a = [0, 0, 0];
				this.collisions = BallCollisions(game, this, player0);
				this.setControlPoint([0, 0, -1], [0, 0, 0], [0, 0, 0], 0);								
				//view
				view = Game.Rally.Ball.BallView(this);
				this.viewShowPos();				
			},

		//view methods
		
			viewShowPos: function()
			{					
			//	view.showPosition(this.x, this.y, this.a);
			},
			
		//logic methods
			
			setControlPoint(r, v, w, t)
			{
				this.r=r;
				this.v=v;
				this.w=w;
				eval.init(t);
				this.collisions.init(t);
				
				if(game.type=='local' && game.rally.player1)
				{
					game.rally.player1.ballHit(r[0], r[1], v[0], v[1], w[2], t);
				}
			},
			
			shiftTime: function(t)
			{								
				//if(hitPromise) return;
				eval.eval(t);
				collisions.collise(t);
				if(r[2]<R) r[2]=R;
				this.viewShowPos(); //view
				
				//game.rally.middleLines.ballPos(x);
			},
			
			serve: function(start, who, t)
			{	
				//who=true;
				if (start)
				{
					this.setControlPoint([0, 0, 2], [who ? 10 : -10, 0, 0], [0, 0, 0], t);
					collisions.init(t);
					collisions.reset();
				}
				else
				{
					this.setControlPoint([0, 0, -1], [0, 0, 0], [0, 0, 0], game.rally.time.get());
					collisions.init(t);
				}
			},
			
			messageSendHit: function(t)
			{					
				game.messageSend(
					{tp: 'bh', t: t, r: this.r, v: this.v, w: this.w}
					,{firstConnection: 9, connectionsRange: 3, connectionsCount: 2, seriesName: 'bh'}
				);
				//"bh" == "ball hit"
			},		
			
			messageReceive: function(message)
			{
				switch(message.tp)
				{
					case 'bh':
						message.r[0]=-message.r[0];
						message.r[1]=-message.r[1];
						message.v[0]=-message.v[0];
						message.v[1]=-message.v[1];
						message.w[0]=-message.w[0];
						message.w[1]=-message.w[1];

						//this.setControlPoint( -message.x, -message.y, -message.vx, -message.vy, message.va, message.t);
						this.setControlPoint(message.r, message.v, message.w, message.t);
						game.rally.middleLines.hit(1, -message.x, message.t);
						game.rally.referee.collision('player', 1);
						collisions.hitWas(1);
						this.shiftTime(game.rally.time.get());
						break;
				}
			},
			
			destroy: function()
			{
				//view.remove();
			},
			
			opponentLeave: function()
			{
				//this.setControlPoint(x, y, 0, 0, va, game.rally.time.get());
			}
						
	}
	
	res.Ball(game);
		
	return res;

}