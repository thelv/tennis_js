	V={
		s: function(a, b)
		{
			return [a[0]+b[0], a[1]+b[1], a[2]+b[2]];
		},	

		d: function(a, b)
		{
			return [a[0]-b[0], a[1]-b[1], a[2]-b[2]];
		},
		
		p: function(a, b)
		{
			return a[0]*b[0]+a[1]*b[1]+a[2]*b[2];
		},
		
		ps: function(k, a)
		{
			return [k*a[0], k*a[1], k*a[2]];
		},
		
		psv: function(a, b)
		{
			return a[0]*b[0]+a[1]*b[1]+a[2]*b[2];
		},
		
		pv: function(a, b)
		{
			return [a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]];
		},
		
		pm: function(m, v)
		{
			return [m[0][0]*v[0]+m[0][1]*v[1]+m[0][2]*v[2], m[1][0]*v[0]+m[1][1]*v[1]+m[1][2]*v[2], m[2][0]*v[0]+m[2][1]*v[1]+m[2][2]*v[2]];
			//return [m[0][0]*v[0]+m[1][0]*v[1]+m[2][0]*v[2], m[0][1]*v[0]+m[1][1]*v[1]+m[2][1]*v[2], m[0][2]*v[0]+m[1][2]*v[1]+m[2][2]*v[2]];
		},
		
		o: function(a)
		{
			return [-a[0], -a[1], -a[2]];
		},
		
		abs: function(a)
		{
			return Math.sqrt(a[0]*a[0]+a[1]*a[1]+a[2]*a[2]);
		},
		
		norm: function(a)
		{
			var abs=V.abs(a);
			if(abs==0) return [0, 0, 0];
			return V.ps(1/abs, a);
		}
	}