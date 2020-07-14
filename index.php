<html>
	<head>
		<title>Tennis 2D</title>
		<link rel="shortcut icon" href="img/favicon.png">
		<meta charset=utf8>
		<link rel="stylesheet" type="text/css" href="css/main.css?7">
		<style>
			#lobby, #chat, #chat2, #help,  #game_network_head, #border_cort_blue, #wait_fail, #wait_success, #wait_advice {display:none !important}
			#wait_ {display:none}
			#game_local_head {display:block}
			
			#border_cort_blue_bottom {display:none;position: absolute; width: 475px; height: 504px; border: 2px solid #227;#843030;#227;/*#494;*/#119;#0000aa; border-width: 2px 0; left: -475px; top: -254px;border-top-color:transparent}
			#border_cort_blue_top {display:none;position: absolute; width: 475px; height: 504px; border: 2px solid #227;#843030;#227;/*#494;*/#119;#0000aa; border-width: 2px 0; left: -475px; top: -254px;border-bottom-color:transparent}
		</style>
		<script>
			var fieldScale=1;
			var resize=function()
			{
				var w=window.innerWidth;
				var h=window.innerHeight;
				var bodyScale=false;
				if(w<=1366)
				{
					bodyScale=0.9;
					w=w/bodyScale;
					h=h/bodyScale;
				}
				
				var scale=Math.min((h-200)/508, w/1300);
				fieldScale=scale;
				var scaleMargin=parseInt((scale-1)*508/2);
				var style=document.createElement('style');
				style.innerHTML='\
					#game_local_head {margin-bottom:'+(scaleMargin)+'px}\
					#field {transform:scale('+scale+')}\
					#border_out {width:'+(1234*scale)+'px; margin-left:-'+(1234/2*scale)+'px}\
					#help, #help_open {margin-top:'+scaleMargin+'px}\
					#wait {height:'+parseInt(255*scale)+'px}\
					#teaching_block2 {left:'+Math.round(360*scale+22)+'px; bottom: '+Math.round(40*scale)+'px; width:400px; white-space:nowrap}\
					#teaching_block4 {left:'+(-Math.round(250*scale))+'px; bottom: '+(-Math.round(250*scale))+'px; -width:400px; white-space:nowrap}\
					#teaching_block5 {left:'+(-Math.round(250*scale))+'px; top: '+(-Math.round(250*scale)+13)+'px; -width:400px; white-space:nowrap}\
				';
				if(bodyScale)
				{
					style.innerHTML+='body {transform: scale(0.9); transform-origin:0 0; height:111.111111%; width: 111.111111%}';
				}
				else
				{
					style.innerHTML+='body {transform: scale(1); transform-origin:0 0; height:auto; width: auto}';
				}
				document.head.append(style);
			}			
			resize();
		</script>
	</head>	
	<body>		
		<script>
			if(localStorage.helpClosed){document.body.classList.add('help_closed')};				
		</script>		
		<div id=new_window_opened>
			<div>Вы открыли сайт в новой вкладке, идите теперь туда.</div>
		</div>
		<div id=lobby>	
			<div id=vk>Группа ВКонтакте: <a target=_blank href='https://vk.com/tennis2d'>vk.com/tennis2d</a></div> 
			<div id=lobby_close style=''></div>
			<h1 style='margin-left-:19px'>Теннис 2D</h1><div style='display:none;position:absolute; left-:120px;4px;right:0px;top:14px;background: 0px 0 url(img/menu.png) no-repeat;width:20px;height:30px;background-size:14px;40px 25px; cursor:pointer'></div>
			<div style='display:none;position:absolute; left-:120px;4px;right:7px;top:14px;background: -2px 0 url(img/menu.png) no-repeat;width:10px;height:30px;background-size:14px;40px 25px; cursor:pointer'></div>			
			<div style='display:none;position:absolute; bottom:12px; color:#d4d4d4;-background:rgba(0,0,0,0.3);-padding:4px 6px;-margin-left:-6px'>*<span style='padding-left:2px'></span>имя ([личные встречи,] рейтинг, кол-во игр, пинг до вас)</div>
			<div id=auth>
				<!-- <a>Авторизуйтесь</a>, чтобы не потерять накопленный рейтинг.<br>
				Реальные данные аккаунта будут скрыты. -->
				Привет, <span id=name>user</span> (<!-- - <div style='display:none;height:5px'></div>--><a id=name_change>изменить имя</a><!--, <a>выйти</a>-->).
			</div>
			<div id=left_lists>
				<div id=free_players>
					<div>Игроки онлайн</div>
					<div class=list id=users_free_list style=''>
						...
					</div>
					<div class=teaching_block id=teaching_block3 style='left:12px;margin-top:2px'>
						<svg height="11" width="20" style='margin-top:-21px;margin-right:25px;position:absolute'>
							<polygon points="0,10 8,0 16,10" style="fill:#fff;stroke:#aaa;stroke-width:1" />
							<polygon points="0,11 8,1 16,11" style="fill:#fff;stroke:#fff;stroke-width:1" />
							Sorry, your browser does not support inline SVG.
						</svg>
						<!-- <b>Обучение <span>(шаг 3 из 3)</span></b> -->
						<div>
							Нажмите на НИКНЕЙМ игрока,<br> для игры ОНЛАЙН по сети.						
						</div>						
						<a style='float:right;' onclick='teaching.end()'><b>закрыть</b></a>
					</div>
				</div>
				<div>					
					<div>Смотреть игры онлайн</div>
					<div class=list id=users_not_free_list style=''>
						...
					</div>
				</div>
			</div>
			<div id=invites>
				<div id=invites_to_me>Поступившие приглашения</div>
				<div class=list  id=users_invites_from_list style=''>				
					...
				</div>
				<div id=invites_from_me>Отправленные приглашения</div>
				<div class=list id=users_invites_who_list style=''>
					...
				</div>
			</div>
		</div>	
		<div id=lobby_open>
			<div></div>
		</div>
		<div id=game_leave>выйти из игры</div>		
		<div id=chat class=chat2>
			<div style='display:none;position:absolute; left-:120px;4px;right:7px;top:9px;background: -2px 0 url(img/menu.png) no-repeat;width:10px;height:30px;background-size:14px;40px 25px; cursor:pointer'></div>			
			<div id=chat_head style='color:#fff'>Чат</div>
			<div id=chat_close style=''></div>
			<div class=_list></div>
			<input class=a2 type=text placeholder='Введите сообщение' />								
		</div>
		<div id=chat_open><div id=chat_close><div></div></div></div>
		<div id=border_out>
		</div>
		<div id=page_game>
			<div id=center>
				<div id=toast style='display:none;position:absolute;top:0;width:auto'>
					<div id=toast_cont style='position:relative;left:-50%;margin-top:-50px;background:#ddd;border:1px solid #bbb;border-radius:5px;z-index:1010123;white-space:nowrap;padding:10px'>
					</div>
				</div>
				<div id=teaching_block2 style='margin-bottom:15px;z-index:1999;display:none;position:absolute;text-align:center'>
					<div style='position:relative;left:-50%;display:table;z-index:1999' class=teaching_block>
						<svg height="11" width="20" style='margin-bottom:-11px;right:50%;position:absolute;bottom:0;'>
							<polygon points="0,1 8,11 16,1" style="fill:#fff;stroke:#aaa;stroke-width:1" />
							<polygon points="0,0 8,10 16,0" style="fill:#fff;stroke:#fff;stroke-width:1" />
							Sorry, your browser does not support inline SVG.
						</svg>	
						<!-- <b>Обучение <span>(шаг 2 из 3)</span></b> -->
						<div class=_all>
							Это ваш игрок.<br>Нажмите клавиши W, S, A, D, чтобы двигаться по полю.
						</div>	
						<div class=_turn id=teaching_block2_cont>
							Нажмите клавиши <span style='font-size:21px;line-height:10px'>&#x21e6;</span> и <span style='font-size:21px;line-height:10px'>&#x21e8;</span>, чтобы поворачивать ракетку.<br>
						</div>
					</div>
				</div>	
				<div id=teaching_block4 style='margin-bottom:15px;z-index:1999;display:none;position:absolute;text-align:center'>
					<div style='position:relative;left:-50%;display:table;z-index:1999' class=teaching_block>
						<svg height="11" width="20" style='margin-bottom:-11px;right:50%;position:absolute;bottom:0;'>
							<polygon points="0,1 8,11 16,1" style="fill:#fff;stroke:#aaa;stroke-width:1" />
							<polygon points="0,0 8,10 16,0" style="fill:#fff;stroke:#fff;stroke-width:1" />
							Sorry, your browser does not support inline SVG.
						</svg>	
						<!-- <b>Обучение <span>(шаг 2 из 3)</span></b> -->
						<div id=teaching_block4_cont class=_all>
							Отлично! Теперь отбейте мяч в это ограждение.
						</div>							
					</div>
				</div>	
				<div id=teaching_block5 style='margin-bottom:15px;z-index:1999;display:none;position:absolute;text-align:center'>
					<div style='position:relative;left:-50%;display:table;z-index:1999' class=teaching_block>
						<svg height="11" width="20" style='margin-top:-11px;right:50%;position:absolute;top:0;'>
							<polygon points="0,10 8,0 16,10" style="fill:#fff;stroke:#aaa;stroke-width:1" />
							<polygon points="0,11 8,1 16,11" style="fill:#fff;stroke:#fff;stroke-width:1" />
							Sorry, your browser does not support inline SVG.
						</svg>	
						<!-- <b>Обучение <span>(шаг 2 из 3)</span></b> -->
						<div  id=teaching_block5_cont class=_all>
							Получилось! Теперь отбейте мяч в это ограждение.
						</div>							
					</div>
				</div>	
				<div id=wait>
					<div class=teaching_block id=teaching_block1 style='bottom:50%;margin-bottom:35px;-width:200px;text-align:center'>
						<svg height="11" width="20" style='margin-bottom:-11px;right:50%;position:absolute;bottom:0;'>
							<polygon points="0,1 8,11 16,1" style="fill:#fff;stroke:#aaa;stroke-width:1" />
							<polygon points="0,0 8,10 16,0" style="fill:#fff;stroke:#fff;stroke-width:1" />
							Sorry, your browser does not support inline SVG.
						</svg>
					
						<!-- <b>Обучение <span>(шаг 1 из 3)</span></b> -->
						<div style='white-space:nowrap'>
							Нажмите клавишу ПРОБЕЛ, чтобы сделать подачу.
						</div>						
					</div>
					
					<div class=teaching_block id=teaching_fail_border style='top:10px;;-width:200px;text-align:center;white-space:nowrap;color:#8f2929;margin-left:12px'>
						<svg height="11" width="20" style='margin-bottom:-11px;right:50%;position:absolute;bottom:0;'>
							<polygon points="0,1 8,11 16,1" style="fill:#fff;stroke:#aaa;stroke-width:1" />
							<polygon points="0,0 8,10 16,0" style="fill:#fff;stroke:#fff;stroke-width:1" />
							Sorry, your browser does not support inline SVG.
						</svg>
					
						<!-- <b>Обучение <span>(шаг 1 из 3)</span></b> -->
						<div>
							Отбивать мяч в свою половину ограждения нельзя!
						</div>						
						<a onclick='teaching.failBorderClose()'><b>я понял</b></a>
					</div>
					
					<div class=teaching_block id=teaching_fail_out style='top:10px;;-width:200px;text-align:center;white-space:nowrap;color:#8f2929;margin-left:12px'>
						<svg height="11" width="20" style='margin-bottom:-11px;right:50%;position:absolute;bottom:0;'>
							<polygon points="0,1 8,11 16,1" style="fill:#fff;stroke:#aaa;stroke-width:1" />
							<polygon points="0,0 8,10 16,0" style="fill:#fff;stroke:#fff;stroke-width:1" />
							Sorry, your browser does not support inline SVG.
						</svg>
					
						<!-- <b>Обучение <span>(шаг 1 из 3)</span></b> -->
						<div>
							Отбивать мяч в аут без удара об ограждение нельзя!
						</div>	
						<a onclick='teaching.failOutClose()'><b>я понял</b></a>						
					</div>
					
					<div id=wait_>						
						<div id=wait_success>Вы выиграли очко.</div>
						<div id=wait_fail>Вы проиграли очко.</div>
						<div id=wait_ready>Нажмите пробел, чтобы начать</div>
						<div id=wait_advice></div>												
					</div>
				</div>
				<div id=help>						 
					<b>Управление</b>: клавиши W, S, A, D - движение, <span style='font-size:21px;line-height:10px'>&#x21e6;</span> и <span style='font-size:21px;line-height:10px'>&#x21e8;</span> - поворот.<br>
					<div style='margin-top:1px'></div><b>Задача</b>: отбить мяч в <span id=help_blue>синие</span> ограждения (навылет или в серые ограждения нельзя!).
					<a id=help_close>скрыть подсказку</a>
				</div>
				<div id=help_open>
					показать подсказку
				</div>
				<div id=game_local_head>						
					Теннис 2D. Обучение.		
				</div>					
				<div id=game_network_head>						
					<div class=_caption>Матч против компьютера </div>
					<div id=score>Счёт (сеты/геймы/подачи): 0:0 / 0:0 / 0:0*</div>				
				</div>
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
					<div id=border_cort_blue_bottom>
					</div>											
					<div id=border_cort_blue_top>
					</div>											
					<div id=border_start>
					</div>										
				</div>
			</div>
		</div>				
		<templates>
			<div class=chat_message>
				<span class=_name></span>: <span class=_text></span>
			</div>				
		</templates>
		<script src='js/main.php?35<?php //echo rand(0, 1000000); ?>'></script>	
		<!-- Yandex.Metrika counter -->
		<script type="text/javascript" >
		   (function(m,e,t,r,i,k,a){m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
		   m[i].l=1*new Date();k=e.createElement(t),a=e.getElementsByTagName(t)[0],k.async=1,k.src=r,a.parentNode.insertBefore(k,a)})
		   (window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");

		   ym(64682380, "init", {
				clickmap:true,
				trackLinks:true,
				accurateTrackBounce:true,
				webvisor:true
		   });
		</script>
		<noscript><div><img src="https://mc.yandex.ru/watch/64682380" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
		<!-- /Yandex.Metrika counter -->
		<!-- Global site tag (gtag.js) - Google Analytics -->
		<script async src="https://www.googletagmanager.com/gtag/js?id=UA-168648886-1"></script>
		<script>
		  window.dataLayer = window.dataLayer || [];
		  function gtag(){dataLayer.push(arguments);}
		  gtag('js', new Date());
		  gtag('config', 'UA-168648886-1');
		</script>		
	</body>
</html>