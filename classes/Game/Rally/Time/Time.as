Game.Rally.Time.Time=function()
{

	shiftTime=0, startTime=0, shiftTimes=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0], i=0, l=0, latency=false, latencys=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	
	var echo=function()
	{		
		var xhr=new XMLHttpRequest();
		xhr.open('GET', 'http://tennis.thelv.ru/service/sync.php', true);
		xhr.send();	
		xhr.onreadystatechange = function() 
		{									
			if(xhr.readyState!=4 || xhr.status!=200) return;   
			var time_=new Date().getTime()
			shiftTimes[i]=(time_+time)/2-xhr.responseText;
			latencys[i]=(time_-time)/2;			
			if(l!=10) l++;
			if(i!=9) i++; else i=0;
		}		
		var time=new Date().getTime();
	};
 
	
	var j=11;
	var m=function()
	{
		j--;
		if(j) 
		{
			echo();
			setTimeout(m, 200);
		}
		else
		{
			res.latencyCalc();
		}
	}
	//setTimeout(m, 3000);
	m();
	setInterval(echo, 10000);
		 
	var res=
	{		
		aa: 1, 
		get latency(){return latency;},
	
		get: function()
		{			
			return new Date().getTime()-shiftTime-startTime;
		},
		
		getAbs: function()
		{
			return this.get()+startTime;
		},
		
		reset: function(startTime_)
		{
			startTime=startTime_;
		},
		
		latencyCalc: function()
		{
			var latency_=0;
			for (var j=0; j<l; j++)
			{
				latency_+=latencys[j];
			}
			latency=latency_/l;
		},
		
		sync: function()
		{
			var shiftTime_=0;
			for (var j=0; j<l; j++)
			{
				shiftTime_+=shiftTimes[i];
			}
			shiftTime=shiftTime_/10;
			this.latencyCalc();
		}
	}
	
	return res;
}