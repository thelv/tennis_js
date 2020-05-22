Game.Rally.Player.PlayerCollisions.PlayerCollisions=function(player)
{
	
	var Player=Game.Rally.Player.Player;
	
	var prevX=0, prevY=0, prevA=0;
		
	var res=
	{	
		get player(){return player;}, set player(a){player=a;},
		get prevX(){return prevX;}, set prevX(a){prevX=a;},
		get prevY(){return prevY;}, set prevY(a){prevY=a;},
		get prevA(){return prevA;}, set prevA(a){prevA=a;},
	
		PlayerCollisions: function(player)
		{
			this.player = player;
			this.init(0);
		},
		
		init: function(t)
		{
			prevX = player.x;
			prevY = player.y;			
			prevA = player.a;
		},
		
		getParams: function()
		{			
			var r= {	
				xy: [player.x, player.y],
				prevXy: [prevX, prevY],
				//line: new Array(getLine(prevX, prevY, prevA), getLine(player.x, player.y, player.a)),
				dir: [Math.cos(player.a), Math.sin(player.a)],
				prevDir: [Math.cos(prevA), Math.sin(prevA)],
				v: new Array(player.vx, player.vy),
				length: player.length
			};
			return r;
		},
		
		getLine: function(x, y, a)
		{
			return new Array
			(
				x - player.length * Math.cos(a)
				,y - player.length * Math.sin(a)
				,x + player.length * Math.cos(a)
				,y + player.length * Math.sin(a)
			);
		}
		
	}
	
	res.PlayerCollisions(player);
	
	return res;

}