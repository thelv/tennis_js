class MathLib
{		
	static vAngle(v)
	{
		var x=v[0]; 
		var y=v[1];
		return x==0 ? (y>0 ? Math.PI/2 : -Math.PI/2) : (x>0 ? Math.atan(y/x) : Math.atan(y/x)+Math.PI);
	}
	
	static getAngleByCoords(x, y)
	{
		return x==0 ? (y>0 ? Math.PI/2 : -Math.PI/2) : (x>0 ? Math.atan(y/x) : Math.atan(y/x)+Math.PI);
	}
	
	static getLengthByCoords(x, y)
	{
		return Math.sqrt(x*x + y*y);
	}
	
	static linesIntersection(x00, y00, x01, y01, x10, y10, x11, y11)
	{
		if((x00==x01 && y00==y01)||(x10==x11 && y10==y11)) 
		{
			return {intersect: false, linesIntersect: false};
		}
		
		if(x00==x01 && x10==x11)
		{
			return {intersect: false, linesIntersect: false};
		}	
		
		if(x00==x01 || (x10==x11 && y00!=y01))
		{
			var reverse=true;		
			var m=x00;x00=y00;y00=m;
			m=x01;x01=y01;y01=m;
			m=x10;x10=y10;y10=m;
			m=x11;x11=y11;y11=m;
		}
		else
		{
			var reverse=false;
		}
		
		if(x10==x11 && y00==y01)
		{
			x=x10;
			y=y00;

			var p0=(x-x00)/(x01-x00);
			var p1=(y-y10)/(y11-y10);
		}
		else
		{			
			var k0=(y01-y00)/(x01-x00);
			var k1=(y11-y10)/(x11-x10);
			if(k0==k1)
			{
				return {intersect: false, linesIntersect: false};
			}
			var x=(k0*x00-k1*x10-y00+y10)/(k0-k1);
			var y=y00+k0*(x-x00);

			var p0=(x-x00)/(x01-x00);
			var p1=(x-x10)/(x11-x10);
		}
		
		if (p1>=0 && p1<=1)
		{
			if(p0>0 && p0<=1)
			{
				if(reverse)
				{
					m=x;x=y;y=m;			
				}			
				return {intersect: true, linesIntersect: true, x: x, y:y, k: p0}
			}
			else
			{
				return {intersect: false, linesIntersect: true, k: p0};
			}
		}
		else
		{		
			return {intersect: false, linesIntersect: false};
		}
	}
	
	static intersectionWithMovingLine(x00, y00, x01, y01, x10, y10, x11, y11, x20, y20, x21, y21)
	{
		var intersection1=linesIntersection(x00, y00, x01, y01, x10, y10, x11, y11);
		var intersection2=linesIntersection(x00, y00, x01, y01, x20, y20, x21, y21);
		if(intersection1.intersect)
		{			
			return intersection1;
		}
		
		if(intersection2.intersect)
		{		
			return intersection2;
		}

		if(intersection1.linesIntersect && intersection2.linesIntersect)
		{		
			var k1=intersection1.k;
			var k2=intersection2.k;				
			if(k1>k2)
			{
				var m=k1;k1=k2;k2=m;
			}
			if((k2>0 && k2<=1) || (k1<=1 && k2>1))
			{
				var k=(Math.max(k1, 0)+Math.min(k2, 1))/2;
				var x=x00+(x01-x00)*k;
				var y=y00+(y01-y00)*k;			
				return {intersect: true, k: k, x: x, y: y};
			}
			else
			{
				return {intersect: false};
			}
		}
		else
		{
			return {intersect: false};
		}
	}
	
	static getLineDirection(x0, y0, x1, y1)
	{
		var x = x1 - x0;
		var y = y1 - y0;			
		var l = MathLib.getLengthByCoords(x, y);			
		if (l != 0)
		{
			x = x / l;
			y = y / l;
		}
		return [x, y];
	}
	
	static decomposeVector(vx, vy, x, y)
	{
		var vt = vx * x + vy * y;
		var vn = - vx * y + vy * x;
		return [vt, vn];
	}
	
	static composeVector(vt, vn, x, y)
	{
		var vx = vt * x - vn * y;
		var vy = vt * y + vn * x;
		return [vx, vy];
	}
	
	static bounceOfRotatingBall(vt, vn, w, r, k, y)
	{
		w = -w;
		var sgn = (vt < w*r) ? 1 : -1;
		var dv=((w*r-vt)*sgn / (k*(y+1)) > 2*vn) ? 2*vn*k*sgn : (w*r-vt)/(y+1);
		var dw = - (-dv*y/r);
		return [dv, dw];
	}
	
	
	/* "v" library - vector operations */
	static vPlus(a, b)
	{
		return [a[0] + b[0], a[1] + b[1]];
	}
	
	static vMinus(a, b)
	{
		return [a[0] - b[0], a[1] - b[1]];
	}
	
	static vTurn(v, dir)
	{
		return [v[0] * dir[0] - v[1] * dir[1], v[1] * dir[0] + v[0] * dir[1]];
	}
	
	static vReturn(v, dir)
	{
		return [v[0] * dir[0] + v[1] * dir[1], v[1] * dir[0] - v[0] * dir[1]];
	}
	
	static vLength(v)
	{
		return Math.sqrt(v[0] * v[0] + v[1] * v[1]);
	}

	static vLengthSqr(v)
	{
		return v[0] * v[0] + v[1] * v[1];
	}
	
	static vNormalize(v)
	{
		if (v[0] == 0 && v[1] == 0)
		{
			return [0, 0];
		}
		else
		{
			var l = MathLib.vLength(v);
			return [v[0] / l, v[1] / l];			
		}
	}
	
	static vProduct(v, a)
	{
		return [a * v[0], a * v[1]];
	}
	
	static vVectorProduct(a, b)
	{
		return -a[0] * b[1] + a[1] * b[0];
	}			
}