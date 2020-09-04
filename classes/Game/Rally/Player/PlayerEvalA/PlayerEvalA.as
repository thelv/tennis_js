Game.Rally.Player.PlayerEvalA.PlayerEvalA=function(player)
{
	
	var Player=Game.Rally.Player.Player;
	
	var controlPointTime=0, controlPointA=0, velocity=0.001;		
	
	var res=
	{		
		get player(){return player;}, set player(a){player=a;},
		get controlPointTime(){return controlPointTime;}, set controlPointTime(a){controlPointTime=a;},
		get controlPointA(){return controlPointA;}, set controlPointA(a){controlPointA=a;},
	
		PlayerEvalA: function(player)
		{			
			this.player = player;
		},
		
		init: function(t)
		{
			controlPointA = player.a;
			controlPointTime = t;
		},
		
		eval: function(t)
		{
			//player.a = controlPointA - player.movingA * velocity * (t - controlPointTime);		
			controlPointA=player.a;
			controlPointTime=t;
			//console.log(player.a);
		}
	}
	
	res.PlayerEvalA(player);
	
	return res;

}