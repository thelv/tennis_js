Game.Rally.MiddleLines.MiddleLine.MiddleLineView=function(curve, curveXMax, side)
{

	var prevPosW=0;

	/*var e=document.createElement('div');
	e.innerHTML='<div></div><div></div><div></div>';
	e.setAttribute('id', 'ball');
	document.querySelector('#center').append(e);*/

	var res=
	{				
		get curve(){return curve;}, set curve(a){curve=a;},
		get prevPosW(){return prevPosW;}, set prevPosW(a){prevPosW=a;},
		get curveXMax(){return curveXMax;}, set curveXMax(a){curveXMax=a;},
	
		MiddleLineView: function(curve, curveXMax, side)
		{
			this.curve = curve;
			this.curveXMax = curveXMax;
		},
		
		setPos: function(posX, posW)
		{			
			/*graphics.lineStyle(1, 0x8000ee, 0);
			for(var i:Number = 1; i < curve.length; i++)
			{
				graphics.moveTo(curve[i-1][0]*prevPosW, curve[i-1][1]); 
				graphics.lineTo(curve[i][0]*prevPosW, curve[i][1]); 
				
				graphics.moveTo(curve[i-1][0]*prevPosW, -curve[i-1][1]); 
				graphics.lineTo(curve[i][0]*prevPosW, -curve[i][1]); 
			}
			graphics.lineStyle(1, 0x80bb80, 1);*/
			
			
			/*if (Math.round(curveXMax * prevPosW) != Math.round(curveXMax * posW))
			{
				graphics.clear();
				graphics.lineStyle(1, 0x80bb80, 1);
				for(var i:Number = 1; i < curve.length; i++)
				{
					graphics.moveTo(curve[i-1][0]*posW, curve[i-1][1]); 
					graphics.lineTo(curve[i][0]*posW, curve[i][1]); 
					
					graphics.moveTo(curve[i-1][0]*posW, -curve[i-1][1]); 
					graphics.lineTo(curve[i][0]*posW, -curve[i][1]); 
				}	
				prevPosW = posW;
			}*/
			x = posX;
		}
		
	}
	
	res.MiddleLineView(curve, curveXMax, side);
	
	return res;

}