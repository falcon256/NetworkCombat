package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class SoldierRobot extends MovieClip {
		
		private var amIRed:Boolean;
		private var direction:Boolean;
		private var health:Number;
		private var stopped:Boolean;
		public  var allSoldiers:Array;
		
		
		
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
		}
		
		public function setDir(newDir:Boolean):void
		{
			direction = newDir;
			gotoAndStop(5);
		}
	}
	
}
