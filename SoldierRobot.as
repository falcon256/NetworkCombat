package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import lib.charge.ChargeGame;

	public class SoldierRobot extends MovieClip {
		
		public var amIRed:Boolean;
		public var amICrouched:Boolean;
		
		public var facingLeft:Boolean;
		
		private var direction:Boolean;
		private var health:Number;
		private var stopped:Boolean;
		private var maxLifeTime:Number;
		private var age:Number;
		//public  var allSoldiers:Array;
		public static var chargeGame:ChargeGame;
		public var brain:Network;//Some code
		
		
		public function SoldierRobot(br:Network,red) {
			brain = br;
			age = 0;
			maxLifeTime = chargeGame.currentMaxLifeTime;
			//allSoldiers = new Array();
			startWalk();
			direction = amIRed = red;
		}
		
		public function startWalk()
		{
			Leg1.gotoAndPlay(11);
			Leg2.gotoAndPlay(20);
			stopped=false;
		}
		
		public function update():void
		{
			if(brain==null)
			{
				trace("This guy has no brain!!!!!!");
				return;
			}
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
			
			var isGrounded:Boolean = false;
			if(chargeGame.getColorSample(this.x,this.y+96))
			{
				y--;
				isGrounded=true;
			}
			else
			{
				y++;
				isGrounded=false;
			}
			//this was just for testing.
			//brain = brain.mutateAndReturnNewNetwork(0.1,0.01,0.01);
			
			
			brain.setSingleInput(0,(isGrounded)?1:0);
			brain.setSingleInput(1,chargeGame.getAlliesNearbyClose(x,amIRed));
			brain.setSingleInput(2,chargeGame.getAlliesNearby(x,amIRed));
			brain.setSingleInput(3,chargeGame.getAlliesNearbyFar(x,amIRed));
			brain.tickNetwork();
			var leftBias:Number = brain.getSingleOutput(0);
			var rightBias:Number = brain.getSingleOutput(1);
			var shootBias:Number = brain.getSingleOutput(2);
			var aimAngle:Number = brain.getSingleOutput(3)*90;
			var crouchBias:Number = brain.getSingleOutput(4);
			var normTotal:Number = Math.sqrt(leftBias*leftBias + rightBias*rightBias + shootBias*shootBias + crouchBias*crouchBias);
			
			leftBias/=normTotal+0.00001;
			rightBias/=normTotal+0.00001;
			shootBias/=normTotal+0.00001;
			crouchBias/=normTotal+0.00001;
			
			//trace(leftBias+" "+rightBias);
			if(leftBias>0.5)
			{
				x+=0.5;
			}
			else if(rightBias>0.5)
			{
				x-=0.5;
			}
			else if(shootBias>0.5)
			{
				
			}
			else if(crouchBias>0.5)
			{
				
			}
			//trace(age+" "+maxLifeTime);
			if(age++>maxLifeTime||y>chargeGame.stage.height)
				killMeAndSaveMyBrain();
			
			
			if(x<1+width)
				x=1+width;
			if(x>chargeGame.stage.width-width)
				x=chargeGame.stage.width-width;
			
			
			
		}
		
		public function killMeAndSaveMyBrain():void
		{
			//trace("Killing...");
			var score:Number = x;
			if(amIRed)
			{
				brain.score=score=chargeGame.getDistanceRatioFromBlueBase(x,y);
				chargeGame.addRedNetwork(brain);				
				this.parent.removeChild(this);				
				chargeGame.allSoldiers.splice(chargeGame.allSoldiers.indexOf(this),1);
				
			}
			else
			{	
				brain.score=score=chargeGame.getDistanceRatioFromRedBase(x,y);
				chargeGame.addBlueNetwork(brain);				
				this.parent.removeChild(this);
				chargeGame.allSoldiers.splice(chargeGame.allSoldiers.indexOf(this),1);
			}
		}
		
		public function setDir(newDir:Boolean):void
		{
			direction = newDir;
			gotoAndStop(5);
		}
	}
	
}
