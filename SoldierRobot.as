package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import lib.charge.ChargeGame;
	
	public class SoldierRobot extends MovieClip {
		
		private var amIRed:Boolean;
		private var direction:Boolean;
		private var health:Number;
		private var stopped:Boolean;
		public  var allSoldiers:Array;
		public static var chargeGame:ChargeGame;
		
		
		public function SoldierRobot() {
			allSoldiers = new Array();
			startWalk();
		}
		
		public function startWalk()
		{
			Leg1.gotoAndPlay(11);
			Leg2.gotoAndPlay(20);
			stopped=false;
		}
		
		public function update():void
		{
			
			if(!stopped)
			{
			if(Leg1.currentFrame>23)
			{
				Leg1.gotoAndPlay(5);
			}
			
			if(Leg2.currentFrame>23)
			{
				Leg2.gotoAndPlay(5);
			}
			}
			
			if(chargeGame.getColorSample(this.x,this.y+10))
				y=y+1
			else
				y=y-1;
		}
		
		public function setDir(newDir:Boolean):void
		{
			direction = newDir;
			gotoAndStop(5);
		}
	}
	
}
