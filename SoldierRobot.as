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
		public var brain:Network;
		
		
		public function SoldierRobot(br:Network) {
			brain = br;
			age = 0;
			maxLifeTime = chargeGame.currentMaxLifeTime;
			//allSoldiers = new Array();
			startWalk();
			amIRed = direction;
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
			
			brain.setSingleInput(0,chargeGame.getAlliesNearbyClose();//left off here TODO
			brain.setSingleInput(1,(isGrounded)?1:0);
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
			
			trace(leftBias+" "+rightBias);
			if(leftBias>0.9)
			{
				x+=0.5;
			}
			else if(rightBias>0.9)
			{
				x-=0.5;
			}
			else if(shootBias>0.9)
			{
				
			}
			else if(crouchBias>0.9)
			{
				
			}
			trace(age+" "+maxLifeTime);
			if(age++>maxLifeTime||y>chargeGame.stage.height)
				killMeAndSaveMyBrain();
			
			
			if(x<1)
				x=1;
			if(x>chargeGame.stage.width-1)
				x=chargeGame.stage.width;
			
			
			
		}
		
		public function killMeAndSaveMyBrain():void
		{
			trace("Killing...");
			var score:Number = x;
			if(amIRed)
			{
				brain.score=score=1.0-chargeGame.getDistanceRatioFromBlueBase(x,y);
				chargeGame.addRedNetwork(brain);
				this.parent.removeChild(this);
				chargeGame.allSoldiers.removeAt(chargeGame.allSoldiers.indexOf(this));
			}
			else
			{	
				brain.score=score=1.0-chargeGame.getDistanceRatioFromRedBase(x,y);
				chargeGame.addBlueNetwork(brain);
				this.parent.removeChild(this);
				chargeGame.allSoldiers.removeAt(chargeGame.allSoldiers.indexOf(this));
			}
		}
		
		public function setDir(newDir:Boolean):void
		{
			direction = newDir;
			gotoAndStop(5);
		}
	}
	
}
