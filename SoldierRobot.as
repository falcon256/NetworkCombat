package  {
	
	import flash.display.MovieClip;
	
	
	public class SoldierRobot extends MovieClip {
		
		public function SoldierRobot() {
			
		}
		
		public function update():void
		{
			if(Leg1.currentFrame>23)
				Leg1.gotoAndPlay(5);
			if(Leg2.currentFrame>23)
				Leg2.gotoAndPlay(5);
		}
	}
	
}
