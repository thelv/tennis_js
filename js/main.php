<?php	
	header("Cache-control: public");
	header("Expires: " . gmdate("D, d M Y H:i:s", time() + 60*60*24) . " GMT");
	echo "\n\n"; readfile('../classes/Main.as');
	echo "\n\n"; readfile('../classes/MainView.as');
	echo "\n\n"; readfile('../classes/MathLib.as');
	echo "\n\n"; readfile('../classes/View.as');
	echo "\n\n"; readfile('../classes/NetworkClient/NetworkClient.as');
	echo "\n\n"; readfile('../classes/Game/Game.as');
	echo "\n\n"; readfile('../classes/Game/GameView.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Rally.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Ball/Ball.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Ball/BallView.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Ball/BallCollisions/BallCollisions.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Ball/BallEval/BallEval.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Player/Player.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Player/PlayerView.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Player/LocalPlayer.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Player/BotPlayer.as');	
	echo "\n\n"; readfile('../classes/Game/Rally/Player/RemotePlayer.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Player/PlayerCollisions/PlayerCollisions.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Player/PlayerEvalA/PlayerEvalA.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Player/PlayerEvalXY/PlayerEvalXY.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Player/KeyHandler/KeyHandler.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Referee/Referee.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Scale/Scale.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Time/Time.as');
	echo "\n\n"; readfile('../classes/Game/Rally/Timer/Timer.as');
	echo "\n\n"; readfile('../classes/Game/Rally/BorderLines/BorderLines.as');
	echo "\n\n"; readfile('../classes/Game/Rally/FieldLines/FieldLines.as');
	echo "\n\n"; readfile('../classes/Game/Rally/ServeLines/ServeLines.as');
	echo "\n\n"; readfile('../classes/Game/Rally/MiddleLines/MiddleLines.as');
	echo "\n\n"; readfile('../classes/Game/Rally/MiddleLines/MiddleLine/MiddleLine.as');
	echo "\n\n"; readfile('../classes/Game/Rally/MiddleLines/MiddleLine/MiddleLineView.as');
	echo "\n\n"; readfile('../classes/Game/Referee/Referee.as');
	echo "\n\n"; readfile('../classes/Game/Wait/Wait.as');
	echo "\n\n"; readfile('../classes/Game/Wait/NetworkWait.as');
	echo "\n\n"; readfile('../classes/Game/Wait/ViewWait.as');	
	echo "\n\n"; readfile('main.js');	
?>