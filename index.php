	<script> 
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
	</script>
	<script src='classes/Main.as'></script>
	<script src='classes/MainView.as'></script>
	<script src='classes/MathLib.as'></script>
	<script src='classes/View.as'></script>
	<script src='classes/NetworkClient/NetworkClient.as'></script>
	<script src='classes/Game/Game.as'></script>
	<script src='classes/Game/GameView.as'></script>
	<script src='classes/Game/Rally/Rally.as'></script>
	<script src='classes/Game/Rally/Ball/Ball.as'></script>
	<script src='classes/Game/Rally/Ball/BallView.as'></script>
	<script src='classes/Game/Rally/Ball/BallCollisions/BallCollisions.as'></script>
	<script src='classes/Game/Rally/Ball/BallEval/BallEval.as'></script>
	<script src='classes/Game/Rally/Player/Player.as'></script>
	<script src='classes/Game/Rally/Player/PlayerView.as'></script>
	<script src='classes/Game/Rally/Player/LocalPlayer.as'></script>
	<script src='classes/Game/Rally/Player/RemotePlayer.as'></script>
	<script src='classes/Game/Rally/Player/PlayerCollisions/PlayerCollisions.as'></script>
	<script src='classes/Game/Rally/Player/PlayerEvalA/PlayerEvalA.as'></script>
	<script src='classes/Game/Rally/Player/PlayerEvalXY/PlayerEvalXY.as'></script>
	<script src='classes/Game/Rally/Player/KeyHandler/KeyHandler.as'></script>
	<script src='classes/Game/Rally/Referee/Referee.as'></script>
	<script src='classes/Game/Rally/Scale/Scale.as'></script>
	<script src='classes/Game/Rally/Time/Time.as'></script>
	<script src='classes/Game/Rally/Timer/Timer.as'></script>
	<script src='classes/Game/Rally/BorderLines/BorderLines.as'></script>
	<script src='classes/Game/Rally/FieldLines/FieldLines.as'></script>
	<script src='classes/Game/Rally/ServeLines/ServeLines.as'></script>
	<script src='classes/Game/Rally/MiddleLines/MiddleLines.as'></script>
	<script src='classes/Game/Rally/MiddleLines/MiddleLine/MiddleLine.as'></script>
	<script src='classes/Game/Rally/MiddleLines/MiddleLine/MiddleLineView.as'></script>
	<script src='classes/Game/Referee/Referee.as'></script>
	<script src='classes/Game/Wait/Wait.as'></script>
	<script src='classes/Game/Wait/NetworkWait.as'></script>
	<script>
		
	</script>

	<html>
		<head>	
			<title>Tennis 2D</title>
			<link rel="shortcut icon" href="img/ball.png">
			<meta charset=utf8>
			<style>
				body {margin: 0; padding: 0}
				body.lobby_closed #lobby {display: none}
				body.lobby_closed #lobby_open {display: block}
				body.help_closed #help {display:none}
				body.help_closed #help_open {display:block}
				body.help_closed #border_cort_blue {display:none}
				body.chat_closed #chat_open {display:block}
				body.chat_closed #chat {display:none}
					
					
				*{font-family:tahoma;font-size:15px}
				body {background: rgb(136, 231, 136);}
				#page_game {width: 100%; height: 100%; display: flex; align-items: center; justify-content: center;}
				#center {width: 0; height: 0; position: relative}
				#border_out {position: absolute; width: 1234px; height: 100%;699px; border: 1px solid /*#77aa77;*/#80bb80;#aa4444; left: 50%;margin-left: -618px; -top: -350.5px; border-width: 0 1px 0 1px}
				#border_cort {position: absolute; width: 945px; height: 498px; border: 2px solid #555555; border-width: 2px 0; left: -477.5px; top: -251px}
				#border_cort_blue {position: absolute; width: 477.5px; height: 498px; border: 2px solid #227;#843030;#227;/*#494;*/#119;#0000aa; border-width: 2px 0; left: -477.5px; top: -251px}
					#help_blue {-color: #1a1aaa}
				#border_net {position: absolute; width:2px; background: #77aa77; height: 498px; border-width: 2px 0; left: -1px; top: -249px}
				#border_point {position: absolute; width:0px; height: 0px; border: 5px solid #77aa77; left: -5px; top: -5px;  border-radius: 5px}
				#border_serve {position: absolute; width: 717px; height: 498px; border: 1px solid #80bb80; left: -359.5px; top: -249px}
				
				.view {position: absolute}
				.player {position: absolute}
					.player div {position: absolute; top: -1px; left: -40px; background: url(img/player.png); width: 80px; height: 2px;}
					
				#ball {position: absolute}
					#ball div {position: absolute; top: -5px; left: -5px; background: url(img/ball.png); width: 10px; height: 10px}
					
				#lobby {position: absolute; left: 0px; width: 410px; bottom: 0px; top: 0px; background: rgba(0, 0, 0, 0.3);0.2); z-index: 100;padding: 12px 12px 12px 12px; color: white;border: 1px solid rgba(0,0,0,0.05);border-width:0 1px 0 0}
				#lobby/*:hover*/ {background: rgba(0, 0, 0, 0.5);0.4);0.5)}
				#lobby/*:hover*/ h1{color: #ce3333;#d83333;#c92424;;#c33}
				
				h1 {margin:0px 0px 10px; font-size: 19px; color: #b63333;#a33}
				#free_players, #invites {display: inline-block; width: 200px;230px; margin-right: 0 10px 0 10px; vertical-align: top}
				
				#help {position: absolute; top: /*281px;*/268px;267px;262px;260px;270px;259px;267px; left: -310px; width: 620px; text-align: center;color:#333}
				#help_open {position: absolute; top: /*281px;*/268px;267px;262px;260px;270px;259px;267px; left: -310px; width: 620px; text-align: center;color:#333; font-weight: normal; font-size: 15px;text-decoration: underline;color: gray; display:none; cursor: pointer}
				#help_close {cursor:pointer}
				#game_head {position: absolute; top: /*-322px;*//*-329px;*/-300px;bottom:274px;-300px;-312px; left: -300px; width: 600px; text-align: center;font-size: 17.5px;color: #333}
				#score{margin-top: 6px; font-size: 16px}
				
				#help h3{margin: 0 0 4px 0}
				#help h3 a {font-weight: normal; font-size: 15px;text-decoration: underline;display: none}
				#help > a {font-weight: normal; font-size: 15px;text-decoration: underline;color: gray;margin-top: 3px;display: inline-block}
				
				#wait {position: absolute; width: 250px; padding: 10px; -height: 50px; background: rgba(190, 240, 190, 0.8);#cec; top:/*-120px;*/ -165px;-150px; left: -126px; border: 1px solid #888; text-align: center}
				#wait b {color: #595; display: block; margin-bottom: 3px; display: -none}
				#wait span {font-size: 13px; margin-top: 4px; display: block; color: #777}
				.list a, .list .user {text-decoration: underline;margin-bottom:5px}
				.list {color:#d5d5d5 !important;margin-bottom: 15px !important; line-height-:24px;margin-top:5px}
				
				#auth {margin: 10px 0; color: #d5d5d5}
				#auth a {text-decoration: underline}
				#lobby_close:hover{border-width:11px;margin-top:-11px}
				#lobby_close{position:absolute;top:50%;right:4px;margin-top:-10px;border:10px solid transparent;border-right:10px solid #aaa; border-left:0; cursor: pointer}
				
				#lobby_open {position: absolute; left: 0px; width: 17px; bottom: 0px; top: 0px; background: #aca;rgba(0, 0, 0, 0.4);0.2); z-index: 100; color: white;border: 1px solid #9fbf9f;rgba(0,0,0,0.07);border-width:0 1px 0 0; cursor: pointer; display: none}
					#lobby_open div {position:absolute; top:50%; right:3px; margin-top:-10px; border:10px solid transparent; border-left:10px solid #888; border-right:0}
						#lobby_open:hover div {border-width: 11px; margin-top: -11px; right:2px}
				#chat {display-:none; position: absolute; width: 200px; top: 0; right: 0; color: /*#f3f3f3;#e9e9e9;*/#f8f8f8; margin-top: 0px; z-index: 1000; background: rgba(0, 0, 0, 0.4); padding: 0 0 0px 12px;19px; height: 100%; padding-right:0px; height:300px; border-top: 1px solid rgba(0,0,0,0.05)}
					#chat input {border: 0; background: transparent; font-size: 15px; border-bottom: 1px solid #fff; width:189px; line-height: 28px; color: white; display: block; margin-bottom: 6px; margin-top: 1px; padding-bottom: 3px}
					#chat input::placeholder {color: #bbb; font-style: italic-}
					#chat input.focus::placeholder {color: transparent; font-style: italic}
					#chat .message {margin: 5px 0; display: -flex; flex-direction: row;}							
				
				#chat.chat2 {position: absolute; width: 200px; top: 0; right: 0; color: #d5d5d5;/*#f3f3f3;#e9e9e9;*/#f8f8f8; margin-top: 0px; z-index: 1000; background: rgba(0, 0, 0, 0.5); padding: 0 0 0px 12px;19px; height: 100%; padding-right:0px; height:300px;bottom:0;top:auto;position-:relative;z-index:200;padding-top:12px}
					#chat_head {margin-bottom: 10px}
					#chat.chat2 input {border: 0; background: transparent; font-size: 15px; border-bottom: 1px solid #fff; width:189px; line-height: 28px; color: #d5d5d5; display: block; margin-bottom: 6px; margin-top: 1px; padding-bottom: 3px}
					#chat.chat2 input::placeholder {color: #bbb; font-style: italic-}
					#chat.chat2 input.focus::placeholder {color: transparent; font-style: italic}
					#chat .message {margin:5px 0; display: -flex; flex-direction: row;}							
						
				#chat.chat2 #chat_close {top: 6px; bottom: auto; border-bottom:0; border-top :10px solid #aaa; right-:12px; left-: auto; margin-left: -5px; -top: 15px}
						
					#chat.chat2 input {position:absolute;bottom:0;border: 0; background: transparent; font-size: 15px; border-bottom:0; border-top: 1px solid #fff; width:189px; line-height: 28px; color: white; display: block; margin-bottom: 6px; margin-bottom: 1px; margin-top:0;padding-top: 3px;padding-bottom:6px;display:block;}
					
					/*#chat_close:hover{border-width:11px;margin-top:-11px}
					#chat_close{position:absolute;top:50%;left:4px;margin-top:-10px;border:10px solid transparent;border-left:10px solid #aaa;}*/
					#chat_close:hover{border-width:11px;margin-left:-11px; cursor:pointer}
					#chat_close{position:absolute;left:50%;margin-left:-10px;border:10px solid transparent;border-bottom:10px solid #aaa; bottom: 6px}
					
				#chat_open{display: none; position:absolute; bottom: 0; right:0; -padding: 5px 22px 11px 23px; text-decoration: underline; color: #666; background: #aca;border: 1px solid #9fbf9f; border-width: 1px 0 0 1px; widt-h: 100px; text-align: center;width:211px;color:transparent;height:17px; cursor: pointer; z-index:10000}
					#chat_open #chat_close {border-bottom:10px solid #888;margin-bottom-s:7px; bottom:4px}
					
				#game_out {display:none; color: gray; text-decoration: underline; position: absolute; top: 7px;7px;6px; right: 12px; -right:224px}
				
				#vk {position: absolute; bottom: 12px; color: #d4d4d4; font-size: 14px}
					
				#name_change {cursor: pointer}
			</style>
		</head>	
		<body>
			<div id=lobby>	
				<div id=vk>Группа ВКонтакте: <u>vk.com/tennis2d</u></div> 
				<div id=lobby_close style=''></div>
				<h1>Теннис 2D</h1>
				<div id=auth>
					<!-- <a>Авторизуйтесь</a>, чтобы не потерять накопленный рейтинг.<br>
					Реальные данные аккаунта будут скрыты. -->
					Привет, <span id=name>user</span> (<a id=name_change>изменить имя</a>).
				</div>
				<div id=free_players>Свободные игроки
				<div class=list id=users_free_list style=''>
					...
					</div>
					
					Занятые игроки
					<div class=list id=users_not_free_list style=''>
					...
					</div>
					</div>
				<div id=invites>
					<div id=invites_to_me>Поступившие приглашения</div>
					<div class=list style=''>
					<!-- <a>thelv</a> <br>
					<a>thelv</a> <br>
					<a>thelv</a> <br>
					<a>thelv</a> <br>
					<a>thelv</a> <br>-->
					<span style='line-height-:18px'>Вас пока никто не пригласил.</span>
					</div>
					<div id=invites_from_me>Отправленные приглашения</div>
					<div class=list style=''>
					<span style='line-height-:18px'>Пригласите свободного игрока поиграть.</span>
					<!-- <a>thelv</a> <br>			
					<a>thelv</a> <br>
					<a>thelv</a> <br>--></div>
				</div>
			</div>	
			<div id=lobby_open>
				<div></div>
			</div>
			<div id=game_out>выйти из игры</div>
			<!-- <div id=chat>
				<div id=chat_close style=''></div>
				<input type=text placeholder='Введите сообщение' />			
				<div class=message>
					<u>thelv</u>:

						вот эта подача была збс

				</div>
				<div class=message>
					<u>susaNin</u>: 

						ну не понимаю как крутить

				</div>
				<div class=message>
					<u>thelvs</u>: 
					да не, просто
					
					
				</div>
					
				
			</div> -->
			<div id=chat class=chat2>
				<div id=chat_head style='color:#fff'>Чат</div>
				<div id=chat_close style=''></div>
				<!-- <input type=text placeholder='Введите сообщение' />				-->
				<div class=message>
					<u>thelv</u>:

						вот эта подача была збс

				</div>
				<div class=message>
					<u>susaNin</u>: 

						ну не понимаю как крутить

				</div>
				<div class=message>
					<u>thelvs</u>: 
					да не, просто
					
					
				</div>
				<input class=a2 type=text placeholder='Введите сообщение' />				
				
			</div>
			<div id=chat_open><div id=chat_close><div></div></div></div>
			<div id=border_out>
			</div>
			<div id=page_game>
				<div id=center>
					<div id=field>
						<div id=border_net>
						</div>
						<div id=border_point>
						</div>
						<div id=border_serve>
						</div>					
						<div id=border_cort>
						</div>
						<div id=border_cort_blue>
						</div>					
						<div id=border_center>
						</div>
						<div id=border_start>
						</div>
						<div id=wait>
							<!-- <b>Вы выиграли очко.</b>  -->
							Нажмите пробел, чтобы начать.
							<!-- Нажмите пробел, если готовы.<br>							
							Соперник не готов.<br>
							<!-- Нажмите ESC, чтобы выйти из игры.<br> -->
							<!-- <span>Совет: набегайте на мяч под углом, чтобы придать ему вращение.</span> -->
							<!-- <span>Совет: если мяч от соперника летит прямиком в аут, не отбивайте его.</span> -->
						</div>
						<div id=help>
							<!--<h3>Как играть <a>скрыть</a></h3>-->
							<b>Управление</b>: WSAD - движение, стрелки влево и вправо - поворот.<br>
							<div style='-margin-top:1px'></div><b>Задача</b>: отбить мяч в <span id=help_blue>синие</span> ограждения (навылет или в серые ограждения нельзя!).
							<a id=help_close>скрыть подсказку</a>
						</div>
						<div id=help_open>
							показать подсказку
						</div>
						<div id=game_head>						
							Обучение с неподвижным соперником
							<!-- Матч с petronya --><!-- (41 игр)-->
							<!-- <div id=score>Счет (сеты/геймы/подачи): 0:1 / 2:3 / 5:6*</div> -->
						</div>					
					</div>
				</div>
			</div>
			<script>
				//Main.gameCreate('local', false);
				Main.init();
				var chatInput=document.querySelector('#chat input');
				chatInput.addEventListener('focusin', function(){ chatInput.setAttribute('class', 'focus'); });
				chatInput.addEventListener('focusout', function(){ chatInput.setAttribute('class', ''); });
				var lobbyClose=document.querySelector('#lobby_close');
				lobbyClose.addEventListener('click', function(){document.body.classList.add('lobby_closed');});
				var lobbyOpen=document.querySelector('#lobby_open');
				lobbyOpen.addEventListener('click', function(){document.body.classList.remove('lobby_closed');});
				
				document.getElementById('help_close').addEventListener('click', function(){document.body.classList.add('help_closed');});
				document.getElementById('help_open').addEventListener('click', function(){document.body.classList.remove('help_closed');});
				
					document.querySelector('#chat #chat_close').addEventListener('click', function(){document.body.classList.add('chat_closed');});
				document.getElementById('chat_open').addEventListener('click', function(){document.body.classList.remove('chat_closed');});
			</script>
		</body>
	</html>
	<!--


			
			
			$a='game=0, whoServe=0, score=0, scoreLimits=0, scoreAdv=0, scoreInc=0, winner=-1, setsNumber=-1, view=0;';
			
			preg_match_all('/(\w*)=.*[,;]\s*/iU', $a, $m);
			
			//print_r($m);
			
			$s='';
			foreach($m[1] as $v)
			{
				$s.="\nget ".$v."(){return ".$v.";}, set ".$v."(a){".$v."=a;},";
			}

			echo $s;
			
	-->