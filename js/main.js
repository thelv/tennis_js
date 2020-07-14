/* this is a partually port from as3 so this is a mess */
Game=
{
	Rally: 
	{
		Ball: 
		{
			BallCollisions: {}, BallEval: {}
		},
		Player: 
		{
			PlayerCollisions: {}, PlayerEvalA: {}, PlayerEvalXY: {}, KeyHandler: {}
		},
		Referee: {},
		Scale: {},
		Time: {},
		Timer: {},
		BorderLines: {},
		FieldLines: {},
		ServeLines: {},
		MiddleLines: {MiddleLine: {}}
	},
	Referee: {},
	Wait: {},		
};
NetworkClient={};

document.addEventListener('DOMContentLoaded', function()
{			
	window.addEventListener('resize', resize);
	resize();
	
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
		});
		
		inputNode.addEventListener('keydown', function(event)
		{
			if(event.keyCode==13)
			{
				networkClient.messageSend({tp: 'chat', text: inputNode.value});
				inputNode.value='';
			}
		});

		return {
			receive: function(mes)
			{				
				var mesNode=mesTemplateNode.cloneNode(true);
				mesNode.querySelector('._name').innerText=mes.name;
				mesNode.querySelector('._text').innerText=mes.text;
				listNode.prepend(mesNode);
				//listNode.scrollTo(0, listNode.scrollHeight);
				if(mesI==30) 
				{
					//listNode.childNodes[0].remove();
					var m=listNode.childNodes;
					m[m.length-1].remove();
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
				waitNode.style.display='flex';
			},
			
			hide: function()
			{
				waitNode.style.display='none';
				
				document.getElementById('teaching_fail_border').style.display='none';
				document.getElementById('teaching_fail_out').style.display='none';
			},
			
			show: function()
			{
				waitNode.style.display='flex';
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
	
	teachingStage2=false;
	teaching=(function()
	{		
		var stage=false;
		var nodeBlock2=document.getElementById('teaching_block2');
		return {
			start: function()
			{				
				if(localStorage.teachingEnd) return;
				stage=0;

				var m=false;
				setTimeout(this.step1, 2000);
				document.body.addEventListener('keydown', m=function(e)
				{
					if(e.keyCode==32)
					{
						document.body.removeEventListener('keydown', m);
						teaching.step2();
					}
				});
			},
			
			step1: function()
			{			
				if(stage>1) return;
				
				document.getElementById('teaching_block1').style.display='block';				
			},
			
			step2: function()
			{		
				var keysMove=[65, 68, 83, 87];
				var keysTurn=[39, 37];
				var keysMoveWas=false;
				var keysTurnWas=false;
				var m=false; 
				
				stage=2;
				teachingStage2=true;
				document.getElementById('teaching_block1').style.display='none';
				document.getElementById('teaching_block2').style.display='block';	

				
				document.body.addEventListener('keydown', m=function(e)
				{
					if(! keysMoveWas && keysMove.indexOf(e.keyCode)!==-1)
					{
						keysMoveWas=true;
						nodeBlock2.classList.add('_turn_only');
					}
					
					if(! keysTurnWas && keysTurn.indexOf(e.keyCode)!==-1)
					{
						keysTurnWas=true;
					}
						
					if(keysMoveWas && keysTurnWas)
					{
						document.body.removeEventListener('keydown', m);
						teaching.step3();					
					}
				});				
			},
						
			
			step3: function()
			{
				document.getElementById('teaching_block2').style.display='none';
				document.getElementById('teaching_block3').style.display='block';
				teaching.end();
			},
			
			end: function()
			{
				stage=3;
				teachingStage2=false;
				document.getElementById('teaching_block3').style.display='none';	
				localStorage.teachingEnd=1;
			},

			failBorder: function()
			{
				if(localStorage.failBorderNotShow) return;
				
				document.getElementById('teaching_fail_border').style.display='block';
			},
			
			failOut: function()
			{
				if(localStorage.failOutNotShow) return;
				
				document.getElementById('teaching_fail_out').style.display='block';
				
			},
			
			failOutClose: function()
			{
				localStorage.failOutNotShow=1;
				document.getElementById('teaching_fail_out').style.display='none';
			},
			
			failBorderClose: function()
			{
				localStorage.failBorderNotShow=1;
				document.getElementById('teaching_fail_border').style.display='none';
			},
			
			playerSetPos: function(x, y)
			{				
				nodeBlock2.style.left=Math.round(x*fieldScale+12)+'px';
				nodeBlock2.style.bottom=Math.round((40+y)*fieldScale)+'px';			
				nodeBlock2.style.width='auto';
			}
		};
	})();
	
	Main.init();
	
	var lobbyClose=document.querySelector('#lobby_close');
	lobbyClose.addEventListener('click', function(){document.body.classList.add('lobby_closed');});
	var lobbyOpen=document.querySelector('#lobby_open');
	lobbyOpen.addEventListener('click', function(){document.body.classList.remove('lobby_closed');});
	
	document.getElementById('help_close').addEventListener('click', function(){localStorage.helpClosed=1;document.body.classList.add('help_closed');});
	document.getElementById('help_open').addEventListener('click', function(){localStorage.helpClosed='';document.body.classList.remove('help_closed');});
	
	document.querySelector('#chat #chat_close').addEventListener('click', function(){document.body.classList.add('chat_closed');});
	document.getElementById('chat_open').addEventListener('click', function(){document.body.classList.remove('chat_closed');});
	
	teaching.start();
});								