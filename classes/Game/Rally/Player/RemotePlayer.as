Game.Rally.Player.RemotePlayer=function(game, side)
{
	
	
	res=Game.Rally.Player.Player(game, side);
	
	
	res.messageReceive=function(message)
	{
		switch(message.mt)
		{
			case 'pcp':
				this.setControlPointXY(-message.x, -message.y, -message.vx, -message.vy, -message.mx, -message.my, message.t);
				break;
			case 'pcpa':
				this.setControlPointA(message.a+Math.PI, message.va, message.ma, message.t);
				break;
		}
	}
	
	return res;

}