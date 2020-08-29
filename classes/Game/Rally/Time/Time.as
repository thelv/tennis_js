Game.Rally.Time.Time=function()
{

	var shiftTime=0, startTime=0;	
	
	var syncObj=Sync(function(f)
	{		
		var xhr=new XMLHttpRequest();
		xhr.open('GET', 'https://tennis.thelv.ru:5555/service/sync.php', true);
		xhr.send();	
		xhr.onreadystatechange = function() 
		{									
			if(xhr.readyState!=4 || xhr.status!=200) return;   
			f(xhr.responseText);			
		}
	}, false);	
		 
	var res=
	{		
		get startTime(){return startTime;},
		
		aa: 1, 
		get latency(){return sync.latency;},
	
		get: function()
		{			
			return new Date().getTime()-shiftTime-startTime;
		},
		
		shift: function(t)
		{
			return t-shiftTime-startTime;
		},
		
		getAbs: function()
		{
			return this.get()+startTime;
		},
		
		reset: function(startTime_)
		{
			startTime=startTime_;
		},
		
		sync: function()
		{
			shiftTime=syncObj.sync();
		}
	}
	
	return res;
}

var Sync=function(f, syncAutoCall)
{
	var shiftTime=0, shiftTimes=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0], i=0, l=0, latency=false, latencys=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	
	var echo=function()
	{		
		f(function(tPair)
		{	
			var time_=new Date().getTime()
			shiftTimes[i]=(time_+time)/2-tPair;
			latencys[i]=(time_-time)/2;
			if(l!=10) l++;
			if(i!=9) i++; else i=0;
			if(syncAutoCall) sync();
		});
		var time=new Date().getTime();
	};
	
	var latencyCalc=function()
	{
		var latency_=0;
		for (var j=0; j<l; j++)
		{
			latency_+=latencys[j];
		}
		latency=latency_/l;
	};
	
	var sync=function()
	{
		var shiftTime_=0;
		for (var j=0; j<l; j++)
		{
			shiftTime_+=shiftTimes[i];
		}
		shiftTime=shiftTime_/10;
		latencyCalc();
		return shiftTime;
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
			latencyCalc();
		}
	}
	//setTimeout(m, 3000);
	m();
	setInterval(echo, 10000);
	
	return {
		get shiftTime(){return shiftTime;},
		sync: sync
	}
}