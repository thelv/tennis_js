MainView=function()
{
	var nameNode=document.querySelector('#name');
	var usersFreeNode=document.querySelector('#users_free_list');
	var usersNotFreeNode=document.querySelector('#users_not_free_list');
	var usersInvitesWhoNode=document.querySelector('#users_invites_who_list');
	var usersInvitesFromNode=document.querySelector('#users_invites_from_list');
	var gameLeaveNode=document.querySelector('#game_leave');
	var waitNode=document.querySelector('#wait');
	
	document.querySelector('#game_leave').addEventListener('click', function()
	{
		Main.gameLeave();
	});

	document.querySelector('#name_change').addEventListener('click', function()
	{
		Main.nameChange();
	});
	
	var userNodeCreate=function(user, title)
	{
		var e=document.createElement('div');
		e.setAttribute('class', 'user');
		if(title) e.setAttribute('title', title);
		e.innerHTML='<u>'+user.name+'</u><!-- (24, 120, 43) -->';
		return e;
	}

	var res=
	{
		name: function(name)
		{
			nameNode.innerText=name;
		},
		
		users: function(users)
		{
			var free=users.free;
			usersFreeNode.innerHTML='';
			for(var i in free)
			{
				var user=free[i]; 
				var e=userNodeCreate(user, 'Пригласить в игру');
				(function(id)
				{
					e.addEventListener('click', function()
					{
						Main.invite(id);
					});
				})(user.id);
				if(user.id!=Main.userId) usersFreeNode.appendChild(e);
			}
			if(free.length==0 || free.length==1)
			{
				usersFreeNode.innerText='Никого нет.';
			}
			
			/*var notFree=users.not_free;
			usersNotFreeNode.innerHTML='';
			for(var i in notFree)
			{
				var user=notFree[i]; 
				var e=userNodeCreate(user, 'Пригласить в игру');
				(function(id)
				{
					e.addEventListener('click', function()
					{
						Main.invite(id);
					});
				})(user.id);
				usersNotFreeNode.appendChild(e);
			}
			if(notFree.length==0)
			{
				usersNotFreeNode.innerText='Никого нет.';
			}*/
			var games=users.games;		
			usersNotFreeNode.innerHTML='';			
			for(var i in games)
			{
				var game=games[i];
				var user0=game.players[1];
				var user1=game.players[0];
				var gameNode=document.createElement('div');
				gameNode.setAttribute('class', '_game');
				var e1=userNodeCreate(user0);
				(function(id)
				{
					e1.addEventListener('click', function()
					{
						///Main.invite(id);
					});
				})(user0.id);				
				var e2=userNodeCreate(user1);
				(function(id)
				{
					e2.addEventListener('click', function()
					{
						//Main.invite(id);
					});
				})(user1.id);
				gameNode.appendChild(e1);
				var vs=document.createElement('span');
				vs.innerHTML=' с ';
				gameNode.appendChild(vs);
				gameNode.appendChild(e2);			
				usersNotFreeNode.appendChild(gameNode);
				(function(id)
				{
					gameNode.addEventListener('click', function()
					{
						Main.gameView(id);
					});
				})(game.id);
			}
			if(games.length==0)
			{
				usersNotFreeNode.innerText='Нет игр.';
			}
		},

		invites: function(invites)
		{
			var who=invites.invites_who;
			usersInvitesWhoNode.innerHTML='';
			for(var i in who)
			{
				var user=who[i]; 
				var e=userNodeCreate(user, 'Отменить приглашение');
				(function(id)
				{
					e.addEventListener('click', function()
					{
						Main.uninvite(id);
					});
				})(user.id);
				usersInvitesWhoNode.appendChild(e);
			}
			if(who.length==0)
			{
				usersInvitesWhoNode.innerText='Пригласите игрока онлайн поиграть.';
			}
			
			var from=invites.invites_from;
			usersInvitesFromNode.innerHTML='';
			for(var i in from)
			{
				var user=from[i]; 
				var e=userNodeCreate(user, 'Начать игру');
				(function(id)
				{
					e.addEventListener('click', function()
					{
						Main.invite(id);
					});
				})(user.id);
				usersInvitesFromNode.appendChild(e);
			}
			if(from.length==0)
			{
				usersInvitesFromNode.innerText='Вас пока никто не пригласил.';
			}
		},
		
		gameLeaveOpponent: function()
		{
			waitNode.innerHTML='Оппонент покинул игру';
			waitNode.style.display='block';
		},
		
		newWindowOpened: function()
		{
			document.getElementById('new_window_opened').style.display='flex';
		}		
	}
	
	return res;
}