package lib.charge
{
	import flash.display.MovieClip;
	
	public class Guy extends MovieClip
	{
		private var status:String;
		private var dir:String;
		
		private var health:Number;
		private var damage:Number;
		private var speed:Number;
		
		private var curFrame:Number;
		private var attackFrames:Number;
		private var hitFrame:Number;
		
		private var target:Guy;
		
		public var enemies:Array;
		public var friends:Array;
		
		public function Guy()
		{
			
			enemies = new Array();
			//set the defaul conditions for a generic guy
			dir = "Right";
			setStatus("Walk");
			
			curFrame = 0;
			attackFrames = 8;
			hitFrame = 5;
			
			//Randomize health, speed, and damage
			health = Math.ceil(Math.random() * 50 + 75);
			damage = Math.ceil(Math.random() * 10 + 5);
			speed = Math.random() * 2 + 2;
			
		}
		
		public function setDir(newDir:String):void
		{
			dir = newDir;
			gotoAndStop(status + dir);
		}
		
		public function setStatus(state:String):void
		{
			trace("Status = " + state);
			
			status = state;
			
			gotoAndStop(status + dir);
		}
		
		public function getStatus():String
		{
			return status;
		}
		
		public function attack():void
		{
			target.takeDamage(damage);
			
			if (target.getStatus() == "Die")
			{
				setStatus("Walk");
			}
			
			curFrame = 0;
		}
		
		public function takeDamage(amount:Number):void
		{
			trace("Took " + amount + " damage!");

			if (status != "Die")
			{
				health -= damage;
				if (health <= 0)
				{
					die();
				}
			}
		}
		
		public function die():void
		{
			setStatus("Die");
			trace("Died!");
			health = 0;
		}
		
		public function setTarget(newTarget:Guy):void
		{
			target = newTarget;
			setStatus("Fight");
		}
		
		private function lookForTarget():void
		{
			for each(var enemy:Guy in enemies)
			{
				if (enemy.getStatus() != "Die" && ((dir == "Left" && x < enemy.x) || (dir == "Right" && x > enemy.x)))
				{
					setTarget(enemy);
					break;
				}
			}
		}
		
		public function purge():void
		{
			var i:int;
					
			for (i = 0; i < friends.length; i++)
			{
				if (friends[i].name == name)
				{
					friends.splice(i, 1);
					i = friends.length;
				}
			}
			parent.removeChild(this);
		}
		
		public function update():void
		{
			if (status == "Die")
			{				
				health -= 1;
				if (health <= -60)
				{
					purge();
				}
				else if (health <= -30)
				{
					//blink
					if (alpha == 0)
					{
						alpha = 1;
					}
					else
					{
						alpha = 0;
					}
				}
			}
			else if (status == "Walk")
			{
				if (dir == "Right")
				{
					x += speed;
				}
				else
				{
					x -= speed;
				}
				
				lookForTarget();
			}
			else if (status == "Fight")
			{
				if (curFrame == hitFrame)
				{
					attack();
				}
				curFrame++;
			}
		}
	}
}