package  {
	
	import flash.display.MovieClip;
	import lib.charge.ChargeGame;
	import flash.events.Event;
	
	
	public class Bullet extends MovieClip {
			
		public var velX:Number;
		public var velY:Number;
		public var amIRed:Boolean;
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
		}
		
		public function destroyMe()
		{
			if(this.parent!=null)
			{
				removeEventListener(Event.ENTER_FRAME, doTick);
				parent.removeChild(this);
				bulletNum--;
				trace("Bullets " + bulletNum);
			}
		}
		
		private function doTick(evt:Event)
		{
			update();
		}
	}
	
}
