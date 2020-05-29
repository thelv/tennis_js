var networkClient=false;
var time=false;
var gameStopWait=false;
var gameStopped=false;

Main=class
{					
	static init()
	{
		time=Game.Rally.Time.Time();
		Main.view=MainView();
		if(! localStorage.auth) localStorage.auth=(Math.random())+(Math.random())+(Math.random())+(Math.random());		
		//networkClient=Main.networkClient=NetworkClient.NetworkClient('tennis2d.org', 8084);
		networkClient=Main.networkClient=NetworkClient.NetworkClient('tennis.thelv.ru', 8083);
		Main.gameCreate('local', false, time.get());
		if(localStorage.name) Main.nameSet(localStorage.name);
	}
	
	static messageSend(message, sendType=null)
	{			
		Main.networkClient.messageSend(message, sendType);
	}				
	
	static gameCreate(type, whoMain, t, opponent=false)
	{
		document.body.classList.remove('game_local');
		document.body.classList.remove('game_network');
		document.body.classList.remove('game_remote');
		document.body.classList.add('game_'+type);
		if(Main.game)
		{
			Main.game.destroy();
		}
		Main.game = Game.Game(type, whoMain, t, opponent);
	}	
	
	static connectionEstablished(reconnect)
	{
		Main.messageSend({auth: localStorage.auth, name: localStorage.name, reconnect: reconnectIs});
	}
	
	static messageReceive(message)
	{
		switch(message.tp)
		{
			case 'users':
				Main.view.users(message);
				break;
				
			case 'invites':
				Main.view.invites(message);
				break;
				
			case 'game_create':				
				Main.gameCreate('network', message.first_serve, message.t, message.opponent);
				break;				
				
			case 'name_set': 
				Main.nameSet(message.name);
				break;
				
			case 'game_stop':
				Main.gameStop();
				break;
				
			case 'chat':
				chat.receive(message);
				
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
	
	static invite(id)
	{
		networkClient.messageSend({tp: 'invite_send', id: id});
	}
	
	static uninvite(id)
	{
		networkClient.messageSend({tp: 'invite_cancel', id: id});
	}
	
	static gameLeave()
	{		
		if(gameStopped) 
		{			
			Main.gameCreate('local', false, time.getAbs()); 
			gameStopped=false;
		}
		else
		{			
			networkClient.messageSend({tp: 'game_leave'});
			gameStopWait=true;
		}		
	}
	
	static gameStop()
	{
		gameStopped=true;
		if(gameStopWait)
		{
			Main.gameCreate('local', false, time.getAbs()); 
			gameStopWait=false;
		}
		else
		{
			//Main.game.rally.player0.view.hide();
			//Main.view.gameLeaveOpponent();
			Main.game.wait.opponentLeave();
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