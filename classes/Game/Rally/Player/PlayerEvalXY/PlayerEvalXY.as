Game.Rally.Player.PlayerEvalXY.PlayerEvalXY=function(player)
{
	
	//var MiddleLine=Game.Rally.MiddleLines.MiddleLine.MiddleLine;
	var Player=Game.Rally.Player.Player;
	
	
	var evalX=0, evalY=0, evalVx=0, evalVy=0, evalT=0, controlPointTime=0, velocity=0.14, acceleration=0.0005, stopAccelerationCoeff=1.25, autoStopAcceleration=0.00015, length=40, turningVelocity=0.001, evalDt=3;
	
	var res=
	{	
		get player(){return player;}, set player(a){player=a;},
		get evalX(){return evalX;}, set evalX(a){evalX=a;},
		get evalY(){return evalY;}, set evalY(a){evalY=a;},
		get evalVx(){return evalVx;}, set evalVx(a){evalVx=a;},
		get evalVy(){return evalVy;}, set evalVy(a){evalVy=a;},
		get evalT(){return evalT;}, set evalT(a){evalT=a;},
		get controlPointTime(){return controlPointTime;}, set controlPointTime(a){controlPointTime=a;},
		get velocity(){return velocity;}, set velocity(a){velocity=a;},
		get acceleration(){return acceleration;}, set acceleration(a){acceleration=a;},
		get stopAccelerationCoeff(){return stopAccelerationCoeff;}, set stopAccelerationCoeff(a){stopAccelerationCoeff=a;},
		get autoStopAcceleration(){return autoStopAcceleration;}, set autoStopAcceleration(a){autoStopAcceleration=a;},
		get length(){return length;}, set length(a){length=a;},
		get turningVelocity(){return turningVelocity;}, set turningVelocity(a){turningVelocity=a;},
		get evalDt(){return evalDt;}, set evalDt(a){evalDt=a;},
		
		PlayerEvalXY: function(player)
		{			
			this.player = player;
		},
		
		init: function(t)
		{
			evalX = player.x;
			evalY = player.y;
			evalVx = player.vx;
			evalVy = player.vy;
			evalT = t;
			controlPointTime = t;
		},
		
		eval: function(t)
		{
			var actualT=0;
			do
			{
				actualT=Math.min(Math.max(t, this.evalT), this.evalT+this.evalDt);								
			
				if(actualT>this.evalT)
				{											
					var dt=actualT-this.evalT;											
					var movingX=player.movingX;
					var movingY=player.movingY;								
					
				//	movingY=player.movingX*hitNy+player.movingY*hitNx;
					//movingX=player.movingX*hitNx-player.movingY*hitNy;
					
					if(movingX==0 && movingY==0)
					//авто-остановка игрока
					{							
						var v=Math.sqrt(this.evalVx*this.evalVx+this.evalVy*this.evalVy);														
						
						if(t-this.controlPointTime<000)
						{							
							var autoStopAcceleration=this.autoStopAcceleration/2;
						}
						else
						{								
							autoStopAcceleration=this.autoStopAcceleration;
						}
						
						if(v!=0)
						{																
							var vx=this.evalVx-this.evalVx/v*autoStopAcceleration*dt;
							var vy=this.evalVy-this.evalVy/v*autoStopAcceleration*dt;
							if(this.evalVx*vx<0) vx=0;
							if(this.evalVy*vy<0) vy=0;
						}
						else
						{
							var vx=0;
							var vy=0;
						}
					}
					else
					{		
						var vx=this.evalVx+movingX*this.acceleration*dt;
						var vy=this.evalVy+movingY*this.acceleration*dt;													
						var vv=vx*vx+vy*vy;
						var prevVV=this.evalVx*this.evalVx+this.evalVy*this.evalVy;
						//лимитируем максимальную скорость
						if(vv>this.velocity*this.velocity && vv>prevVV)							
						{
							var newA=(this.evalVx*movingY*this.acceleration-this.evalVy*movingX*this.acceleration)/this.velocity/this.velocity;
							//newA=Math.min(newA, this.acceleration/this.velocity);						
							vx=this.evalVx-vy*newA*dt;
							vy=this.evalVy+vx*newA*dt;
						}
						//тормозим быстрее, чем разгоняемся
						else if(this.evalVx*movingX+this.evalVy*movingY<0)
						{					
							var v=Math.sqrt(this.evalVx*this.evalVx+this.evalVy*this.evalVy);
							var dVt=(this.evalVx*movingX+this.evalVy*movingY)/v;
							var dVn=(-this.evalVy*movingX+this.evalVx*movingY)/v;
							dVn=dVn;//(1+(0.5*Math.abs(dVt)/this.velocity));								
							dVt=dVt*this.stopAccelerationCoeff;//0.35/0.25;//2.5;
							var dVx=dVt*this.evalVx/v-dVn*this.evalVy/v;
							var dVy=dVt*this.evalVy/v+dVn*this.evalVx/v;
							dVx=this.acceleration*dVx*dt;
							dVy=this.acceleration*dVy*dt;
							if(movingX==0)
							{
								if(this.evalVx>0) dVx-=10*this.autoStopAcceleration*dt; else if(this.evalVx!=0) dVx+=10*this.autoStopAcceleration*dt;
							}
							else if(movingY==0)
							{								
								if(this.evalVy>0) dVy-=10*this.autoStopAcceleration*dt; else if(this.evalVy!=0) dVy+=10*this.autoStopAcceleration*dt;
							}
							if(-dVx/this.evalVx>1)						
							{					
								var stopDt=-dt*this.evalVx/dVx;
								dVx=(dt-stopDt)*this.acceleration*movingX;
								//dVx=-this.evalVx*1.0000001;
							}
							if(-dVy/this.evalVy>1)
							{												
								var stopDt=-dt*this.evalVy/dVy;
								dVy=(dt-stopDt)*this.acceleration*movingY;
								//dVy=-this.evalVy*1.0000001;
							}
							vx=this.evalVx+dVx;
							vy=this.evalVy+dVy;
						}
						//обычный случай
						else							
						{								
							var v=Math.sqrt(this.evalVx*this.evalVx+this.evalVy*this.evalVy);
							if(v!=0)
							{
								var dVt=(this.evalVx*movingX+this.evalVy*movingY)/v;
								var dVn=(-this.evalVy*movingX+this.evalVx*movingY)/v;
								dVn=dVn;//*100.5;//0.35/0.25;//2.5;
								dVx=dVt*this.evalVx/v-dVn*this.evalVy/v;
								dVy=dVt*this.evalVy/v+dVn*this.evalVx/v;
							}
							else
							{
								if(movingX*movingY==0)
								{
									var dVt=movingX+movingY;
									var dVn=0;
									dVx=dVt*movingX-dVn*movingY;
									dVy=dVt*movingY+dVn*movingX;
								}
								else
								{
									var dVt=(movingX+movingY)/Math.sqrt(2);
									var dVn=0;
									dVx=(dVt*movingX-dVn*movingY)/Math.sqrt(2);
									dVy=(dVt*movingY+dVn*movingX)/Math.sqrt(2);
								}
							}								
							dVx=this.acceleration*dVx*dt;
							dVy=this.acceleration*dVy*dt;								
							if(movingX==0)
							{
								if(this.evalVx>0) dVx-=2*this.autoStopAcceleration*dt; else if(this.evalVx!=0) dVx+=2*this.autoStopAcceleration*dt;
							}
							else if(movingY==0)
							{
								if(this.evalVy>0) dVy-=2*this.autoStopAcceleration*dt; else if(this.evalVy!=0) dVy+=2*this.autoStopAcceleration*dt;
								
							}
							else
							{
								if(this.evalVx*(-movingY)+this.evalVy*movingX>0)
								{
									dVx-=(-movingY)/Math.sqrt(2)*2*this.autoStopAcceleration*dt;
									dVy-=(movingX)/Math.sqrt(2)*2*this.autoStopAcceleration*dt;
								}
								else
								{
									dVx+=(-movingY)/Math.sqrt(2)*2*this.autoStopAcceleration*dt;
									dVy+=(movingX)/Math.sqrt(2)*2*this.autoStopAcceleration*dt;
								}
							}												
							vx=this.evalVx+dVx;
							vy=this.evalVy+dVy;
						}														
					}
					var x=this.evalX+vx*dt;
					var y = this.evalY + vy * dt;
					
					if(actualT>=t)
					{																
						var playerSideInt = player.side ? 1 : -1;
						var playerNumber = player.side ? 0 : 1;
						
						if (player.holded && Math.abs(x)<Math.abs(player.startX))
						{
							evalX=player.startX;
							evalVx = 0;
							x = evalX;
							vx = evalVx;
						}						
						else
						{
							var middleLine=player.game.rally.middleLines.lines[playerNumber];
							var middleLineXandV=middleLine.xAndVByY(y);
							if(playerSideInt*x<-middleLineXandV.x)
							{								
								evalX = -playerSideInt * middleLineXandV.x;//middleLine.x;
								evalVx = -playerSideInt * middleLineXandV.v;//middleLine.v;
								x = evalX;
								vx = evalVx;
							}
						}
						
						player.vx=vx;
						player.vy=vy;
						player.x=x;
						player.y=y;	
						return;
					}
					else
					{
						this.evalVx=vx;
						this.evalVy=vy;
						this.evalX=x;
						this.evalY=y;
						this.evalT+=this.evalDt;						
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
	
	res.PlayerEvalXY(player);
	
	return res;

}