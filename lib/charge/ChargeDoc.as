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
		private var startScreen = null;
		private var intro:IntroAnimation = null;
		public function ChargeDoc()
		{
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			
			createStartMenu();
		}
		
		private function createStartMenu():void
		{
			var startMenu:StartScreen = new StartScreen();
			startScreen=startMenu;
			addChild(startMenu);
			
			startMenu.startButton.addEventListener(MouseEvent.CLICK, startIntroHandler);
		}
		
		private function delayedIntro()
		{				
			removeChild(startButton.parent);	
			createIntro();
		}
		
		private function startIntroHandler(evt:MouseEvent):void		
		{
			startButton = evt.currentTarget;
			TweenLite.to(startScreen, 1, {onComplete:delayedIntro, alpha:0});
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startGameHandler);
		}
		
		private function startGameHandler(evt:MouseEvent):void
		{
			intro.disable();
			removeChild(intro);
			intro = null;
			createGame();
		}
		
		private function createIntro():void
		{
			intro = new IntroAnimation();
			intro.ProceedButton.addEventListener(MouseEvent.CLICK, startGameHandler);
			intro.GewdEnufButton.addEventListener(MouseEvent.CLICK, startGameHandler);
			addChild(intro);
		}
		
		private function createGame():void
		{
			var game:ChargeGame = new ChargeGame();
			addChild(game);
		}
	}
}