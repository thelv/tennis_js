Game.Rally.Time.Time=function()
{

	shiftTime=0, startTime=0, shiftTimes=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0], i=0, l=0;
	
	var echo=function()
	{
		var time=new Date().getTime();
		var xhr=new XMLHttpRequest();
		xhr.open('GET', 'service/sync.php', true);
		xhr.send();	
		xhr.onreadystatechange = function() 
		{									
			if(xhr.readyState!=4 || xhr.status!=200) return;   
			shiftTimes[i]=(new Date().getTime()+time)/2-xhr.responseText;
			if(l!=10) l++;
			if(i!=9) i++; else i=0;
		}		
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
	}
	m();
	setInterval(echo, 10000);
		 
	var res=
	{		
		get: function()
		{			
			return new Date().getTime()-shiftTime-startTime;
		},
		
		reset: function(startTime_)
		{
			startTime=startTime_;
		},
		
		sync: function()
		{
			var shiftTime_=0;
			for (var j=0; j<l; j++)
			{
				shiftTime_+=shiftTimes[i];
			}
			shiftTime=shiftTime_/10;
		}
	}
	
	return res;
}