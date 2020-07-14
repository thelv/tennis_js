Game.Rally.Player.BotPlayer=function(game, side)
{
	
	var KeyHandler=Game.Rally.Player.KeyHandler.KeyHandler;
	
			
	var keyHandler=0;
	
	var res=Game.Rally.Player.Player(game, side);
	
	
		
		res.BotPlayer=function(game, side)
		{
			//logic									
			
		}
		
		//logic												
			
			res.setControlPointXY_=res.setControlPointXY;
			res.setControlPointXY=function(x, y, vx, vy, movingX, movingY, t)
			{
				this.setControlPointXY_(x, y, vx, vy, movingX, movingY, t);
				//this.messageSendControlPointXY(t);
			}
			
			res.setControlPointA_=res.setControlPointA;
			res.setControlPointA=function(a, va, movingA, t)
			{
				this.setControlPointA_(a, va, movingA, t);
				//this.messageSendControlPointA(t);
			}
			
	res.BotPlayer(game, side);
	res.unbind=function()
	{
		res.view.remove();
//		keyHandler.unbind();
	}
	
	res.shiftTime_=res.shiftTime;
	res.shiftTime=function(t)
	{		
		res.shiftTime_(t);
		if(teaching.stage<20) return;
		if(this.state=='wait' || this.statePrev=='wait')
		{
			movingX=0;
			movingY=0;
		}
		else if(this.state=='side1')
		{
			var ball=game.rally.ball;
			var dir=MathLib.vNormalize([this.goal[0]-this.x, this.goal[1]-this.y]);
			//console.log(dir);
			movingX=dir[0];
			movingY=dir[1];
			if(Math.abs(this.x-ball.x)+Math.abs(this.y-ball.y)<100) this.setControlPointA(res.goalAngle, 0, 0, t);
		}
		else if(this.state=='side0')
		{
			var dir=MathLib.vNormalize([(game.rally.player0.x-560)-this.x, -this.y]);
			movingX=dir[0];
			movingY=dir[1];			
			this.setControlPointA(this.startA,0, 0, t);
		}
		this.setControlPointXY_(this.x, this.y, this.vx, this.vy, movingX, movingY, t);	
	}
			
	res.ballHit=function(x, y, vx, vy, va, t)
	{
		res.ballCP={x: x, y: y, vx: vx, vy: vy, va: va, t: t};
	}
			
	res.ballHitCalc=function(x, y, vx, vy, va, t)
	{
		if(va==0) 
		{
			res.ballCurveCenter=[x, y];
			res.ballCurveR=0;
			res.goal=[x, y];
		}
		else
		{
			var v=MathLib.vLength([vx, vy]);
			res.ballCurveCenter=MathLib.vPlus([x, y], MathLib.vProduct([-vy, vx], v/(va*0.00133333333333)));
			res.ballCurveR=1/(Math.abs(va)*0.00133333333333)*v*v;
			var dirToCenter=MathLib.vNormalize(MathLib.vMinus([res.x, res.y], res.ballCurveCenter));			
			res.goal=MathLib.vPlus(res.ballCurveCenter, MathLib.vProduct(dirToCenter, res.ballCurveR));
			
			var ballHitAngle=[dirToCenter[1], -dirToCenter[0]];
			if(ballHitAngle[0]<0) ballHitAngle=[-ballHitAngle[0], -ballHitAngle[1]];
			ballHitAngle=MathLib.vAngle(ballHitAngle);

			var ballCurveRSqr=res.ballCurveR*res.ballCurveR;
			if
			(
				! res.borderHitWas 
			&&
				(MathLib.vLengthSqr(MathLib.vMinus(res.ballCurveCenter, [-475, 250]))>ballCurveRSqr)==(MathLib.vLengthSqr(MathLib.vMinus(res.ballCurveCenter, [0, 250]))>ballCurveRSqr)
			&&
				(MathLib.vLengthSqr(MathLib.vMinus(res.ballCurveCenter, [-475, -250]))>ballCurveRSqr)==(MathLib.vLengthSqr(MathLib.vMinus(res.ballCurveCenter, [0, -250]))>ballCurveRSqr)
			)
			{
				res.goal=MathLib.vPlus(res.goal, MathLib.vProduct(MathLib.vNormalize(MathLib.vMinus([this.x, this.y], res.goal)), 100));
				res.goalAngle=res.a;
			}
			else
			{
				if(va>0)
				{
					if(Math.sign(Math.random()-0.5)>0)
					{
						var borderPoint=[475, 250];
					}
					else
					{
						var borderPoint=[0, -250];
					}
				}
				else
				{
					if(Math.sign(Math.random()-0.5)>0)
					{
						var borderPoint=[475, -250];
					}
					else
					{
						var borderPoint=[0, 250];
					}
				}
				
				//var borderPoint=[237.5, Math.sign(Math.random()-0.5)*250];
				var angleToBorderPoint=MathLib.vAngle(MathLib.vMinus(borderPoint, res.goal));
				
				res.goalAngle=(angleToBorderPoint+ballHitAngle)/2+Math.PI/2;
			//	console.log(res.goal, res.ballCurveCenter, res.ballCurveR);
			}
		}
	}	
	
	res.ballCP={x: 0, y: 0, vx: 0, vy: 0, va: 0, t: 0};
	res.state='wait';
	res.statePrev='wait';
	res.rallyState=function(state, borderHitWas=false)
	{
		res.statePrev=res.state;
		res.state=state;		
		res.borderHitWas=borderHitWas;
		
		if(state!='wait')
		{
			res.ballHitCalc(res.ballCP.x, res.ballCP.y, res.ballCP.vx, res.ballCP.vy, res.ballCP.va, res.ballCP.t)
		}
	}
			
	return res;

}