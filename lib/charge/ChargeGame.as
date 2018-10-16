package lib.charge
{
	
		//TODO-BUG- Troubleshoot why the spawn point changes on the red side.
	
	
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import lib.DanNN.Network;
	import lib.DanNN.Neuron;
	
	public class ChargeGame extends MovieClip
	{
		
		public static var chargeGame:ChargeGame;
		private var currentStage:MovieClip;
		private var redBase:MovieClip;
		private var blueBase:MovieClip;
		
		private var spawnTimerAccumulator:Number;
		private var spawnTimerMaximum:Number;
		
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
		
		private var maxLifeTime:Number;
		
		private var blueNetworks:Array;
		private var redNetworks:Array;
		
		public var allSoldiers:Array;
		public var currentMaxLifeTime:Number;
		
		public function ChargeGame ()
		{
			chargeGame=this;
		
			spawnTimerAccumulator=0;
			spawnTimerMaximum = 1000;
			yBuffer = 100;
			xBuffer = 30;
			maxLifeTime=1000000;
			currentMaxLifeTime=1000;
			
			
			allSoldiers = new Array();
			blueNetworks = new Array();
			redNetworks = new Array();
			
			//debug code
			blueNetworks.push(new Network(2,10));
			redNetworks.push(new Network(2,10));
			
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
			//createGuy(true, new SoldierRobot());
		}
		
		private function createGuy2Handler(evt:MouseEvent):void
		{
			//createGuy(true, new SoldierRobot());
		}
		
		private function createGuy(dir:Boolean, newGuy:SoldierRobot):void
		{
			//trace("guy created! " + dir);
			newGuy.setDir(dir);
			newGuy.width=10;
			newGuy.height=16;
			newGuy.y = blueBase.y + blueBase.height - newGuy.height - 100;
			var myColorTransform = new ColorTransform();
			if (dir == false)
			{
				
				newGuy.x = newGuy.width;
				
				myColorTransform.color = 0x808080;
				newGuy.transform.colorTransform = myColorTransform;
				allSoldiers.push(newGuy);
			}
			else
			{
				newGuy.x = currentStage.playingField.width - newGuy.width;
				
				myColorTransform.color = 0xA08080;
				newGuy.transform.colorTransform = myColorTransform;
				allSoldiers.push(newGuy);
			}
			
			currentStage.playingField.addChild(newGuy);
		}
		
		private function update(evt:Event):void
		{
			currentMaxLifeTime = Math.min(maxLifeTime,currentMaxLifeTime+0.1);
			spawnTimerAccumulator++;
			var guy:SoldierRobot;
			for each (guy in allSoldiers)
			{
				guy.visible=false;
				guy.update();
			}
			//grab our stage for per-pixel collision detection.
			stageBitmapData = new BitmapData(currentStage.width, currentStage.height);
			stageBitmapData.draw(currentStage);
			stageBitmap = new Bitmap(stageBitmapData);
			

			if (spawnTimerAccumulator++ > spawnTimerMaximum/stage.frameRate)
			{
				spawnTimerAccumulator=0;
				createGuy(false, new SoldierRobot(getBestBlueNetwork().mutateAndReturnNewNetwork(0.5,0.01,0.01),false));
				createGuy(true, new SoldierRobot(getBestRedNetwork().mutateAndReturnNewNetwork(0.5,0.1,0.1),true));
				trace(currentStage.playingField.numChildren);
			}
			
			
			for each (guy in allSoldiers)
			{
				guy.visible=true;
				guy.update();
			}
	
			trimNetworkLists();
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
				//trace(blue);
				if(red>200&&green>200&&blue>200)
					return false;
			}
			return true;
		}
		
		public function getBestRedNetwork():Network
		{
			var net:Network=null;
			var best:Network = null;
			var bestScore:Number = -1;
			for each (net in redNetworks)
			{
				if(net.score>bestScore)
				{
					bestScore=net.score;
					best=net;
				}				
			}
			trace("Red:"+best.score+" "+redNetworks.length)
			return best;
		}
		
		public function getBestBlueNetwork():Network
		{
			var net:Network=null;
			var best:Network = null;
			var bestScore:Number = -1;
			for each (net in blueNetworks)
			{
				if(net.score>bestScore)
				{
					bestScore=net.score;
					best=net;
				}				
			}
			trace("Blue:"+best.score+" "+blueNetworks.length)
			return best;
		}
		
		public function trimNetworkLists()
		{
			if(redNetworks.length>100)
			{
				//remove worst
				var net:Network = null;
				var low:Number = 10000000;
				var worse:Network = null;
				for each(net in redNetworks)
				{
					if(net.score<low)
					{
						worse = net;
						low = worse.score;
					}
				}
				redNetworks.removeAt(redNetworks.indexOf(worse));
			}
			
			if(blueNetworks.length>100)
			{
				var oldNet:Network = net;
				//net:Network = null;
				low = 10000000;
				//worse:Network = null;
				for each(net in blueNetworks)
				{
					if(net.score<low)
					{
						worse = net;
						oldNet = worse;
						low = worse.score;
					}
				}
				if(oldNet!=net)
					blueNetworks.removeAt(blueNetworks.indexOf(worse));
			}
		}
		
		public function addRedNetwork(net:Network)
		{
			redNetworks.push(net);
		}
		
		public function addBlueNetwork(net:Network)
		{
			blueNetworks.push(net);
		}
		
		public function  getDistanceRatioFromBlueBase(xa:Number, ya:Number):Number
		{
			return stage.width-Math.abs(xa-blueBase.x);
			//var xd:Number = Math.abs(xa-blueBase.x);
			//return xd/stage.width;
		}
		
		public function  getDistanceRatioFromRedBase(xa:Number, ya:Number):Number
		{
			return stage.width-Math.abs(xa-redBase.x);
			//var xd:Number = Math.abs(xa-redBase.x);
			//return xd/stage.width;
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
		
		
		
		//network input queries
		public function getAlliesNearbyClose(xa:Number, red:Boolean):Number
		{
			var near:Number=0;
			var guy:SoldierRobot;
			for each (guy in allSoldiers)
			{
				if(guy.amIRed==red)
				{
					var xd:Number = Math.abs(guy.x-xa)
					if( xd < 64 )
					{
						near+=0.1;
					}
				}
			}
			return Math.min(near,1.0);
		}
		
		public function getAlliesNearby(xa:Number, red:Boolean):Number
		{
			var near:Number=0;
			var guy:SoldierRobot;
			for each (guy in allSoldiers)
			{
				if(guy.amIRed==red)
				{
					var xd:Number = Math.abs(guy.x-xa)
					if( xd < 128 )
					{
						near+=0.1;
					}
				}
			}
			return Math.min(near,1.0);
		}
		
		public function getAlliesNearbyFar(xa:Number, red:Boolean):Number
		{
			var near:Number=0;
			var guy:SoldierRobot;
			for each (guy in allSoldiers)
			{
				if(guy.amIRed==red)
				{
					var xd:Number = Math.abs(guy.x-xa)
					if( xd < 256 )
					{
						near+=0.1;
					}
				}
			}
			return Math.min(near,1.0);
		}
	}
}