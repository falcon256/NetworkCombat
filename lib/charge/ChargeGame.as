package lib.charge
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class ChargeGame extends MovieClip
	{
		private var currentStage:MovieClip;
		private var enemyBase:MovieClip;
		private var yourBase:MovieClip;
		private var enemyCounter:Number;
		private var enemyCounterTotal:Number;
		private var yourCounter:Number;
		private var yourCounterTotal:Number;
		
		private var yourGuys:Array;
		private var enemyGuys:Array;
		
		private var guyButton:SimpleButton;
		private var guy2Button:SimpleButton;
		
		private var yBuffer:Number;
		private var xBuffer:Number;
		
		private var yourScore:Number;
		private var enemyScore:Number;
		
		private var yourField:TextField;
		private var enemyField:TextField;
		
		public function ChargeGame ()
		{
			yBuffer = 100;
			xBuffer = 30;
			
			yourCounter = 100;
			enemyCounter = 80;
			enemyCounterTotal = 100;
			yourCounterTotal = 80;
			
			yourGuys = new Array();
			enemyGuys = new Array();
			
			currentStage = new Stage1();
			guyButton = new Guy1Button();
			guy2Button = new Guy2Button();
			
			guy2Button.x = guyButton.width;
			
			addChild(currentStage);
			addChild(guyButton);
			addChild(guy2Button);
			
			yourScore = 0;
			enemyScore = 0;
			
			yourField = new TextField;
			yourField.width = 200;
			yourField.text = "Your Score: 0";
			enemyField = new TextField;
			enemyField.width = 200;
			enemyField.text = "Enemy Score: 0";
			
			yourField.x = guyButton.width + guy2Button.width;
			enemyField.x = yourField.x + yourField.width;
			
			addChild(yourField);
			addChild(enemyField);
			
			guyButton.addEventListener(MouseEvent.CLICK, createGuyHandler);
			guy2Button.addEventListener(MouseEvent.CLICK, createGuy2Handler);
			
			yourBase = new Castle();
			enemyBase = new Castle();
			
			yourBase.y = enemyBase.y = currentStage.playingField.height - yourBase.height - yBuffer;
			enemyBase.x = currentStage.playingField.width - enemyBase.width - xBuffer;
			yourBase.x = xBuffer;
			
			currentStage.playingField.addChild(yourBase);
			currentStage.playingField.addChild(enemyBase);
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function createGuyHandler(evt:MouseEvent):void
		{
			createGuy("Right", new Guy1());
		}
		
		private function createGuy2Handler(evt:MouseEvent):void
		{
			createGuy("Right", new Guy2());
		}
		
		private function createGuy(dir:String, newGuy:Guy):void
		{
			trace("guy created! " + dir);
			
			newGuy.setDir(dir);
			
			newGuy.y = yourBase.y + yourBase.height - newGuy.height;
			
			if (dir == "Right")
			{
				yourCounter = 0;
				guy2Button.mouseEnabled = guyButton.mouseEnabled = false;
				guy2Button.alpha = guyButton.alpha = 0.5;
				
				newGuy.x = xBuffer + newGuy.width;
				
				newGuy.enemies = enemyGuys;
				newGuy.friends = yourGuys;
				
				yourGuys.push(newGuy);
			}
			else
			{
				newGuy.x = currentStage.playingField.width - newGuy.width - xBuffer;
				
				newGuy.enemies = yourGuys;
				newGuy.friends = enemyGuys;
				
				enemyGuys.push(newGuy);
			}
			
			currentStage.playingField.addChild(newGuy);
		}
		
		private function update(evt:Event):void
		{
			if (yourCounter < yourCounterTotal)
			{
				yourCounter++;
			}
			else
			{
				guy2Button.mouseEnabled = guyButton.mouseEnabled = true;
				guy2Button.alpha = guyButton.alpha = 1;
			}
			if (enemyCounter < enemyCounterTotal)
			{
				enemyCounter++;
			}
			else
			{
				enemyCounter = -100;
				createGuy("Left", new Guy1());
			}
			
			currentStage.update();
			
			var guy:Guy;
			
			for each (guy in yourGuys)
			{
				if (guy.x > enemyBase.x)
				{
					yourScore++;
					yourField.text = "Your Score: " + yourScore;
					guy.purge();
				}
				else
				{
					guy.update();
				}
			}
			
			for each (guy in enemyGuys)
			{
				if (guy.x < yourBase.x + yourBase.width)
				{
					enemyScore++;
					enemyField.text = "Enemy Score: " + enemyScore;
					guy.purge();
				}
				else
				{
					guy.update();
				}
			}
		}
		
		private function pause():void
		{
			
		}
		
		private function unpause():void
		{
			
		}
		
		private function endGame():void
		{
			
		}
	}
}