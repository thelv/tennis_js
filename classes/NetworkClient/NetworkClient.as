NetworkClient.NetworkClient=function(host, port)
{	
	var ws=false;
	reconnectIs=false;

	var res=
	{				
		NetworkClient: function(host, port)
		{
			host=host;
			port=port;
			this.connect();
			
		},
		
		messageSend: function(message)
		{
			if(ws) ws.send(JSON.stringify(message), function(){});
		},				
		
		reconnect: function()
		{
			reconnectIs=true;
			if(ws)
			{	
				ws=false;
				setTimeout(res.connect, 1000);
			}
		},
		
		connect: function()
		{
			ws=new WebSocket('ws://'+host+':'+port);
			
			ws.onclose=function()
			{
				res.reconnect();
			};
			
			ws.onerror=function()
			{
				res.reconnect();
			};
			
			ws.onmessage=function(message)
			{
				message=JSON.parse(message.data);
				if (message.g)
				{
					Main.game.messageReceive(message);
				}
				else
				{
					Main.messageReceive(message);
				}
			};
			
			ws.onopen=function()
			{
				Main.connectionEstablished(reconnectIs);
			};
		}
		
	}
	
	res.NetworkClient(host, port);
	
	return res;

}