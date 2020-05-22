Game.Rally.Ball.BallCollisions.BallCollisions=function(game, ball)
{
	var Ball=Game.Rally.Ball.Ball;
	
	var prevX=0, prevY=0, prevT=0, excludeLine=0, excludePlayer=0, m=0.1;
	
	var res=
	{		
		get game(){return game;}, set game(a){game=a;},
		get ball(){return ball;}, set ball(a){ball=a;},
		get prevX(){return prevX;}, set prevX(a){prevX=a;},
		get prevY(){return prevY;}, set prevY(a){prevY=a;},
		get prevT(){return prevT;}, set prevT(a){prevT=a;},
		get excludeLine(){return excludeLine;}, set excludeLine(a){excludeLine=a;},
		get m(){return m;}, set m(a){m=a;},
	
		BallCollisions: function(game, ball)
		{
			this.game = game;
			this.ball = ball;
			this.init(0);
		},
		
		init: function(t)
		{	
			prevX = ball.x;
			prevY = ball.y;
			prevT = t;
			excludeLine = -1;			
		},			
		
		collise: function(t)
		{
			//столкновение с линиями поля
			for (var i = 0; i < game.rally.fieldLines.lines.length; i++)
			{
				if (i != excludeLine)				
				{
					var line=game.rally.fieldLines.lines[i].concat();					
					if (i == 0 || i == 2)
					{
						line[1] -= ball.r/2;
						line[3] -= ball.r/2;
					}
					else
					{
						line[1] += ball.r/2;
						line[3] += ball.r/2;
					}					
					var collisionPoint = this.collisionWithLine(line, t);
					if (collisionPoint.exists)
					{											
						this.bounceOfLine(line);
						ball.setControlPoint(collisionPoint.x, collisionPoint.y, ball.vx, ball.vy, ball.va, collisionPoint.t);
						ball.viewShowPos();
						this.init(collisionPoint.t);
						excludeLine = i;						
						ball.shiftTime(t);						
						game.rally.referee.collision('field', i);
						break;
					}
				}
				else
				{
					excludeLine = -1;
				}
			}
			
			//выход за пределы поля
			for (var i = 0; i < game.rally.borderLines.lines.length; i++)
			{				
				var line = game.rally.borderLines.lines[i];
				var collisionPoint = this.collisionWithLine(line, t);
				if (collisionPoint.exists)
				{					
					game.rally.referee.collision('border', 0);
				}
			}
			
			//столкновение с нашим игроком
			if (excludePlayer != 0)
			{
				var player = game.rally.player0.collisions.getParams();
				var collisionPoint = this.collisionWithPlayer(player, t);
				if(collisionPoint.exists)
				{										
					this.bounceOfPlayer(player);
					ball.setControlPoint(collisionPoint.x, collisionPoint.y, ball.vx, ball.vy, ball.va, collisionPoint.t);
					game.rally.middleLines.hit(0, collisionPoint.x, collisionPoint.t);
					ball.viewShowPos();
					this.init(collisionPoint.t);
					excludePlayer = 0;
					excludeLine = -1;
					ball.messageSendHit(collisionPoint.t);
					ball.shiftTime(t);
					game.rally.referee.collision('player', 0);
				}
			}
			
			//столкновение с его игроком						
			if ((game.type!='network') && (excludePlayer != 1))
			{
				var player = game.rally.player1.collisions.getParams();
				var collisionPoint = this.collisionWithPlayer(player, t);
				if (collisionPoint.exists)
				{					
					this.bounceOfPlayer(player);
					ball.setControlPoint(collisionPoint.x, collisionPoint.y, ball.vx, ball.vy, ball.va, collisionPoint.t);
					game.rally.middleLines.hit(1, collisionPoint.x, collisionPoint.t);
					ball.viewShowPos();
					this.init(collisionPoint.t);
					excludePlayer = 1;
					excludeLine = -1;
					ball.shiftTime(t);					
					game.rally.referee.collision('player', 1);
				}
			}
			
			this.init(t);
			game.rally.player0.collisions.init(t);
			game.rally.player1.collisions.init(t);
		},
		
		collisionWithLine: function(line, t)
		{
			var i = MathLib.linesIntersection(prevX, prevY, ball.x, ball.y, line[0], line[1], line[2], line[3]);
			if (i.intersect)
			{
				return { exists: true, x: i.x, y:i.y, t: prevT+(t-prevT)*i.k};
			}
			else
			{
				return { exists: false };
			}
		},
		
		collisionWithPlayer: function(player, t)
		{				
			//положения мяча
			var ballR0 = [prevX, prevY];
			var ballR1 = [ball.x, ball.y];
			//положения игрока
			var plR0 = player.prevXy;
			var plR1 = player.xy;
			//углы игрока
			var plDir0 = player.prevDir;
			var plDir1 = player.dir;
			
			//переходим в новую систему отсчета
			var ballR0_ = MathLib.vReturn(MathLib.vMinus(ballR0, plR0), plDir0);
			var ballR1_ = MathLib.vReturn(MathLib.vMinus(ballR1, plR1), plDir0);
			
			//сдвиг из-за поворота игрока
			var turnShiftCoeff = MathLib.vReturn(plDir1, plDir0)[1];
			ballR1_[1] -= turnShiftCoeff * ballR1_[0];
			
			//сдвиг на радиус мяча
			if (ballR1_[1] - ballR0_[1] > 0)
			{
				ballR0_[1] += ball.r;
				ballR1_[1] += ball.r;
			}
			else
			{
				ballR0_[1] -= ball.r;
				ballR1_[1] -= ball.r;
			}	
			
			//находим точку пересечения				
			var k = ballR0_[1] / (ballR0_[1] - ballR1_[1]);
			if (k > 0 && k <= 1)
			{
				var x = ballR0_[0] + (ballR1_[0] - ballR0_[0]) * k;
				if (x >= -player.length && x <= player.length)
				{
					return { exists: true, x: prevX+(ball.x-prevX)*k, y: prevY+(ball.y-prevY)*k, t: prevT + (t - prevT) * k };
				}
				else return { exists: false };
			}
			else return { exists: false };		
		},
		
		bounceOfLine: function(line)
		{
			var dir = MathLib.getLineDirection(line[0], line[1], line[2], line[3]);
			var vtn = MathLib.decomposeVector(ball.vx, ball.vy, dir[0], dir[1]);
			if (vtn[1] > 0) 
			{
				vtn[0] *= -1;
				vtn[1] *= -1;
				dir[0] *= -1;
				dir[1] *= -1;
				
			}
			var d = MathLib.bounceOfRotatingBall(vtn[0], -vtn[1], ball.va, ball.r, 0.125, 2.5);
			vtn[0] += d[0];	
			ball.va += d[1];
			vtn[1] *= -(1-0.1*(Math.abs(vtn[1]/0.1)));
			var v = MathLib.composeVector(vtn[0], vtn[1], dir[0], dir[1]);
			ball.vx = v[0];
			ball.vy = v[1];
		},
		
		bounceOfPlayer: function(p)
		{						
			//направление ракетки игрока
			var dir = p.dir;
			
			//разлагаем скорсть мяча по направлению ракетки (vtn)
			var vtn = MathLib.decomposeVector(ball.vx, ball.vy, dir[0], dir[1]);
			//меняем "полярность", чтобы мяч (якобы) налетал на игрока "Vnorm<0"
			if (vtn[1] > 0)
			{
				vtn[0] *= -1;
				vtn[1] *= -1;
				dir[0] *= -1;
				dir[1] *= -1;			
			}
			
			//разлагаем скорость игрока по направлению ракетки (pvtn): Vnorm должно быть>0
			var pvtn = MathLib.decomposeVector(p.v[0], p.v[1], dir[0], dir[1]);
			
			//хитрая формула для расчета "силы удара" (пересчет скорости игрока)
			pvtn[1] = (pvtn[1] / 0.14) * 0.012 + 0.25 * m;
			
			//расчет изменения Vnorm мяча по ЗСИ
			if (pvtn[1] < 0)
			{
				//упрощенные рассмотрение, если игрок набегает на мяч
				var newVn = vtn[1] + 2 * pvtn[1] / (m + 1);
			}
			else
			{				
				//полноценный ЗСИ
				var newVn = -vtn[1] + 2 * (vtn[1] * m + pvtn[1]) / (m + 1);
			}
			
			//расчет изменений [Vtang, вращения мяча] исходя из [dVn мяча, Vtang мяча и игрока]
			var d = MathLib.bounceOfRotatingBall(vtn[0]-pvtn[0], (newVn-vtn[1])/2, ball.va, ball.r, 0.2, 2.5);
			vtn[0] += d[0];	
			ball.va += d[1];
			vtn[1] = newVn;
			
			//пересчитываем скорость мяча из Norm-Tang разложения в X-Y
			var v = MathLib.composeVector(vtn[0], vtn[1], dir[0], dir[1]);
			ball.vx = v[0];
			ball.vy = v[1];
		},
		
		hitWas: function(playerNumber)
		{
			excludeLine = -1;
			excludePlayer = playerNumber;
		},
		
		reset: function()
		{
			excludePlayer = -1;
			excludeLine = -1;
		}
	}
	
	res.BallCollisions(game, ball);

	return res;
}