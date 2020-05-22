Game.Rally.FieldLines.FieldLines=function()
{
		
	var Scale=Game.Rally.Scale.Scale;
	
	var w=1, h=1, lines=0, view=0, centralLine=0;
	
	var res=
	{						
		get w(){return w;}, set w(a){w=a;},
		get h(){return h;}, set h(a){h=a;},
		get lines(){return lines;}, set lines(a){lines=a;},
		get view(){return view;}, set view(a){view=a;},
		get centralLine(){return centralLine;}, set centralLine(a){centralLine=a;},
	
		FieldLines: function() 
		{
			lines = new Array(			
				new Array(Scale.convertX(0), Scale.convertY(h), Scale.convertX(w), Scale.convertY(h))
				,new Array(Scale.convertX(0), Scale.convertY( -h), Scale.convertX(w), Scale.convertY( -h))				
				,new Array( Scale.convertX(-w), Scale.convertY(h), Scale.convertX(0), Scale.convertY(h))				
				,new Array( Scale.convertX( -w), Scale.convertY( -h), Scale.convertX(0), Scale.convertY( -h))
			);
			
			centralLine=new Array(Scale.convertX(0), Scale.convertY(-h), Scale.convertX(0), Scale.convertY(h))
			
			//view
			//view = new Sprite();			
			//viewPaint();
		},
		
		//view
		viewPaint: function()
		{								
			/*//var color = 0x69a369;
			//var color = 0x70a370;
			//var color = 0x669966;
			var color = 0x77aa77;
			//view.graphics.lineStyle(2, 0x77aa77);
			//view.graphics.lineStyle(2, 0x669966);
			//view.graphics.lineStyle(2, 0x71a571);		
			view.graphics.lineStyle(2, color);
			view.graphics.moveTo(centralLine[0], centralLine[1]+1); 
			view.graphics.lineTo(centralLine[2], centralLine[3] - 1);
			
			view.graphics.beginFill(color);
			view.graphics.drawCircle(0, 0, 4);
			view.graphics.endFill();
			
			view.graphics.lineStyle(2, 0x555555);
			for (var i:int = 0; i < lines.length; i++)
			{				
				var line:Array = lines[i];				
				view.graphics.moveTo(line[0], line[1]); 
				view.graphics.lineTo(line[2], line[3]);							
			}*/
		}
	}
	
	res.FieldLines();
	
	return res;

}