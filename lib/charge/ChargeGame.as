package lib.charge
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class ChargeGame extends MovieClip
	{
		private var currentStage:MovieClip;
		private var redBase:MovieClip;
		private var blueBase:MovieClip;
		private var redCounter:Number;
		private var redCounterTotal:Number;
		private var blueCounter:Number;
		private var blueCounterTotal:Number;
		
		private var allSoldiers:Array;
		
		
		private var guyButton:SimpleButton;
		private var guy2Button:SimpleButton;
		
		private var yBuffer:Number;
		private var xBuffer:Number;
		
		private var blueScore:Number;
		private var redScore:Number;
		
		private var blueField:TextField;
		private var redField:TextField;
		
		private var stageBitmapData:BitmapData;
		private var stageBitmap:Bitmap;
		
		public function ChargeGame ()
		{
			yBuffer = 100;
			xBuffer = 30;
			
			blueCounter = 100;
			redCounter = 80;
			redCounterTotal = 100;
			blueCounterTotal = 80;
			
			allSoldiers = new Array();
			
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
			
			blueBase.y=512-56;
			redBase.y=512-56;
			blueBase.x=32;
			redBase.x=1024-32;
			blueBase.width=64;
			redBase.width=64;
			blueBase.height=72;	
			redBase.height=72;
			
			//blueBase.y = redBase.y = currentStage.playingField.height - blueBase.height - yBuffer;
			//redBase.x = currentStage.playingField.width - redBase.width - xBuffer;
			//blueBase.x = xBuffer;
			
			currentStage.playingField.addChild(blueBase);
			currentStage.playingField.addChild(redBase);
			SoldierRobot.chargeGame=this;
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function createGuyHandler(evt:MouseEvent):void
		{
			createGuy(true, new SoldierRobot());
		}
		
		private function createGuy2Handler(evt:MouseEvent):void
		{
			createGuy(true, new SoldierRobot());
		}
		
		private function createGuy(dir:Boolean, newGuy:SoldierRobot):void
		{
			trace("guy created! " + dir);
			newGuy.setDir(dir);
			newGuy.width=10;
			newGuy.height=16;
			newGuy.y = blueBase.y + blueBase.height - newGuy.height - 100;
			
			if (dir == "Right")
			{
				blueCounter = 0;
				guy2Button.mouseEnabled = guyButton.mouseEnabled = false;
				guy2Button.alpha = guyButton.alpha = 0.5;
				
				newGuy.x = xBuffer + newGuy.width;
				
				newGuy.allSoldiers = allSoldiers;
				
				allSoldiers.push(newGuy);
			}
			else
			{
				newGuy.x = currentStage.playingField.width - newGuy.width - xBuffer;
				
				newGuy.allSoldiers = allSoldiers;
				
				allSoldiers.push(newGuy);
			}
			
			currentStage.playingField.addChild(newGuy);
		}
		
		private function update(evt:Event):void
		{
			//grab our stage for per-pixel collision detection.
			var stageBitmapData:BitmapData = new BitmapData(stage.width, stage.height);
			stageBitmapData.draw(stage);
			var stageBitmap:Bitmap = new Bitmap(stageBitmapData);
			
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
				createGuy(false, new SoldierRobot());
			}
			
			var guy:SoldierRobot;
			for each (guy in allSoldiers)
			{
				guy.update();
			}
			//currentStage.update();// we axed that parralax bs, so this isn't needed.
			/*
			var guy:SoldierRobot;
			
			for each (SoldierRobot in blueGuys)
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
			*/
		}
		
		//slashdot is helpful, this is heavily modified though.
		public function getColorSample(x:int, y:int):Boolean {			
			//trace(b.bitmapData.getPixel(x,y));
			if(stageBitmap!=null&&stageBitmap.bitmapData!=null)
			{
				var rgb:uint = stageBitmap.bitmapData.getPixel(x,y);
				var red:int =  (rgb >> 16 & 0xff);
				var green:int =  (rgb >> 8 & 0xff);
				var blue:int =  (rgb & 0xff);
				
				if(red>200&&green>200&&blue>200)
					return false;
			}
			return true;
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