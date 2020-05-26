MainView=function()
{
	var nameNode=document.querySelector('#name');
	var usersFreeNode=document.querySelector('#users_free_list');
	var usersNotFreeNode=document.querySelector('#users_not_free_list');

	document.querySelector('#name_change').addEventListener('click', function()
	{
		Main.nameChange();
	});

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
				var e=document.createElement('div');
				e.setAttribute('class', 'user');
				e.innerText=free[i].name;
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
				var e=document.createElement('div');
				e.setAttribute('class', 'user');
				e.innerText=notFree[i].name;
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

		invites: function()
		{
		}
	}
	
	return res;
}