
	function segmentPlaneIntersection(r, dr, R, n)
	{
		var k=(V.p(n, R)-V.p(r, n))/V.p(dr, n);
		if(k<=1 && k>0.1) k-=0.000000001;
		var r0=V.s(r, V.ps(k, dr));
		return [k, r0];
	}

	function segmentMovingPlaneIntersection(r, dr, R0, n0, R1, n1)
	{
		/*var r0=
		var k=(V.p(n, R)-V.p(r, n))/V.p(dr, n);
		if(k<=1 && k>0.1) k-=0.000000001;
		var r0=V.s(r, V.ps(k, dr));
		return [k, r0];*/
	}	
	
	function hit(v, w, r, m, I, u, n, kf, kr)
	{
		var v_n=V.ps(V.p(v, n), n);
		var v_t=V.d(v, v_n);
		
		var u_n=V.ps(V.p(u, n), n);
		var u_t=V.d(u, u_n);
		
		var v_n_=V.d(V.ps(1+kr, u_n), v_n);
		
		var DP=kf*m*V.abs(V.d(v_n_, v_n));
		
		var res=hit_(v_t, w, r, m, I, u_t, n, DP, DP/100);
		
		var v_t_=res.v;
		var w_=res.w;
		
		var v_=V.s(v_n_, v_t_);
		
		return {v: v_, w: w_};
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
