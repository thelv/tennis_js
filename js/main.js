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
	
	teachingStage2=true;
	teaching=(function()
	{		
		var playerShadow=document.getElementById('player_shadow');
		var ballShadow=document.getElementById('ball_shadow');
		var animateInterval=false;
		var animateTimeout=false;
		var animateStopped=false;
		var playerShadowAnimateStop=function()
		{
			animateStopped=true;
			if(animateInterval)
			{
				clearInterval(animateInterval);				
			}
			if(animateTimeout)
			{
				clearTimeout(animateTimeout);
			}
			animateInterval=false;
			animateTimeout=false;
			playerShadow.style.display='none';
			ballShadow.style.display='none';
		}
		playerShadowAnimate=function(n, x0, pvx, pvy, ba, pa=0, bv=50)
		{
		    if(n==0 || animateStopped)
			{		
				animateTimeout=false;
				return;
			}
			animateStopped=false;
			/*playerShadow.style.marginTop='-50px';
			ballShadow.style.marginLeft='-150px';
			playerShadow.style.display='block';
			ballShadow.style.display='block';*/
						
/*			var px0=x0-pvx;
			var py0=x0-pvy;
			var bx0=x0+bv;*/
			
			var baa=Math.sqrt(1-ba*ba);
			
			var i=-1;
			var m=animateInterval=setInterval(function()
			{				
				playerShadow.style.marginTop=parseInt(i*pvy)+'px';
				playerShadow.style.marginLeft=parseInt(x0+i*pvx)+'px';
				playerShadow.style.transform='rotate('+pa+'deg)';
				if(i<=0)
				{
					ballShadow.style.marginLeft=parseInt(x0+i*bv-9)+'px';
					ballShadow.style.marginTop='-4px';
				}
				else
				{
					ballShadow.style.marginLeft=parseInt(x0-i*bv*baa-9)+'px';
					ballShadow.style.marginTop=parseInt(i*bv*ba-4)+'px';
				}
				if(i==-1)
				{
					playerShadow.style.display='block';
					ballShadow.style.display='block'					
				}
				i+=0.007;
				if(i>1)
				{
					clearInterval(m); 
					animateInterval=false;
					playerShadow.style.display='none';
					ballShadow.style.display='none';
					//if(! animateStopped) 
						animateTimeout=setTimeout(function(){playerShadowAnimate(n-1, x0, pvx, pvy, ba, pa, bv);}, 1500/*2000*/);
				}
			}, 0);
		}
		animate4=function()
		{
			animateStopped=false;
			setTimeout(function(){playerShadowAnimate(3, 331, -20, 0, 0.406, 78,120);}, 500);
		}
		
		animate5=function()
		{
			animateStopped=false;
			setTimeout(function(){playerShadowAnimate(3, 331, -20, 0, -0.406, 102,120);}, 500);
		}
		
		animate6=function()
		{
			animateStopped=false;
			setTimeout(function(){playerShadowAnimate(3, 331, -20, -40, 0, 90,120);}, 500);
		}
		
		animate7=function()
		{
			animateStopped=false;
			setTimeout(function(){playerShadowAnimate(3, 331, -20, -40, 0.4, 78,120);}, 500);
		}

		
		var nodeBlock2=document.getElementById('teaching_block2');
		var nodeBlock2_2=document.getElementById('teaching_block2_2');
		return {
			stage: false,
			start: function()
			{			
				if(localStorage.teachingStage)
				{
					teaching['step'+localStorage.teachingStage]();
					return;
				}
				
				teaching.stage=0;		
				Main.game.rally.player0.holded=false;
				//if(localStorage.teachingEnd) return;
				//stage=0;

				/*var m=false;
				setTimeout(this.step1, 2000);
				document.body.addEventListener('keydown', m=function(e)
				{
					if(e.keyCode==32)
					{
						document.body.removeEventListener('keydown', m);
						teaching.step2();
					}
				});*/
				document.getElementById('border_serve').style.display='none';
				setTimeout(function(){teaching.step1();}, 1000);
			},
			
			/*step1: function()
			{					
				if(stage>1) return;
				
				document.getElementById('teaching_block1').style.display='block';				
			},*/
			
			step1: function()
			{			
				//if(ym) ym(64682380,'reachGoal','ts1');
				var keysMove=[65, 68, 83, 87];
				//var keysTurn=[39, 37];
				var keysMoveWas=false;
				var keysTurnWas=false;
				var m=false; 
				
				teaching.stage=2;
				teachingStage2=true;
				document.getElementById('teaching_block1').style.display='none';
				document.getElementById('teaching_block2').style.display='block';	

				
				document.body.addEventListener('keydown', m=function(e)
				{
					if(keysMove.indexOf(e.keyCode)!==-1)
					{						
						document.body.removeEventListener('keydown', m);						
						setTimeout(function(){teaching.step2();}, 1000);						
					}
					
					
				});				
								
			},
						
			step2: function()
			{
				if(ym) ym(64682380,'reachGoal','ts1');
				teaching.stage=2;
				localStorage.teachingStage=teaching.stage;
				teachingStage2=true;
				document.getElementById('teaching_block2').style.display='none';
				document.getElementById('teaching_block2_2').style.display='block';
				
				var keysTurn=[39, 37];
				var m=false;
				
				document.body.addEventListener('keydown', m=function(e)
				{
					if(keysTurn.indexOf(e.keyCode)!==-1)
					{						
						document.body.removeEventListener('keydown', m);						
						setTimeout(function(){teaching.step3();}, 1000);
					}										
				});	
				
			},					
			
			step3: function()
			{				
				if(ym) ym(64682380,'reachGoal','ts2');
				teaching.stage=3;				
				localStorage.teachingStage=teaching.stage;
				teachingStage2=false;
				//document.getElementById('teaching_block2').style.display='none';
				document.getElementById('teaching_block2_2').style.display='none';
				document.getElementById('wait_').style.display='block';
				document.getElementById('teaching_block1').style.display='block';
				//document.getElementById('teaching_block4').style.display='block';
				
				var m=false;				
				document.body.addEventListener('keydown', m=function(e)
				{
					if(e.keyCode==32)
					{
						Main.game.rally.player0.hold(true, Main.game.rally.time.get())
						Main.game.rally.player0.holded=false;
						document.body.removeEventListener('keydown', m);
						//teaching.step4();
					}
				});
				/*teaching.end();*/
			},
			
			step4: function()
			{
				if(ym) ym(64682380,'reachGoal','ts3');
				teaching.stage=4;
				animate4();				
				localStorage.teachingStage=teaching.stage;
				document.getElementById('wait_').style.display='block';
				document.getElementById('teaching_block1').style.display='none';
				document.getElementById('teaching_block4').style.display='block';
				document.getElementById('border_cort_blue_bottom').style.display='block';
			},
			
			step5: function()
			{
				if(ym) ym(64682380,'reachGoal','ts4');
				teaching.stage=5;
				animate5();
				localStorage.teachingStage=teaching.stage;
				document.getElementById('wait_').style.display='block';
				document.getElementById('teaching_block4').style.display='none';
				document.getElementById('teaching_block5').style.display='block';
				document.getElementById('border_cort_blue_top').style.display='block';
				document.getElementById('border_cort_blue_bottom').style.display='none';
				
			},
			
			step6: function()
			{
				Main.game.rally.player0.afterKeyPressedChange();
				
				if(ym) ym(64682380,'reachGoal','ts5');
				teaching.stage=6;
				animate6();				
				localStorage.teachingStage=teaching.stage;
				document.getElementById('wait_').style.display='block';
				document.getElementById('border_cort_blue_top').style.display='none';
				document.getElementById('teaching_block5').style.display='none';
				document.getElementById('teaching_block2').style.display='block';
				document.getElementById('teaching_block2_cont').innerHTML='Продолжаем! Набегайте на мяч снизу вверх<!--при ударе-->,<br> чтобы закрутить его.';
				teachingStage2=true;
			},
			
			step7: function()
			{
				if(ym) ym(64682380,'reachGoal','ts6');
				teaching.stage=7;
				animate7();			
				localStorage.teachingStage=teaching.stage;
				document.getElementById('wait_').style.display='block';
				document.getElementById('teaching_block4').style.display='block';
				document.getElementById('teaching_block2').style.display='none';
				document.getElementById('teaching_block4_cont').innerHTML='Супер! Теперь отбейте мяч сюда, <br> закрутив его посильнее.';
				document.getElementById('border_cort_blue_bottom').style.display='block';
			},
			
			step11: function()
			{
				if(ym) ym(64682380,'reachGoal','ts7');
				teaching.stage=11;
				localStorage.teachingStage=teaching.stage;
				teaching.stage11successCount=0;
				document.getElementById('wait_').style.display='block';
				document.getElementById('teaching_block4_cont').innerHTML='...или сюда.';
				document.getElementById('teaching_block5_cont').innerHTML='Теперь подаёт соперник! Отбейте мяч сюда...';
				document.getElementById('border_cort_blue_bottom').style.display='block';
				document.getElementById('teaching_block5').style.display='block';
				document.getElementById('teaching_block4').style.display='block';
				document.getElementById('border_cort_blue_top').style.display='block';
			},
			
			step12: function()
			{
				if(ym) ym(64682380,'reachGoal','ts11');
				teaching.stage=12;
				localStorage.teachingEnd=1;
				document.getElementById('wait_').style.display='none';
				document.getElementById('teaching_block4').style.display='none';
				document.getElementById('teaching_block5').style.display='none';
				document.getElementById('border_cort_blue_top').style.display='none';
				document.getElementById('border_cort_blue_bottom').style.display='none';
				toast('Поздравляем! Вы прошли обучение.<br>Пора в бой.');
				keySpaceOccupied=true;
				setTimeout(function(){localStorage.teachingStage='';window.location.href='/?teaching_end';}, 1900);
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
				return;
				if(localStorage.failBorderNotShow) return;
				
				document.getElementById('teaching_fail_border').style.display='block';
			},
			
			failOut: function()
			{
				return;
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
				
				nodeBlock2_2.style.left=Math.round(x*fieldScale+12)+'px';
				nodeBlock2_2.style.top=Math.round((53-y)*fieldScale)+'px';
			},
			
			collision: function(type, number)
			{
				//console.log(Main.game.rally.ball.va);
				console.log(type, number);
				
				if(teaching.stage==4)
				{
					if(type=='field' && number==3) 
					{
						toastSuccess();
						teaching.stage4success=true;
					}
				}				
				else if(teaching.stage==5)
				{
					if(type=='field' && number==2)
					{
						teaching.stage5success=true;				
						toastSuccess();
					}
				}				
				else if(teaching.stage==6 && type=='player')
				{
					if(Math.abs(Main.game.rally.ball.va)>=0.015)
					{
						toastSuccess();
						teaching.stage6success=true
					}
				}
				else if(teaching.stage==7)
				{
					if(type=='player')
					{
						teaching.stage7success1=false;
						if(Main.game.rally.ball.va>=0.02)
						{
							toastSuccess();
							teaching.stage7success2=true
						}
						else teaching.stage7success2=false;
					}
					else if(type=='field' && number==3)
					{
						teaching.stage7success1=true;
						if(teaching.stage7success2) toastSuccess();
					}
				}
				else if(teaching.stage==11)
				{
					if(type=='player')
					{
						teaching.stage11success=false;											
					}
					else if(type=='field' && (number==2 || number==3))
					{
						teaching.stage11success=true;
						toastSuccess();
						teaching.stage11successCount++;
					}
				}
			},
			
			rallyStart: function()
			{
				if(teaching.stage>=4 && teaching.stage<=7)
				{
					playerShadowAnimateStop();
				}
			},
			
			rallyEnd(whoWin)			
			{
				if(teaching.stage==3) teaching.step4(); 
				else if(teaching.stage==4)
				{
					if(teaching.stage4success) teaching.step5();
					else
					{
						animate4();
						toast('Мимо! Попробуйте еще раз.');
					}
				}
				else if(teaching.stage==5)
				{
					if(teaching.stage5success) teaching.step6();
					else
					{
						animate5();
						toast('Мимо! Попробуйте еще раз.');
					}
				}
				else if(teaching.stage==6)
				{
					if(teaching.stage6success) teaching.step7();
					else
					{
						toast('Слабовато! Закрутите посильнее.');
						animate6();
					}
				}
				else if(teaching.stage==7)
				{
					if(! teaching.stage7success1)
					{
						animate7();
						toast('Мимо! Попробуйте еще раз.');
					}
					else if(! teaching.stage7success2)
					{
						animate7();
						toast('Слабое вращение! Попробуйте еще раз.');
					}
					else
					{
						teaching.step11();
					}						
				}
				else if(teaching.stage==11)
				{
					if(! teaching.stage11success)
					{
						toast('Мимо! Попробуйте еще раз.');
					}
					else
					{
						if(teaching.stage11successCount>=2)
						{
							toastSuccess();
							teaching.step12();
						}
						else
						{
							toast('Здорово! И еще разок для закрепления.');
						}
					}
				}
			},
			
			skip: function()
			{
				localStorage.teachingEnd=1;
				window.location.href='/?teaching_end';
			}
		};
	})();
	
	toastNode=document.getElementById('toast');
	toastContNode=document.getElementById('toast_cont');
	toastTimer=false;
	toast=function(mes, t=3500)
	{
		if(toastTimer) clearTimeout(toastTimer);
		toastContNode.innerHTML=mes;
		toastNode.style.display='block';
		toastNode.style.width='auto';
		toastTimer=setTimeout(function(){toastNode.style.display='none';}, t);
	}
	toastSuccessMess=['Супер!', 'Отлично!', 'Получилось!'];
	toastSuccess=function()
	{
		toast(toastSuccessMess[parseInt((Math.random()-0.0000001)*toastSuccessMess.length)], 1500)
	}
	
	Main.init();
	
	var lobbyClose=document.querySelector('#lobby_close');
	//lobbyClose.addEventListener('click', function(){document.body.classList.add('lobby_closed');});
	var lobbyOpen=document.querySelector('#lobby_open');
	//lobbyOpen.addEventListener('click', function(){document.body.classList.remove('lobby_closed');});
	
	document.getElementById('help_close').addEventListener('click', function(){localStorage.helpClosed=1;document.body.classList.add('help_closed');});
	document.getElementById('help_open').addEventListener('click', function(){localStorage.helpClosed='';document.body.classList.remove('help_closed');});
	
	document.querySelector('#chat #chat_close').addEventListener('click', function(){document.body.classList.add('chat_closed');});
	document.getElementById('chat_open').addEventListener('click', function(){document.body.classList.remove('chat_closed');});
	
	teaching.start();
});								