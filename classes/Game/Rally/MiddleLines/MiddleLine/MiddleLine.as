Game.Rally.MiddleLines.MiddleLine.MiddleLine=function(side)
{
	var Scale=Game.Rally.Scale.Scale;
	
	var sideSign=0, t0=0, pos=0, posV=0, posStart=0, posVInc=0.025/80, posVDec=0.05/80, posX=0, posXV=0, posXV0=80, posW=0, posWV=0, posWV0=2, curve=[[30, 0], [30, 60], [0, 250]], curveYMax=100, curveXMax=30, state='dec', view=0;
	
	var res=
	{		
		
		get sideSign(){return sideSign;}, set sideSign(a){sideSign=a;},
		get t0(){return t0;}, set t0(a){t0=a;},
		get pos(){return pos;}, set pos(a){pos=a;},
		get posV(){return posV;}, set posV(a){posV=a;},
		get posStart(){return posStart;}, set posStart(a){posStart=a;},
		get posVInc(){return posVInc;}, set posVInc(a){posVInc=a;},
		get posVDec(){return posVDec;}, set posVDec(a){posVDec=a;},
		get posX(){return posX;}, set posX(a){posX=a;},
		get posXV(){return posXV;}, set posXV(a){posXV=a;},
		get posXV0(){return posXV0;}, set posXV0(a){posXV0=a;},
		get posW(){return posW;}, set posW(a){posW=a;},
		get posWV(){return posWV;}, set posWV(a){posWV=a;},
		get posWV0(){return posWV0;}, set posWV0(a){posWV0=a;},
		get curve(){return curve;}, set curve(a){curve=a;},
		get curveYMax(){return curveYMax;}, set curveYMax(a){curveYMax=a;},
		get curveXMax(){return curveXMax;}, set curveXMax(a){curveXMax=a;},
		get state(){return state;}, set state(a){state=a;},
		get view(){return view;}, set view(a){view=a;},
		
		MiddleLine: function(side)
		{
			this.side = side;
			sideSign = side? 1: -1;
			state = 'dec';
			pos = 0;
			posV = 0;
			posStart = 0;
			//view
			view = Game.Rally.MiddleLines.MiddleLine.MiddleLineView(curve, curveXMax, side);
		},
		
		hit: function(player, x, t)
		{
			state = ((player == 1) == side) ? 'inc' : 'dec';
			t0 = t;
			posStart = pos;
		},
		
		shiftTime: function(t)
		{
			switch(state)
			{
				case 'inc':
					var posPossible = (t - t0) * posVInc;
					if(posPossible < pos)
					{
						posV = 0;
					}
					else if(posPossible < 1)
					{
						pos = posPossible;
						posV = posVInc;
					}
					else
					{
						pos = 1;
						posV = 0;
					}
					break;
				case 'dec':
					pos = Math.max(0, posStart - (t - t0) * posVDec);
					posV = 0;
					break;
			}
			
			posX = Math.min(pos,0.7)*posXV0;
			posXV = (pos < 1) ? posXV0 : 0;
			//posW = Math.max(0, pos-0.3)/0.7;
			posW = Math.max(0, pos-0.3)/(1 - 0.3);
			if (pos > 0.7) posW+=(pos-0.7)*posXV0/curveXMax;
			posWV = 1;
			if (pos > 0.7) posWV+=posXV0/curveXMax;
			
			//view
			view.setPos(-sideSign*posX, -sideSign*posW);
		},
		
		xAndVByY: function(y)
		{
			y = Math.min(Math.abs(y), curveYMax);
			for (var i = 1; i < curve.length; i++)
			{
				if (y <= curve[i][1])
				{
					var curveX=
						curve[i-1][0]
						+
						(curve[i][0]-curve[i-1][0])
						*
						(
							(y-curve[i-1][1]) 
							/
							(curve[i][1]-curve[i-1][1])
						)
					;
					
					return  {
						x: posX + curveX * posW,
						v: posV * (posXV + curveX*posWV)
					};
				}
			}
			
			return { x:0, v:0 };
		},
		
		init: function()
		{
			state = 'dec';
			t0 = 0;
			pos = 0;
			posX = 0;
			posV = 0;
		}
	}
	
	res.MiddleLine(side);
	
	return res;
}