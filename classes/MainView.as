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
				usersFreeNode.append(e);
			}
			if(free.length==0)
			{
				usersFreeNode.innerText='Никого нет.';
			}
			
			var notFree=users.not_free;
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
				usersNotFreeNode.append(e);
			}
			if(notFree.length==0)
			{
				usersNotFreeNode.innerText='Никого нет.';
			}
		},

		invites: function(invites)
		{
			var who=invites.invites_who;
			usersInvitesWhoNode.innerHTML='';
			for(var i in who)
			{
				var user=who[i]; 
				var e=userNodeCreate(user, 'Отменить Приглашение');
				(function(id)
				{
					e.addEventListener('click', function()
					{
						Main.uninvite(id);
					});
				})(user.id);
				usersInvitesWhoNode.append(e);
			}
			if(who.length==0)
			{
				usersInvitesWhoNode.innerText='Пригласите свободного игрока поиграть.';
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
				usersInvitesFromNode.append(e);
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
		}
	}
	
	return res;
}