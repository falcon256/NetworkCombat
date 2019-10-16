package lib.charge {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import lib.DanNN.Network;
	import lib.DanNN.Neuron;
	
	public class SoldierRobot extends MovieClip {
		
		public var amIRed:Boolean;
		public var amICrouched:Boolean;
		public var amIFalling:Boolean;
		public var facingLeft:Boolean;
		
		private var direction:Boolean;
		public var health:Number;
		private var stopped:Boolean;
		private var maxLifeTime:Number;
		private var age:Number;
		public static var sChargeGame:ChargeGame;
		public var brain:Network;
		public var scoreBias:Number=0;
		
		private var shootCooldown:Number = 0;
		
		
		public function SoldierRobot(br:Network,red) {
			brain = br;
			age = 0;
			maxLifeTime = sChargeGame.currentMaxLifeTime;
			startWalk();
			direction = amIRed = red;
			amIFalling=true;
			health = 100;
		}
		
		public function startWalk()
		{
			Leg1.gotoAndPlay(11);
			Leg2.gotoAndPlay(20);
			stopped=false;
		}
		
		public function update():void
		{
			shootCooldown--;
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
			if(facingLeft)
				this.scaleX=-1.0;
			else
				this.scaleX=1.0;
			var isGrounded:Boolean = false;
			var crouchOffset = (amICrouched)?5:0;
			if(sChargeGame.getColorSample(this.x,this.y+96-crouchOffset))
			{
				y--;
				isGrounded=true;
				amIFalling=false;
			}
			else
			{
				y++;
				isGrounded=false;
				if(sChargeGame.getColorSample(this.x,this.y+97-crouchOffset))
				{
					amIFalling=true;
				}
			}
			//this was just for testing.
			//brain = brain.mutateAndReturnNewNetwork(0.1,0.01,0.01);
			
			
			brain.setSingleInput(0,(isGrounded)?1:0);
			brain.setSingleInput(1,sChargeGame.getAlliesNearbyClose(x,amIRed));
			brain.setSingleInput(2,sChargeGame.getAlliesNearby(x,amIRed));
			brain.setSingleInput(3,sChargeGame.getAlliesNearbyFar(x,amIRed));
			brain.setSingleInput(4,sChargeGame.getEnemiesNearbyClose(x,amIRed));
			brain.setSingleInput(5,sChargeGame.getDistanceRatioFromBlueBase(x,y));
			brain.setSingleInput(6,sChargeGame.getDistanceRatioFromRedBase(x,y));
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
			amICrouched=false;
			//trace(leftBias+" "+rightBias);
			if(leftBias>0.5)
			{
				if(isGrounded)
				{
					x+=0.6;
					Leg1.play();
					Leg2.play();
				}
				facingLeft = true;
			}
			else if(rightBias>0.5)
			{
				if(isGrounded)
				{
					x-=0.6;
					Leg1.play();
					Leg2.play();
				}
				facingLeft = false;
			}
			else if(shootBias>0.5)
			{
				if(shootCooldown<0)
				{
					shootCooldown = 5;
					var bullet:Bullet = new Bullet();
					bullet.x=this.x;
					bullet.y=this.y;
					bullet.velX = -Math.cos(ChargeGame.radFromDeg(aimAngle))*10.0;
					bullet.velY = -Math.sin(ChargeGame.radFromDeg(aimAngle))*10.0;
					bullet.width=32;
					bullet.height=32;
					bullet.rotation=aimAngle+90;
					bullet.myRobot = this;
					bullet.amIRed=this.amIRed;
					this.parent.addChild(bullet);
					//trace("Bullet shot! "+bullet.x+" "+bullet.y+" "+bullet.velX+" "+bullet.velY);
				}
			}
			else if(crouchBias>0.5)
			{
				Leg1.gotoAndStop(28);
				Leg2.gotoAndStop(28);
				amICrouched=true;
				stopped=true;
			}
			this.Gun.rotation = aimAngle;
			//trace(age+" "+maxLifeTime);
			if(age++>maxLifeTime||y>sChargeGame.stage.height)
				killMeAndSaveMyBrain();
			
			
			if(x<32)
				x=32;
			if(x>1024-32)
				x=1024-32;
			if(y>sChargeGame.height)
				trace(x+" "+y);
			
			
			if(health<0)
			{
				trace("Killed by hostile action.");
				killMeAndSaveMyBrain();
			}
		}
		
		public function killMeAndSaveMyBrain():void
		{
			//trace("Killing...");
			var score:Number = brain.score;
			if(amIRed)
			{
				brain.score=score=sChargeGame.getDistanceRatioFromBlueBase(x,y)+scoreBias;
				sChargeGame.addRedNetwork(brain);				
				this.parent.removeChild(this);				
				sChargeGame.allSoldiers.splice(sChargeGame.allSoldiers.indexOf(this),1);
				
			}
			else
			{	
				brain.score=score=sChargeGame.getDistanceRatioFromRedBase(x,y)+scoreBias;
				sChargeGame.addBlueNetwork(brain);				
				this.parent.removeChild(this);
				sChargeGame.allSoldiers.splice(sChargeGame.allSoldiers.indexOf(this),1);
			}
			
		}
		
		public function setDir(newDir:Boolean):void
		{
			direction = newDir;
			gotoAndStop(5);
		}
		
		
		
	
	}
	
	
	

}
