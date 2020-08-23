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