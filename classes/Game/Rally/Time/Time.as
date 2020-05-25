Game.Rally.Time.Time=function()
{

	var shiftTime=0, shiftTimes=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0], i=0, l=0;
	
	var echo=function()
	{
		var time=new Date().getTime();
		var xhr=new XMLHttpRequest();
		xhr.open('GET', 'sync.php', true);
		xhr.send();	
		xhr.onreadystatechange = function() 
		{				
			if(xhr.readyState!=4 && xhr.status!=200) return;   
			shiftTimes[i]=(new Date().getTime()+time)/2-xhr.responseText;
			if(l!=10) l++;
		}		
	});
 
	
	var j=5;
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
	setInterval(echo, 3000);
		 
	var res=
	{		
		get: function()
		{			
			return new Date().getTime()-shiftTime;
		},
		
		sync: function(startTime)
		{
			var shiftTime_=0;
			for (var j=0; j<l; j++)
			{
				shiftTime_+=shiftTimes[i];
			}
			shiftTime=shiftTime_/10+startTime;
		}
	}
	
	return res;
}