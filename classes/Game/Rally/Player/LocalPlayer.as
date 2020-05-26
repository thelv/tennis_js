Game.Rally.Player.LocalPlayer=function(game, side)
{
	
	var KeyHandler=Game.Rally.Player.KeyHandler.KeyHandler;
	
			
	var keyHandler=0;
	
	res=Game.Rally.Player.Player(game, side);
	
	
		
		res.LocalPlayer=function(game, side)
		{
			//logic									
			keyHandler = 
			(
				side 
			)
			?
			(
				(
					game.type == 'local'
				)
				?					
					KeyHandler(this, 75, 186, 76, 79, 39, 37)
				:
					//KeyHandler(this, 65, 68, 83, 87, 39, 37)
					KeyHandler(this, 68, 71, 70, 82, 39, 37)
			)	
			:
				KeyHandler(this, 65, 68, 83, 87, 78, 86)
			;
		}	
		
		//logic						
			
			//вызывается из keyHandler
			res.afterKeyPressedChange=function()
			{				
				var movingX=0;
				var movingY=0;
				var movingA=0;
				if(keyHandler.keyLeftPressed){movingX-=1;}
				if(keyHandler.keyRightPressed){movingX+=1;}
				if(keyHandler.keyDownPressed){movingY-=1;}
				if(keyHandler.keyUpPressed){movingY+=1;}
				if(keyHandler.keyTurnCounterClockWisePressed){movingA+=1;}
				if (keyHandler.keyTurnClockWisePressed) { movingA -= 1; }				
				if(Math.abs(this.movingX*this.movingY)==1)
				{									
					movingX = movingX / 1.414213;
					movingY = movingY / 1.414213;
				}	
				
				if (movingX != this.movingX || movingY != this.movingY || movingA != this.movingA)
				{
					var t = time.get();
					this.shiftTime(t);
												
					if(movingX!=this.movingX || movingY!=this.movingY)
					{														
						this.setControlPointXY(this.x, this.y, this.vx, this.vy, movingX, movingY, t);
						//this.sendMessage({message_type: 'control_point_xy', time: time, x: this.x, y: this.y, a: this.a, moving_x: this.movingX, moving_y: this.movingY, vx: this.controlPointVx, vy: this.controlPointVy, turning: this.turning}, this.sendTypeControlPoint);
					}					
					
					if (movingA != this.movingA)
					{
						this.setControlPointA(this.a, 0, movingA, t);
						//this.sendMessage({message_type: 'control_point_a', time: time, x: this.x, y: this.y, a: this.a, moving_x: this.movingX, moving_y: this.movingY, vx: this.controlPointVx, vy: this.controlPointVy, turning: this.turning}, this.sendTypeControlPoint);
					}
				}
			}
			
			res.messageSendControlPointXY=function(t)
			{
				game.messageSend(
					{tp: 'pcp', t: t, x: this.x, y: this.y, mx: this.movingX, my: this.movingY, vx: this.vx, vy: this.vy}
					,{firstConnection: 1, connectionsRange: 4, connectionsCount: 2, seriesName: 'pcp'}
				);
				//"pcp"=="player_control_point"
			}
			
			res.messageSendControlPointA=function(t)
			{
				game.messageSend(
					{tp: 'pcpa', t: t, a: this.a, ma: this.movingA}
					,{firstConnection: 1, connectionsRange: 4, connectionsCount: 2, seriesName: 'pcp'}
				);
				//"pcpa"=="player_control_point"				
			}		
			
			res.setControlPointXY_=res.setControlPointXY;
			res.setControlPointXY=function(x, y, vx, vy, movingX, movingY, t)
			{
				this.setControlPointXY_(x, y, vx, vy, movingX, movingY, t);
				this.messageSendControlPointXY(t);
			}
			
			res.setControlPointA_=res.setControlPointA;
			res.setControlPointA=function(a, va, movingA, t)
			{
				this.setControlPointA_(a, va, movingA, t);
				this.messageSendControlPointA(t);
			}
			
	res.LocalPlayer(game, side);
	res.unbind=keyHandler.unbind;
			
	return res;

}