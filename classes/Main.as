Main=class
{						
	static init()
	{
		Main.networkClient = NetworkClient.NetworkClient('tennis2.thelv.ru', 8080, 12);
	}
	
	static messageSend(message, sendType=null)
	{			
		Main.networkClient.messageSend(message, sendType);
	}				
	
	static gameCreate(type, whoMain)
	{
		Main.game = Game.Game(type, whoMain);
	}	
}

Main.stage=
{
	addChild: function(a)
	{
		//
	}
}