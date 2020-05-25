var networkClient=false;
var time=false;

Main=class
{						
	static init()
	{
		time=Game.Rally.Time.Time();
		Main.view=MainView();
		if(! localStorage.auth) localStorage.auth=(Math.random())+(Math.random())+(Math.random())+(Math.random());		
		networkClient=Main.networkClient=NetworkClient.NetworkClient('tennis2d.org', 8084);
		Main.gameCreate('local', false, time.get());
		if(localStorage.name) Main.nameSet(localStorage.name);
	}
	
	static messageSend(message, sendType=null)
	{			
		Main.networkClient.messageSend(message, sendType);
	}				
	
	static gameCreate(type, whoMain, t)
	{
		if(Main.game)
		{
			Main.game.rally.timer.unbind();
			Main.game.rally.player0.unbind();
			Main.game.rally.player1.unbind();
			Main.game.rally.wait.unbind();
		}
		Main.game = Game.Game(type, whoMain, t);
	}	
	
	static connectionEstablished()
	{
		Main.messageSend({auth: localStorage.auth, name: localStorage.name});
	}
	
	static messageReceive(message)
	{
		switch(message.tp)
		{
			case 'users':
				Main.view.users(message);
				break;
				
			case 'invites':
				Main.view.invites();
				break;
				
			case 'game_create':				
				Main.gameCreate('network', message.first_serve, message.t);
				break;				
				
			case 'name_set': 
				Main.nameSet(message.name);
				break;
				
		}
	}
	
	static nameSet(name)
	{
		localStorage.name=name;
		Main.view.name(name);
	}
	
	static nameChange()
	{
		var name='';
		if(name=prompt('Введите имя:'))
		{
			Main.nameSet(name);
			Main.messageSend({tp: 'name_set', name: name});
		}
	}
}

Main.stage=
{
	addChild: function(a)
	{
		//
	}
}