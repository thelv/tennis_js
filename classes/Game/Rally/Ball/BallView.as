Game.Rally.Ball.BallView=function()
{
	var e=document.createElement('div');
	e.innerHTML='<div></div>';
	e.setAttribute('id', 'ball');
	document.querySelector('#field').append(e);

	return {
		showPosition: function(x, y, a)
		{
			//e.style.left=x+'px';
			//e.style.top=-y+'px';
			//e.style.transform='rotate('+(-a)+'rad)';
		},
		addChild: function()
		{
		},
		
		remove: function()
		{
			e.remove();
		}
	}

}