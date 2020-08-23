aaaaa=0;
Game.Rally.Ball.BallEval.BallEval=function(ball)
{
	var Ball=Game.Rally.Ball.Ball;
	
	var r=0, v=0, w=0, a=0, t=0;
	var DT=3, K_DRUG=0.01, K_COR=0, K_DRUG_A=0, m=0.0585, R=0.0667, I=m*R*R*0.92;
	
	var res=
	{							
		BallEval: function(ball)
		{
			this.ball = ball;
		},
		
		init: function(t0)
		{
			t=t0;
			r=ball.r;
			v=ball.v;
			a=ball.a;
			w=ball.w;
		},
		
		eval: function(tGoal)
		{			
			if(tGoal<=t) return;			
			
			do
			{				
				var t_=Math.min(tGoal, t+DT);
				var dt=t_-t;
				var dts=dt/1000;
							

				var vAbs=V.abs(v);
				var F=V.s
				(
					V.ps
					(
						-K_DRUG*vAbs,
						v
					),
					V.ps(
						K_COR,
						V.pv(w, v)
					)
				);	
				F[2]-=9.81*m;

				var	M=V.ps(-K_DRUG_A*V.abs(w), w);
				
				
				var v_=V.s(v, V.ps(dts/m, F));
				var dirChange=V.p(v_, v);
				if(dirChange<0) v_=V.s(v_, V.ps(-dirChange/vAbs/vAbs, v));
				var r_=V.s(r, V.ps(dts/2, V.s(v, v_)));
				var w_=V.s(w, V.ps(dts/I, M));
				var a_=V.s(a, V.ps(dts/2, V.s(w, w_)));
								
				if(t_==tGoal)
				{
					ball.r=r_;
					ball.v=v_;
					ball.a=a_;
					ball.w=w_;									
					return;
				}
				else
				{
					r=r_;
					v=v_;						
					a=a_;
					w=w_;						
					t=t_;
				}
			}
			while(true);
		}
	}
	
	res.BallEval(ball);
	
	return res;	
}