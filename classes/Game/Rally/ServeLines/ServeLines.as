Game.Rally.ServeLines.ServeLines=function()
{
	
	var Scale=Game.Rally.Scale.Scale;
	
	var h=1, lines=0, view=0, centralLine=0, w=359;
			
	var res=
	{		
		get h(){return h;}, set h(a){h=a;},
		get lines(){return lines;}, set lines(a){lines=a;},
		get view(){return view;}, set view(a){view=a;},
		get centralLine(){return centralLine;}, set centralLine(a){centralLine=a;},
		get w(){return w;}, set w(a){w=a;},
	
		ServeLines: function()
		{
			this.w = w;
			
			lines = 
			[
				[
					-w, Scale.convertY(-h)+1,
					-w, Scale.convertY(h)-1
				],
				[
					w, Scale.convertY(-h)+1, 
					w, Scale.convertY(h)-1
				]
			]					
			
			//view
			//view = new Sprite();			
			this.viewPaint();
		},
		
		//view
		viewPaint: function()
		{			
			/*view.graphics.lineStyle(1, 0x80bb80);
			for (var i:int = 0; i < lines.length; i++)
			{				
				var line:Array = lines[i];				
				view.graphics.moveTo(line[0], line[1]); 
				view.graphics.lineTo(line[2], line[3]);							
			}*/			
		}
	}
	
	res.ServeLines();
	
	return res;

}