var networkClient=false;
var time=false;
var gameStopWait=false;
var gameStopped=false;

Main=class
{					
	static init()
	{
		networkClient=Main.networkClient=NetworkClient.NetworkClient('tennis.thelv.ru', 8083);
		time=Game.Rally.Time.Time();
		Main.view=MainView();
		if(! localStorage.auth) localStorage.auth=(Math.random())+(Math.random())+(Math.random())+(Math.random());		
		//networkClient=Main.networkClient=NetworkClient.NetworkClient('tennis2d.org', 8084);		
		Main.gameCreate('local', false, time.get());
		if(localStorage.name) Main.nameSet(localStorage.name);
	}
	
	static messageSend(message, sendType=null)
	{			
		Main.networkClient.messageSend(message, sendType);
	}				
	
	static gameCreate(type, whoMain, t, opponent=false, state=false)
	{
		if(type=='network') lobby.hide(); else if(type=='local') lobby.show();
		gameStopped=false;
		document.body.classList.remove('game_local');
		document.body.classList.remove('game_network');
		document.body.classList.remove('game_view');
		document.body.classList.add('game_'+type);
		if(Main.game)
		{
			Main.game.destroy();
		}
		Main.game = Game.Game(type, whoMain, t, opponent, state);
	}	
	
	static connectionEstablished(reconnect)
	{
		Main.messageSend({auth: localStorage.auth, name: localStorage.name, reconnect: reconnectIs});
	}
	
	static messageReceive(message)
	{
		switch(message.tp)
		{
			case 'user_id':
				Main.userId=message.user_id;
				break;
		
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
				
			case 'game_view':
				Main.gameCreate('view', message.first_serve, message.t, false, message);
				break;				
			
			case 'chat':
				chat.receive(message);
				break;
				
			case 'game_view_leave':
				Main.gameViewLeave();
				break;
				
			case 'new_window_opened':
				Main.newWindowOpened();
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
	
	static invite(id)
	{
		if(Main.game.type=='network' && ! Main.game.stopped) 
		{
			alert('Чтобы начать новую игру, необходимо выйти из этой.');
			return;
		}
		
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
		else if(Main.game.type!=='view')
		{			
			networkClient.messageSend({tp: 'game_leave'});
			gameStopWait=true;
		}		
		else
		{
			networkClient.messageSend({tp: 'game_view_leave'});
		}
	}
	
	static gameView(id)
	{
		networkClient.messageSend({tp: 'game_view', id: id});
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
			Main.game.opponentLeave();
			lobby.show();
		}
	}
	
	static gameViewLeave()
	{		
		Main.gameCreate('local', false, time.getAbs()); 
		lobby.show();
	}
	
	static newWindowOpened()
	{
		networkClient.stop();
		Main.view.newWindowOpened();
	}
}

Main.stage=
{
	addChild: function(a)
	{
		//
	}
}