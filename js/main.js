document.addEventListener('DOMContentLoaded', function()
{			
	keySpaceOccupied=false;
	chat=(function()
	{
		var mesI=0;
		var listNode=document.querySelector('#chat ._list');
		var inputNode=document.querySelector('#chat input');
		var mesTemplateNode=document.querySelector('templates > .chat_message');

		inputNode.addEventListener('focusin', function()
		{
			keySpaceOccupied=true;
		});
		
		inputNode.addEventListener('focusout', function()
		{
			keySpaceOccupied=false;		
		})
		
		inputNode.addEventListener('keydown', function(event)
		{
			if(event.keyCode==13)
			{
				networkClient.messageSend({tp: 'chat', text: inputNode.value});
				inputNode.value='';
			}
		})

		return {
			receive: function(mes)
			{				
				var mesNode=mesTemplateNode.cloneNode(true);
				mesNode.querySelector('._name').innerText=mes.name;
				mesNode.querySelector('._text').innerText=mes.text;
				listNode.append(mesNode);
				listNode.scrollTo(0, listNode.scrollHeight);
				if(mesI==30) 
				{
					listNode.childNodes[0].remove();
				}
				else
				{
					mesI++;
				}
			}
		}
	})();
	
	advice=(function()
	{
		var node=document.querySelector('#wait_advice');
		var advices=['Совет: набегайте на мяч под углом, чтобы придать ему вращение.', 'Совет: если мяч от соперника летит прямиком в аут, не отбивайте его.', 'Совет: набегайте на мяч, чтобы увеличить его скорость.', 'Совет: следите за вращением мяча, чтобы предугадывать его траекторию.'];
		return {
			hide: function()
			{
				node.style.display='none';
			},
			
			refresh: function()
			{
				node.style.display='block';
				node.innerText=advices[parseInt(Math.min(advices.length*Math.random(), advices.length-1))];
			}
		}
	})();
	
	waitView=(function()
	{
		var waitNode=document.getElementById('wait');
		var waitReadyNode=document.getElementById('wait_ready');
		
		return {
			status: function(status)
			{
				if(! status)
				{
					waitNode.classList.remove('success');
					waitNode.classList.remove('fail');
				}
				else if(status=='success') 
				{
					waitNode.classList.add('success');
					waitNode.classList.remove('fail');
				}
				else
				{
					waitNode.classList.remove('success');
					waitNode.classList.add('fail');
				}
			},
		
			ready: function(text)
			{
				waitReadyNode.innerHTML=text;
				waitNode.style.display='block';
			},
			
			hide: function()
			{
				waitNode.style.display='none';
			},
			
			show: function()
			{
				waitNode.style.display='block';
			}
		}
	})();
	
	lobby=(function()
	{
		return {
			hide: function()
			{
				document.body.classList.add('lobby_closed');
			},
			
			show: function()
			{
				document.body.classList.remove('lobby_closed');
			}
		};
	})();
	
	Main.init();
	
	var lobbyClose=document.querySelector('#lobby_close');
	lobbyClose.addEventListener('click', function(){document.body.classList.add('lobby_closed');});
	var lobbyOpen=document.querySelector('#lobby_open');
	lobbyOpen.addEventListener('click', function(){document.body.classList.remove('lobby_closed');});
	
	document.getElementById('help_close').addEventListener('click', function(){document.body.classList.add('help_closed');});
	document.getElementById('help_open').addEventListener('click', function(){document.body.classList.remove('help_closed');});
	
	document.querySelector('#chat #chat_close').addEventListener('click', function(){document.body.classList.add('chat_closed');});
	document.getElementById('chat_open').addEventListener('click', function(){document.body.classList.remove('chat_closed');});
});								