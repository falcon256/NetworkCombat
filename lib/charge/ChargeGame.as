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
		private var redBase:MovieClip;
		private var blueBase:MovieClip;
		private var redCounter:Number;
		private var redCounterTotal:Number;
		private var blueCounter:Number;
		private var blueCounterTotal:Number;
		
		private var blueGuys:Array;
		private var redGuys:Array;
		
		private var guyButton:SimpleButton;
		private var guy2Button:SimpleButton;
		
		private var yBuffer:Number;
		private var xBuffer:Number;
		
		private var blueScore:Number;
		private var redScore:Number;
		
		private var blueField:TextField;
		private var redField:TextField;
		
		public function ChargeGame ()
		{
			yBuffer = 100;
			xBuffer = 30;
			
			blueCounter = 100;
			redCounter = 80;
			redCounterTotal = 100;
			blueCounterTotal = 80;
			
			blueGuys = new Array();
			redGuys = new Array();
			
			currentStage = new Stage1();
			guyButton = new Guy1Button();
			guy2Button = new Guy2Button();
			
			guy2Button.x = guyButton.width;
			
			addChild(currentStage);
			addChild(guyButton);
			addChild(guy2Button);
			
			blueScore = 0;
			redScore = 0;
			
			blueField = new TextField;
			blueField.width = 200;
			blueField.text = "blue Score: 0";
			redField = new TextField;
			redField.width = 200;
			redField.text = "red Score: 0";
			
			blueField.x = guyButton.width + guy2Button.width;
			redField.x = blueField.x + blueField.width;
			
			addChild(blueField);
			addChild(redField);
			
			guyButton.addEventListener(MouseEvent.CLICK, createGuyHandler);
			guy2Button.addEventListener(MouseEvent.CLICK, createGuy2Handler);
			
			blueBase = new Castle();
			redBase = new Castle();
			
			blueBase.y=512-128;
			redBase.y=512-128;
			blueBase.x=128;
			redBase.x=1024-128;
			//blueBase.y = redBase.y = currentStage.playingField.height - blueBase.height - yBuffer;
			//redBase.x = currentStage.playingField.width - redBase.width - xBuffer;
			//blueBase.x = xBuffer;
			
			currentStage.playingField.addChild(blueBase);
			currentStage.playingField.addChild(redBase);
			
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
			
			newGuy.y = blueBase.y + blueBase.height - newGuy.height;
			
			if (dir == "Right")
			{
				blueCounter = 0;
				guy2Button.mouseEnabled = guyButton.mouseEnabled = false;
				guy2Button.alpha = guyButton.alpha = 0.5;
				
				newGuy.x = xBuffer + newGuy.width;
				
				newGuy.enemies = redGuys;
				newGuy.friends = blueGuys;
				
				blueGuys.push(newGuy);
			}
			else
			{
				newGuy.x = currentStage.playingField.width - newGuy.width - xBuffer;
				
				newGuy.enemies = blueGuys;
				newGuy.friends = redGuys;
				
				redGuys.push(newGuy);
			}
			
			currentStage.playingField.addChild(newGuy);
		}
		
		private function update(evt:Event):void
		{
			if (blueCounter < blueCounterTotal)
			{
				blueCounter++;
			}
			else
			{
				guy2Button.mouseEnabled = guyButton.mouseEnabled = true;
				guy2Button.alpha = guyButton.alpha = 1;
			}
			if (redCounter < redCounterTotal)
			{
				redCounter++;
			}
			else
			{
				redCounter = -100;
				createGuy("Left", new Guy1());
			}
			
			//currentStage.update();// we axed that parralax bs, so this isn't needed.
			
			var guy:Guy;
			
			for each (guy in blueGuys)
			{
				if (guy.x > redBase.x)
				{
					blueScore++;
					blueField.text = "blue Score: " + blueScore;
					guy.purge();
				}
				else
				{
					guy.update();
				}
			}
			
			for each (guy in redGuys)
			{
				if (guy.x < blueBase.x + blueBase.width)
				{
					redScore++;
					redField.text = "red Score: " + redScore;
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