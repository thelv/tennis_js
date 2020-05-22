Game.Rally.Player.PlayerView=function()
{
	var e=document.createElement('div');
	e.innerHTML='<div></div>';
	e.setAttribute('class', 'player');
	document.querySelector('#center').append(e);

	return {
		showPosition: function(x, y, a)
		{
			e.style.left=x+'px';
			e.style.top=-y+'px';
			e.style.transform='rotate('+(-a)+'rad)';
		},
		addChild: function()
		{
		}
	}

}