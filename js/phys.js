
	function segmentPlaneIntersection(r, dr, R, n)
	{
		var k=(V.p(n, R)-V.p(r, n))/V.p(dr, n);
		if(k<=1 && k>0.1) k-=0.000000001;
		return [k, V.s(r, V.ps(k, dr))];
	}

	function segmentPlayerIntersection(r0, r1, R0, n0, R1, n1, size)
	{	
		var dr=V.d(r1, r0);	
	
		var r0_=V.d(r0, R0);
		var r1_=V.d(r1, R1);
		[r0_[0], r0_[1]]=vTurn2d(r0_, n0);
		[r1_[0], r1_[1]]=vTurn2d(r1_, n1);			
		
		var dr_=V.d(r1_, r0_);
		var k=-r0_[1]/dr_[1];
		
		if(k<=1 && k>0)
		{
			if(k>0.1) k-=0.000000001;
			var r=V.s(r0, V.ps(k, dr));
			var r_=V.s(r0_, V.ps(k, dr_));			
			var R=V.s(R0, V.ps(k, V.d(R1, R0)));
			if(Math.abs(r_[0])<size[0] && Math.abs(r_[1])<size[1]) 
			{
				return [k, r, R];
			}
		}
		
		return [false];
	}	
	
	function vTurn2d(v, n)
	{
		return [-v[0]*n[1]+v[1]*n[0], -v[0]*n[0]-v[1]*n[1]];
	}
	
	function hit(v, w, r, m, I, u, n, kr, km, ke)
	{
		if(V.p(v, n)>0) n=V.o(n);
		
		var v_n=V.ps(V.p(v, n), n);
		var v_t=V.d(v, v_n);
		
		var u_n=V.ps(V.p(u, n), n);
		var u_t=V.d(u, u_n);
		
		//var v_n_=V.d(V.ps(1+kr, u_n), v_n);
		var vc_n=V.s(V.ps(km, v_n), V.ps(1-km, u_n));
		var v_n_c=V.d(v_n, vc_n);
		var v_n_c_=V.ps(ke, V.o(v_n_c));
		var v_n_=V.s(v_n_c_, vc_n);
		
		var DP=kr*m*V.abs(V.d(v_n_, v_n));
		
		var res=hit_(v_t, w, r, m, I, u_t, n, DP, DP/100);
		
		var v_t_=res.v;
		var w_=res.w;
		
		var v_=V.s(v_n_, v_t_);
		
		return [v_, w_];
	}
	
	function hit_(v, w, r, m, I, u, n, DP, dP)
	{
		while(DP>0)
		{
			var F_norm=V.norm(
				V.s
				(
					V.d(u, v), 
					V.pv(
						V.ps(-r, n),
						w
					)
				)
			);
			var dv=V.ps(dP/m, F_norm);
			var dw=V.ps(dP/I, V.pv(V.ps(r, F_norm), n));
			v=V.s(v, dv);
			w=V.s(w, dw);
			DP-=dP;
		}
		return {v: v, w: w};
	}
