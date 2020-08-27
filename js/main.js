/* this is a partually port from as3 so this is a mess */
Game=
{
	Rally: 
	{
		Ball: 
		{
			BallCollisions: {}, BallEval: {}
		},
		Player: 
		{
			PlayerCollisions: {}, PlayerEvalA: {}, PlayerEvalXY: {}, KeyHandler: {}
		},
		Referee: {},
		Scale: {},
		Time: {},
		Timer: {},
		BorderLines: {},
		FieldLines: {},
		ServeLines: {},
		MiddleLines: {MiddleLine: {}}
	},
	Referee: {},
	Wait: {},		
};
NetworkClient={};

var hitPromise=false;
var hitFrozeView=false;

document.addEventListener('DOMContentLoaded', function()
{				
	window.addEventListener('resize', resize);
	resize();
	

	scene=new THREE.Scene();
	camera=new THREE.PerspectiveCamera(60, window.innerWidth / (window.innerHeight*1.6), 0.1, 200);
	camera.position.y=2.1;//1.92;//2.05;
	cameraOffset=4.8;//4.0;//3.0;//2.7;
	
	//camera.position.y=2.5;//1.92;//2.05;
	//cameraOffset=3.5;//2.7;
	
	//camera.position.y=3.5;//1.92;//2.05;
	//cameraOffset=5;//2.7;	
	//camera.position.z=117;
	
	//camera.position.y=5;//1.92;//2.05;
	//cameraOffset=5;//2.7;	
	//camera.position.z=119;
	
	//camera.position.z=12;
	//camera.lookAt(0, 2, 0);
	renderer=new THREE.WebGLRenderer({alpha: true});
	renderer.setSize(window.innerWidth, window.innerHeight*1.6);
	renderer.setClearColor( new THREE.Color("rgb(136, 231, 136)"), 1);
	document.getElementById('canvas_cont').appendChild(renderer.domElement);	
		
	phoneSocket=new WebSocket('ws://192.168.1.61:41789/');
	phoneSocket.onmessage=function(m)
	{		
		hitReceiveTime=time.get();
	
		//console.log(1);
		m=JSON.parse(m.data);
		
		hitN=m[0];
		hitN[2]=-hitN[2];
		
		var a=Math.atan(hitN[1]/hitN[0]);
		hitNAz=a/2;
		var k=Math.sqrt(1-hitN[2]*hitN[2]);
		hitNx=Math.cos(hitNAz);
		hitNy=Math.sin(hitNAz);
		
		hitN[0]=hitNx*k;
		hitN[1]=hitNy*k;
		
		hitV=m[1];
		hitV=[hitV[0]*hitNx-hitV[1]*hitNy, hitV[0]*hitNy+hitV[1]*hitNx, hitV[2]];				
		
		if(/*m[2] &&*/ hitPromise)
		{
			setTimeout(function()
			{
				if(hitPromise) 
				{
					hitPromise();
					hitPromise=false;
				}
			}, 10);
		}
				
		//hitV[2]=-hitV[2];
		//hitV=[m[1][1], m[1][0], m[1][2]];
	//	var m=quaternionMatrix(m[0], m[1], m[2], m[3]), [0, 1, 0]);
	//	var tilt0=m[2][1];
	//	var tilt1=m[2][2];
		//console.log(v);
	};
		
	new THREE.TextureLoader().load( "img/field.png" , function(texture)
	{
		geometry=new THREE.PlaneGeometry(10.97, 23.77, 1);
		texture.wrapS = THREE.RepeatWrapping;
		texture.wrapT = THREE.RepeatWrapping;
		texture.repeat.set(1, 1);
		material=new THREE.MeshBasicMaterial({transparent: true, opacity: 1, map: texture, shading: THREE.FlatShading, side: THREE.BackSide});
		field=new THREE.Mesh(geometry, material);
		field.position.y=0;
		field.position.x=0;//10.97/2;
		field.position.z=100;//23.77/2;
		field.rotation.x=Math.PI/2;
		
		new THREE.TextureLoader().load( "img/net5.png" , function(texture)
		{
			
			geometry=new THREE.PlaneGeometry(11.97, 1.07, 1);
			texture.wrapS = THREE.RepeatWrapping;
			texture.wrapT = THREE.RepeatWrapping;
			texture.repeat.set(1, 1);
			material=new THREE.MeshBasicMaterial({transparent: true, opacity: 1, map: texture, shading: THREE.FlatShading, side: THREE.FrontSide});
			//material.depthWrite=false;
				
			net=new THREE.Mesh(geometry, material)
			net.position.y=1.07/2;
			net.position.x=0;//10.97/2;
			net.position.z=100;//23.77/2;
			net.rotation.x=0;//Math.PI/2;
			
			new THREE.TextureLoader().load("img/favicon.png", function(texture)
			{			
				geometry=new THREE.SphereGeometry(0.03335*2, 10, 10);
				texture.wrapS = THREE.RepeatWrapping;
				texture.wrapT = THREE.RepeatWrapping;
				texture.repeat.set(1, 1);
				material=new THREE.MeshBasicMaterial({map: texture, shading: THREE.FlatShading, side: THREE.BothSide});
				//material.depthWrite=false;
					
				ball=new THREE.Mesh(geometry, material)
				ball.position.y=2.07;
				ball.position.x=0;//10.97/2;
				ball.position.z=105;//23.77/2;
			
			
				viewBall=ball;
			
				new THREE.TextureLoader().load("img/player.png", function(texture)
				{			
					geometry=new THREE.PlaneGeometry(1.5, 2, 1);
					texture.wrapS = THREE.RepeatWrapping;
					texture.wrapT = THREE.RepeatWrapping;
					texture.repeat.set(1, 1);
					material=new THREE.MeshBasicMaterial({transparent: true, opacity: 0.5, map: texture, shading: THREE.FlatShading, side: THREE.DoubleSide});
					//material.depthWrite=false;
					//var material = new THREE.MeshBasicMaterial({color: 0xff0000, side: THREE.DoubleSide});
						
					
				
				
					//material=new THREE.MeshBasicMaterial({transparent: true, opacity: 1, map: texture, shading: THREE.FlatShading, side: THREE.DoubleSide});
					//material.depthWrite=false;
					//material.depthTest=false;
					player0=new THREE.Mesh(geometry, material)
					player0.position.y=1;
					player0.position.x=0;//10.97/2;
					player0.position.z=105;//23.77/2;
					
					var material = new THREE.MeshBasicMaterial({color: 0xaaaaaa, side: THREE.DoubleSide});
					
					player1=new THREE.Mesh(geometry, material)
					player1.position.y=1;
					player1.position.x=0;//10.97/2;
					player1.position.z=105;//23.77/2;
					
					
					viewPlayer0=player0;
					
					//new THREE.TextureLoader().load("img/player.png", function(texture)
				//{			
						
						
						
						viewPlayer1=player1;
			
						var geometry = new THREE.CircleGeometry( 0.1667, 10 );
						var material = new THREE.MeshBasicMaterial({color: 0xff0000, side: THREE.DoubleSide, transparent: true, opacity: 0.6});
						ballShadow = new THREE.Mesh(geometry, material);
						ballShadow.rotation.x=Math.PI/2;
						ballShadow.position.y=0.02;
						
						var geometry = new THREE.CircleGeometry( 0.0667, 10);
						var material = new THREE.MeshBasicMaterial({color: 0xff0000, side: THREE.DoubleSide, transparent: true, opacity: 0.3});
						ballShadow2 = new THREE.Mesh(geometry, material);
						//ballShadow2.rotation.order='YXZ';
						//ballShadow2.position.y=0.02;						
						//ballShadow2.rotation.x=Math.PI/2;
						//ballShadow2.rotation.x=Math.PI/2;
						//ballShadow.position.y=1;
						

						var loader = new THREE.GLTFLoader();
						loader.load(
						   "img/cube1.glb",
						   function ( gltf ) {
							   console.log('RRRRRRRRRR', gltf);
							  var scale = 1;
							  cube1 = gltf.scene;//.children[0];
							  cube1.name = "cube1";
							  //cube1.rotation.set ( 0, -1.5708, 0 );
							  cube1.scale.set (scale,scale,scale);
							  cube1.position.set ( 0, 15,  5);
							  cube1.castShadow = true;
							  
							  
							  camera.position.x=0;
							 // camera.position.y=3;
							  camera.position.z=10;
							  scene.add(cube1);		
							  //bus.frame.add(bus.body);*/
							  
							  //bus.frame.z=105;
							  //bus.frame.y=3
							  
							 /* var geometry=new THREE.CylinderGeometry(0.03, 0.03, 1, 15);
							  var material = new THREE.MeshBasicMaterial({color: 0x888800, side: THREE.DoubleSide});
							  racket=new THREE.Mesh(geometry, material);
							  racket.rotation.order='YXZ';
							  racket.position.y=1;
							  //racket.rotation.y=Math.PI/2;
							 // racket.rotation.x=Math.PI/2;*/
							 
							 var geometry=new THREE.CylinderGeometry(0.03, 0.03, /*2*/1.05, 15);
							  var material = new THREE.MeshBasicMaterial({color: 0x888800, side: THREE.DoubleSide, transparent: true, opacity: 0.5});
							  racket=new THREE.Mesh(geometry, material);
							  racket.rotation.order='YXZ';
							  racket.position.y=1;
							  //racket.rotation.y=Math.PI/2;
							 // racket.rotation.x=Math.PI/2;
							  
							  var geometry=new THREE.CylinderGeometry(0.03, 0.03, 3, 15);
							  var material = new THREE.MeshBasicMaterial({color: /*0x880000*/0x990000, side: THREE.DoubleSide, transparent: true, opacity: 0.7/*0.5*/});
							  racketSpeed=new THREE.Mesh(geometry, material);
							  racketSpeed.rotation.order='YXZ'
							  racketSpeed.position.y=1;							  
							  racketSpeed.position.y=0.015;//1.985;
							  racketSpeed.rotation.z=Math.PI/2;
							  
							  var geometry=new THREE.CylinderGeometry(0.03, 0.03, 3, 15);
							  var material = new THREE.MeshBasicMaterial({color: /*0x880000*/0x990000, side: THREE.DoubleSide, transparent: true, opacity: 0.6/*0.5*/});
							  racketSpeed2=new THREE.Mesh(geometry, material);
							  racketSpeed2.rotation.order='YXZ'
							  racketSpeed2.position.y=1;							  
							  racketSpeed2.position.y=0.015;//1.985;
							  racketSpeed2.rotation.z=Math.PI/2;
							  racketSpeed.scale.y=1.5/3;
							 
							  var geometry=new THREE.CylinderGeometry(0.03, 0.03, 2, 15);
							  var material = new THREE.MeshBasicMaterial({color: 0x009900, side: THREE.DoubleSide, transparent: true, opacity: 0.5});
							  viewHitAxy=new THREE.Mesh(geometry, material);
							  viewHitAxy.rotation.order='YXZ';
							  viewHitAxy.position.y=1;
							  
							  //viewHitAxy.rotation.z=Math.PI/2;
							  
							  
							  scene.add(field);
								scene.add(net);
								scene.add(ball);
								scene.add(ballShadow);
								scene.add(player1);
								scene.add(player0);		
								scene.add(racket);
								scene.add(racketSpeed);
								scene.add(racketSpeed2);
								
								scene.add(viewHitAxy);
								//scene.add(ballShadow2);	
								/*field.y=-10;
								field.rotation.x=Math.PI/1.6;
								scene.add(field);
								field.position.z=-14;
								field.position.y=-1;		*/
									
							
									
								renderer.render(scene, camera);
						   },
						);
										
					//});
				});
			});
		});
	});
	
	keySpaceOccupied=false;
	chat=(function()
	{
		var mesI=0;
		var listNode=document.querySelector('#chat ._list');
		var inputNode=document.querySelector('#chat input');
		var mesTemplateNode=document.querySelector('templates > .chat_message');

		inputNode.addEventListener('focusin', function()
		{
			keySpaceOccupied=true;
		});
		
		inputNode.addEventListener('focusout', function()
		{
			keySpaceOccupied=false;		
		});
		
		inputNode.addEventListener('keydown', function(event)
		{
			if(event.keyCode==13)
			{
				networkClient.messageSend({tp: 'chat', text: inputNode.value});
				inputNode.value='';
			}
		});

		return {
			receive: function(mes)
			{				
				var mesNode=mesTemplateNode.cloneNode(true);
				mesNode.querySelector('._name').innerText=mes.name;
				mesNode.querySelector('._text').innerText=mes.text;
				listNode.prepend(mesNode);
				//listNode.scrollTo(0, listNode.scrollHeight);
				if(mesI==30) 
				{
					//listNode.childNodes[0].remove();
					var m=listNode.childNodes;
					m[m.length-1].remove();
				}
				else
				{
					mesI++;
				}
			}
		}
	})();
	
	advice=(function()
	{
		var node=document.querySelector('#wait_advice');
		var advices=['Совет: набегайте на мяч под углом, чтобы придать ему вращение.', 'Совет: если мяч от соперника летит прямиком в аут, не отбивайте его.', 'Совет: набегайте на мяч, чтобы увеличить его скорость.', 'Совет: следите за вращением мяча, чтобы предугадывать его траекторию.'];
		return {
			hide: function()
			{
				node.style.display='none';
			},
			
			refresh: function()
			{
				node.style.display='block';
				node.innerText=advices[parseInt(Math.min(advices.length*Math.random(), advices.length-1))];
			}
		}
	})();
	
	waitView=(function()
	{
		var waitNode=document.getElementById('wait');
		var waitReadyNode=document.getElementById('wait_ready');
		
		return {
			status: function(status)
			{
				if(! status)
				{
					waitNode.classList.remove('success');
					waitNode.classList.remove('fail');
				}
				else if(status=='success') 
				{
					waitNode.classList.add('success');
					waitNode.classList.remove('fail');
				}
				else
				{
					waitNode.classList.remove('success');
					waitNode.classList.add('fail');
				}
			},
		
			ready: function(text)
			{
				waitReadyNode.innerHTML=text;
				waitNode.style.display='flex';
			},
			
			hide: function()
			{
				waitNode.style.display='none';
				
				document.getElementById('teaching_fail_border').style.display='none';
				document.getElementById('teaching_fail_out').style.display='none';
			},
			
			show: function()
			{
				waitNode.style.display='flex';
			}
		}
	})();
	
	lobby=(function()
	{
		return {
			hide: function()
			{
				document.body.classList.add('lobby_closed');
			},
			
			show: function()
			{
				document.body.classList.remove('lobby_closed');
			}
		};
	})();
	
	teachingStage2=false;
	teaching=(function()
	{		
		var stage=false;
		var nodeBlock2=document.getElementById('teaching_block2');
		return {
			start: function()
			{				
				if(localStorage.teachingEnd) return;
				stage=0;

				var m=false;
				setTimeout(this.step1, 2000);
				document.body.addEventListener('keydown', m=function(e)
				{
					if(e.keyCode==32)
					{
						document.body.removeEventListener('keydown', m);
						teaching.step2();
					}
				});
			},
			
			step1: function()
			{			
				if(stage>1) return;
				
				document.getElementById('teaching_block1').style.display='block';				
			},
			
			step2: function()
			{		
				var keysMove=[65, 68, 83, 87];
				var keysTurn=[39, 37];
				var keysMoveWas=false;
				var keysTurnWas=false;
				var m=false; 
				
				stage=2;
				teachingStage2=true;
				document.getElementById('teaching_block1').style.display='none';
				document.getElementById('teaching_block2').style.display='block';	

				
				document.body.addEventListener('keydown', m=function(e)
				{
					if(! keysMoveWas && keysMove.indexOf(e.keyCode)!==-1)
					{
						keysMoveWas=true;
						nodeBlock2.classList.add('_turn_only');
					}
					
					if(! keysTurnWas && keysTurn.indexOf(e.keyCode)!==-1)
					{
						keysTurnWas=true;
					}
						
					if(keysMoveWas && keysTurnWas)
					{
						document.body.removeEventListener('keydown', m);
						teaching.step3();					
					}
				});				
			},
						
			
			step3: function()
			{
				document.getElementById('teaching_block2').style.display='none';
				document.getElementById('teaching_block3').style.display='block';
				teaching.end();
			},
			
			end: function()
			{
				stage=3;
				teachingStage2=false;
				document.getElementById('teaching_block3').style.display='none';	
				localStorage.teachingEnd=1;
			},

			failBorder: function()
			{
				if(localStorage.failBorderNotShow) return;
				
				document.getElementById('teaching_fail_border').style.display='block';
			},
			
			failOut: function()
			{
				if(localStorage.failOutNotShow) return;
				
				document.getElementById('teaching_fail_out').style.display='block';
				
			},
			
			failOutClose: function()
			{
				localStorage.failOutNotShow=1;
				document.getElementById('teaching_fail_out').style.display='none';
			},
			
			failBorderClose: function()
			{
				localStorage.failBorderNotShow=1;
				document.getElementById('teaching_fail_border').style.display='none';
			},
			
			playerSetPos: function(x, y)
			{				
				nodeBlock2.style.left=Math.round(x*fieldScale+12)+'px';
				nodeBlock2.style.bottom=Math.round((40+y)*fieldScale)+'px';			
				nodeBlock2.style.width='auto';
			}
		};
	})();
	
	Main.init();
	
	var lobbyClose=document.querySelector('#lobby_close');
	lobbyClose.addEventListener('click', function(){document.body.classList.add('lobby_closed');});
	var lobbyOpen=document.querySelector('#lobby_open');
	lobbyOpen.addEventListener('click', function(){document.body.classList.remove('lobby_closed');});
	
	document.getElementById('help_close').addEventListener('click', function(){localStorage.helpClosed=1;document.body.classList.add('help_closed');});
	document.getElementById('help_open').addEventListener('click', function(){localStorage.helpClosed='';document.body.classList.remove('help_closed');});
	
	document.querySelector('#chat #chat_close').addEventListener('click', function(){document.body.classList.add('chat_closed');});
	document.getElementById('chat_open').addEventListener('click', function(){document.body.classList.remove('chat_closed');});
	
	teaching.start();
});								