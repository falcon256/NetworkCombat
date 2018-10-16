package lib.charge
{
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import lib.charge.ChargeGame;
	import com.greensock.TweenLite;
	
	public class ChargeDoc extends MovieClip
	{
		private var startButton = null;
		
		public function ChargeDoc()
		{
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			
			createStartMenu();
		}
		
		private function createStartMenu():void
		{
			var startMenu:StartScreen = new StartScreen();
			
			addChild(startMenu);
			
			startMenu.startButton.addEventListener(MouseEvent.CLICK, startGameHandler);
		}
		
		private function delayedIntro()
		{
				
			removeChild(startButton.parent);	
			createIntro();
		}
		
		private function startGameHandler(evt:MouseEvent):void
		{
			startButton = evt.currentTarget;
			TweenLite.to(startButton, 1, {onComplete:delayedIntro, alpha:0});
				
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startGameHandler);
			//createGame();
		}
		
		private function createIntro():void
		{
			var intro:IntroAnimation = new IntroAnimation();
			addChild(intro);
		}
		
		private function createGame():void
		{
			var game:ChargeGame = new ChargeGame();
			addChild(game);
		}
	}
}