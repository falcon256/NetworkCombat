package  {
	
	import flash.display.MovieClip;
	import lib.charge.ChargeGame;
	
	
	
	public class Bullet extends MovieClip {
			
		public var velX:Number;
		public var velY:Number;
		public var amIRed:Boolean;
		public static var chargeGame:ChargeGame;
		
		
		public function Bullet() {
			chargeGame = ChargeGame.chargeGame;
		}
		
		public function update()
		{
			if((x<0)||(x>chargeGame.stage.width)||(y<0)||(y>chargeGame.stage.height))
			{
				destroyMe();
			}
		}
		
		public function destroyMe()
		{
			
		}
		
	}
	
}
