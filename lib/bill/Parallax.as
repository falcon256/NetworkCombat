package lib.bill
{
	import flash.display.MovieClip;
	
	public class Parallax extends MovieClip
	{
		public var easing:Number;
		
		public function Parallax()
		{
			easing = 0.2;
		}
		
		public function update():void
		{
			var i:int;
			for (i = 0; i < numChildren; i++)
			{
				var child:MovieClip = MovieClip(getChildAt(i));
				
				if (child.x < stage.stageWidth - child.width)
				{
					child.x = stage.stageWidth - child.width;
				}
				else if (child.x > 0)
				{
					child.x = 0;
				}
				
				var tarX:Number = stage.mouseX - x;
				if (tarX < 0)
				{
					tarX = 0;
				}
				else if (tarX > stage.stageWidth)
				{
					tarX = stage.stageWidth;
				}
				child.x += ((tarX / stage.stageWidth) * (stage.stageWidth - child.width) - child.x) * easing;
				
				if (child.y < stage.stageHeight - child.height)
				{
					child.y = stage.stageHeight - child.height;
				}
				else if (child.y > 0)
				{
					child.y = 0;
				}
				
				var tarY:Number = stage.mouseY - y;
				if (tarY < 0)
				{
					tarY = 0;
				}
				else if (tarY > stage.stageWidth)
				{
					tarY = stage.stageWidth;
				}
				child.y += ((tarY / stage.stageHeight) * (stage.stageHeight - child.height) - child.y) * easing;
			}
		}
	}
}