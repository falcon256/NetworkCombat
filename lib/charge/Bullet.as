package lib.charge {
	
	import flash.display.MovieClip;
	import lib.charge.ChargeGame;
	import flash.events.Event;
	
	
	public class Bullet extends MovieClip {
			
		public var velX:Number;
		public var velY:Number;
		public var amIRed:Boolean;
		public var myRobot:SoldierRobot=null;
		public static var chargeGame:ChargeGame;
		private static var bulletNum = 0;
		
		public function Bullet() {
			
			chargeGame = ChargeGame.chargeGame;
			addEventListener(Event.ENTER_FRAME, doTick);
			bulletNum++;
		}
		
		public function update()
		{
			if((x<0)||(x>1024)||(y<0)||(y>1024))
			{
				destroyMe();
			}
			this.x+=velX;
			this.y+=velY;
			this.rotation = ChargeGame.degFromRad(Math.atan2(velX,-velY));
			velX*=0.999;
			velY+=0.1;
			velY*=0.999;
			
			if(chargeGame.getColorSample(this.x,this.y+80))
			{
				destroyMe();
				return;
			}
			
			var guyN:int;
			for(guyN=0; guyN < chargeGame.allSoldiers.length; guyN++)
			{
				var guy:SoldierRobot = chargeGame.allSoldiers[guyN];
				if(guy.hitTestPoint(x,y+96)&&guy.hitTestPoint(x,y+96,true))
				{
					var crouchMulti:Number = 1.0;
					if(guy.amICrouched)
						crouchMulti=0.1;
					//trace("KILLLLLLLL!~L!L!L!L!L!!L!L!L!L!L!");
					if(guy.amIRed==myRobot.amIRed)
					{
						if(Math.random()<0.1*crouchMulti)//friendly fire!
						{
							myRobot.brain.score--;
							guy.health-=101;
							destroyMe();
							if(guy.amIRed)
								chargeGame.redScore--;
							else
								chargeGame.blueScore--;
							return;
						}
					}
					else
					{
						if(Math.random()<0.5*crouchMulti)//unfriendly fire!
						{
							myRobot.brain.score++;
							guy.health-=101;
							destroyMe();
							if(guy.amIRed)
								chargeGame.redScore++;
							else
								chargeGame.blueScore++;
							return;
						}
					}
				}
			}
		}
		
		public function destroyMe()
		{
			if(this.parent!=null)
			{
				removeEventListener(Event.ENTER_FRAME, doTick);
				parent.removeChild(this);
				bulletNum--;
				//trace("Bullets " + bulletNum);
			}
		}
		
		private function doTick(evt:Event)
		{
			update();
		}
	}
	
}
