Game.Rally.BorderLines.BorderLines=function()
{
	
	var Scale=Game.Rally.Scale.Scale;
	
	var w=1.3, h=1.4, lines=0, view=0;
	
	var res=
	{					
		get w(){return w;}, set w(a){w=a;},
		get h(){return h;}, set h(a){h=a;},
		get lines(){return lines;}, set lines(a){lines=a;},
		get view(){return view;}, set view(a){view=a;},
	
		BorderLines: function() 
		{
			lines = new Array(
				new Array(Scale.convertX(-w), Scale.convertY(-h), Scale.convertX(w), Scale.convertY(-h))
				,new Array(Scale.convertX(-w), Scale.convertY(-h), Scale.convertX(-w), Scale.convertY(h))
				,new Array(Scale.convertX(w), Scale.convertY(h), Scale.convertX(-w), Scale.convertY(h))
				,new Array(Scale.convertX(w), Scale.convertY(h), Scale.convertX(w), Scale.convertY(-h))
			);
						
			//view
			//view = new View();			
			//viewPaint();
		},
		
		//view
		viewPaint: function()
		{			
			/*view.graphics.lineStyle(1, 0xaa4444);
			for (var i:int = 0; i < lines.length; i++)
			{
				var line:Array = lines[i];
				view.graphics.moveTo(line[0], line[1]); 
				view.graphics.lineTo(line[2], line[3]);
			}*/
		}
		
	}
	
	res.BorderLines();
	
	return res;

}