Game.Rally.MiddleLines.MiddleLines=function()
{
	
	var Scale=Game.Rally.Scale.Scale;
	var MiddleLine=Game.Rally.MiddleLines.MiddleLine.MiddleLine;
	
	var lines=0, view=0;
	
	var res=
	{					
		get lines(){return lines;}, set lines(a){lines=a;},
		get view(){return view;}, set view(a){view=a;},
	
		MiddleLines: function()
		{
			lines = 
			[
				MiddleLine(true),
				MiddleLine(false)
			];
			
			//view
			//view = new Sprite();
			//view.addChild(lines[0].view);
			//view.addChild(lines[1].view);				
		},
		
		
		
		hit: function(player, x, t)
		{
			lines[0].hit(player, x, t);
			lines[1].hit(player, x, t);
		},
		
		init: function()
		{
			lines[0].init();
			lines[1].init();
		}
		
	}
	
	res.MiddleLines();
	
	return res;

}