package lib.charge
{
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
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
		
		private var yBuffer:Number;
		private var xBuffer:Number;		
		public var blueScore:Number;
		public var redScore:Number;		
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
			maxLifeTime=10000000;
			currentMaxLifeTime=1000;
			
			
			allSoldiers = new Array();
			blueNetworks = new Array();
			redNetworks = new Array();

			blueNetworks.push(new Network(2,10));
			redNetworks.push(new Network(2,10));
			
			currentStage = new Stage1();
			
			addChild(currentStage);
			
			blueScore = 0;
			redScore = 0;
			var myTextFormat:TextFormat = new TextFormat();
			myTextFormat.size = 20;
			
			
			
			myTextFormat.color = 0x00AAFF;
			blueField = new TextField;
			blueField.width = 200;
			blueField.text = "blue Score: 0";
			blueField.setTextFormat(myTextFormat);
			
			myTextFormat.color = 0xFFAA00;
			redField = new TextField;
			redField.width = 200;
			redField.text = "red Score: 0";
			redField.setTextFormat(myTextFormat);
			blueField.x = 256;
			redField.x = 768;
			
			addChild(blueField);
			addChild(redField);
			
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
			SoldierRobot.sChargeGame=this;
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function createGuy(dir:Boolean, newGuy:SoldierRobot):void
		{
			//trace("guy created! " + dir);
			newGuy.setDir(dir);
			newGuy.width=12;
			newGuy.height=18;
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
		
		private function updateScores()
		{
			var myTextFormat:TextFormat = new TextFormat();
			myTextFormat.size = 20;
			
			blueField.width = 200;
			redField.width = 200;
			blueField.x = 256;
			redField.x = 768;
			blueField.text = "Blue Score: "+blueScore;
			redField.text = "Red Score: "+redScore;
			myTextFormat.color = 0x00AAFF;
			blueField.setTextFormat(myTextFormat);
			myTextFormat.color = 0xFFAA00;
			redField.setTextFormat(myTextFormat);
		}
		
		private function update(evt:Event):void
		{
			updateScores();
			currentMaxLifeTime = Math.min(maxLifeTime,currentMaxLifeTime+0.2);
			spawnTimerAccumulator++;
			var guy:SoldierRobot;
			for each (guy in allSoldiers)
			{
				guy.visible=false;
				guy.update();
			}

			//grab our stage for per-pixel collision detection.
			if(stageBitmapData==null&&currentStage!=null&&currentStage.playingField!=null&&currentStage.Stage1BG!=null)
			{
				currentStage.Stage1BG.visible=false;
				currentStage.Stage1BG.enabled=false;
				stageBitmapData = new BitmapData(currentStage.width, currentStage.height);
				stageBitmapData.draw(currentStage);
				stageBitmap = new Bitmap(stageBitmapData);
				currentStage.Stage1BG.visible=true;
				currentStage.Stage1BG.enabled=true;
			}
			

			if (spawnTimerAccumulator++ > (3*spawnTimerMaximum)/stage.frameRate)
			{
				spawnTimerAccumulator=0;
				
				var a:Number = currentStage.Slider1.value;
				var b:Number = currentStage.Slider2.value;
				var c:Number = currentStage.Slider3.value;
				
				createGuy(false, new SoldierRobot(getBestBlueNetwork().mutateAndReturnNewNetwork(0.25*a,0.005*b,0.005*c),false));
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
			//trace("Red:"+best.score+" "+redNetworks.length)
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
			//trace("Blue:"+best.score+" "+blueNetworks.length)
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
		}
		
		public function  getDistanceRatioFromRedBase(xa:Number, ya:Number):Number
		{
			return stage.width-Math.abs(xa-redBase.x);
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
		
		public function getEnemiesNearbyClose(xa:Number, red:Boolean):Number
		{
			var near:Number=0;
			var guy:SoldierRobot;
			for each (guy in allSoldiers)
			{
				if(guy.amIRed!=red)
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
		
		//borrowed
		public static function degFromRad( p_radInput:Number ):Number
		{
			var degOutput:Number = ( 180 / Math.PI ) * p_radInput;
			return degOutput;
		}

		public static function radFromDeg( p_degInput:Number ):Number
		{
			var radOutput:Number = ( Math.PI / 180 ) * p_degInput;
			return radOutput;
		}
	}
}