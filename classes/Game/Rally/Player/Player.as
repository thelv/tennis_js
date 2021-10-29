Game.Rally.Player.Player=function(game, side)
{
	
	var PlayerEvalXY=Game.Rally.Player.PlayerEvalXY.PlayerEvalXY;
	var PlayerEvalA=Game.Rally.Player.PlayerEvalA.PlayerEvalA;
	var PlayerCollisions=Game.Rally.Player.PlayerCollisions.PlayerCollisions;
	
	var view=0, startX=0, startA=0, holded=0, collisions=0, x=0, y=0, a=0, vx=0, vy=0, va=0, movingX=0, movingY=0, movingA=0, evalXY=0, evalA=0, length=40;
	
	var trainingAMax=0.3155192913420435;
	var trainingAMin=0.13631929134204346;
	
	var res=
	{			
			get view(){return view;}, set view(a){view=a;},
			get startX(){return startX;}, set startX(a){startX=a;},
			get startA(){return startA;}, set startA(a){startA=a;},
			get holded(){return holded;}, set holded(a){holded=a;},
			get collisions(){return collisions;}, set collisions(a){collisions=a;},
			get x(){return x;}, set x(a){x=a;},
			get y(){return y;}, set y(a){y=a;},
			get a(){return a;}, set a(b){a=b;},
			get vx(){return vx;}, set vx(a){vx=a;},
			get vy(){return vy;}, set vy(a){vy=a;},
			get va(){return va;}, set va(a){va=a;},
			get movingX(){return movingX;}, set movingX(a){movingX=a;},
			get movingY(){return movingY;}, set movingY(a){movingY=a;},
			get movingA(){return movingA;}, set movingA(a){movingA=a;},
			get evalXY(){return evalXY;}, set evalXY(a){evalXY=a;},
			get evalA(){return evalA;}, set evalA(a){evalA=a;},
			get length(){return length;}, set length(a){length=a;},
	
			Player: function(game, side)
			{																
				//logic
				this.game = game;	
				this.side = side;
				evalXY = PlayerEvalXY(this);
				evalA = PlayerEvalA(this);
				holded = true;
				startX = side ? 360: -360;
				startA = side ? -Math.PI / 2 : Math.PI / 2;
				this.setControlPointXY(startX, 0, 0, 0, 0, 0, 0);
				this.setControlPointA(side ? -Math.PI/2 : Math.PI/2, 0, 0, 0);		
				collisions = PlayerCollisions(this);

				//view					
				view = Game.Rally.Player.PlayerView(this);
				this.viewShowPos();
			},
		
		//methods
		
			//view

				viewShowPos: function()
				{					
					view.showPosition(this.x, this.y, this.a);
				},																					
				
			//logic	
			
				hold: function(hold, t)
				{
					if (hold)
					{
						//if(teaching.stage>2) { holded = true; }
						this.setControlPointXY(startX, 0, 0, 0, movingX, movingY, t);						
						this.setControlPointA(startA, 0, movingA, t)						
						collisions.init(t);
					}
					else
					{
						if(this.game.type=='local' && this.side==false && teaching.stage>10)
						{						
							this.setControlPointA(startA+Math.sign(Math.random()-0.5)*(trainingAMin+Math.random()*(trainingAMax-trainingAMin)), 0, movingA, t);
						}
						holded = false;
					}
				},
				
				setControlPointXY: function(x, y, vx, vy, movingX, movingY, t)
				{
				//	console.log(movingX);
					this.movingX=movingX;
					this.movingY=movingY;															
					this.x=x;
					this.y=y;
					this.vx=vx;
					this.vy=vy;
					evalXY.init(t);
				},
				
				setControlPointA: function(a, va, movingA, t)
				{					
				//console.log(movingA);
					this.movingA=movingA;
					this.a = a;					
					this.va = va;			
					evalA.init(t);
				},
				
				shiftTime: function(t)
				{					
					evalXY.eval(t);
					evalA.eval(t);
					this.viewShowPos();
					if(teachingStage2 && this.local) teaching.playerSetPos(x, y); 
				},

				hide: function()
				{
					view.hide();
				}
					
	}
	
	res.Player(game, side);
	
	return res;

}