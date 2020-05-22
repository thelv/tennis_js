View=function()
{		

	var e=document.createElement('div');
	e.innerHTML='view';
	e.setAttribute('class', 'view');
	document.querySelector('#center').append(e);

	return {
		showPosition: function(x, y, a)
		{
			e.style.left=x+'px';
			e.style.top=-y+'px';
		},
		addChild: function()
		{
		}
	}
}