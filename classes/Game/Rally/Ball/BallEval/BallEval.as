Game.Rally.Ball.BallEval.BallEval=function(ball)
{
	var Ball=Game.Rally.Ball.Ball;
	
	var evalT=0, evalX=0, evalY=0, evalVx=0, evalVy=0, evalVa=0, evalA=0, rVaCoeff=0.00133333333333, evalDt=3, stopAcceleration=0.00005;
	
	var res=
	{			
		get ball(){return ball;}, set ball(a){ball=a;},
		get evalT(){return evalT;}, set evalT(a){evalT=a;},
		get evalX(){return evalX;}, set evalX(a){evalX=a;},
		get evalY(){return evalY;}, set evalY(a){evalY=a;},
		get evalVx(){return evalVx;}, set evalVx(a){evalVx=a;},
		get evalVy(){return evalVy;}, set evalVy(a){evalVy=a;},
		get evalVa(){return evalVa;}, set evalVa(a){evalVa=a;},
		get evalA(){return evalA;}, set evalA(a){evalA=a;},
		get rVaCoeff(){return rVaCoeff;}, set rVaCoeff(a){rVaCoeff=a;},
		get evalDt(){return evalDt;}, set evalDt(a){evalDt=a;},
		get stopAcceleration(){return stopAcceleration;}, set stopAcceleration(a){stopAcceleration=a;},
		
		BallEval: function(ball)
		{
			this.ball = ball;
		},
		
		init: function(t)
		{
			evalT = t;
			evalX = ball.x;
			evalY = ball.y;
			evalVx = ball.vx;
			evalVy = ball.vy;
			evalA = ball.a;
			evalVa = ball.va;
		},
		
		eval: function(t)
		{
			
			do
			{
				var actualT=Math.min(Math.max(t, this.evalT), this.evalT+this.evalDt);								
			
				if(actualT>this.evalT)
				{											
					var dt=actualT-this.evalT;																			
					
					var x = this.evalX + evalVx * dt;
					var y = this.evalY + evalVy * dt;
					
					var vL = MathLib.getLengthByCoords(evalVx, evalVy);
					var vA = MathLib.getAngleByCoords(evalVx, evalVy);
										
					if (vL != 0)
					{
						vA += evalVa * rVaCoeff * dt / vL;
						
						var vx = vL * Math.cos(vA);
						var vy = vL * Math.sin(vA);
					}
					else
					{
						var vx = evalVx;
						var vy = evalVy;
					}
										
					var a = evalA + evalVa * dt*0.2;
					
					var va = evalVa;
			
					if(actualT>=t)
					{
						ball.vx=vx;
						ball.vy=vy;
						ball.x=x;
						ball.y = y;
						ball.va = va;
						ball.a = a;						
						return;
					}
					else
					{
						evalVx=vx;
						evalVy=vy;
						evalX=x;
						evalY = y;
						evalA = a;
						evalVa = va;
						evalT += evalDt;						
					}
				}
				else
				{
					return;
				}
			}
			while(true);
		}
	}
	
	res.BallEval(ball);
	
	return res;	
}