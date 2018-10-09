package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class IntroAnimation extends MovieClip {
		
		private var currentNetwork:Network;
		private var lastNetwork:Network;
		private var inputTestString:String = "TEST_INPUT ";
		private var outputTestString:String = "TEST_OUTPUT";
		private var trainingSpeed:Number = 1;
		public function IntroAnimation() 
		{
			trace("intro starting");
			
			currentNetwork = new Network(6,10);
			lastNetwork = new Network(6,10);
			
			for(var i:Number = 0; i<1; i+=(1.0/25.9))
			{
				trace(convertToLetter(i)+" "+convertToLetter(convertToNumber(convertToLetter(i))));
			}
			addEventListener(Event.ENTER_FRAME, doTick);
		}
		
		private function doTick(evt:Event)
		{
			for(var ticks:int; ticks<1000; ticks++)
			{
				if(currentNetwork.score>lastNetwork.score)
					lastNetwork=currentNetwork;
				
				currentNetwork = lastNetwork.mutateAndReturnNewNetwork(Math.random()*0.1*trainingSpeed,Math.random()*0.01*trainingSpeed,Math.random()*0.01*trainingSpeed);
				
				for(var i:int=0; i<10; i++)
					currentNetwork.setSingleInput(i,convertToNumber(inputTestString.charAt(i)));
				
				currentNetwork.tickNetwork();
				currentNetwork.score=260;
				trainingSpeed = 0.1;
				var outs:String = "";
				for(var i:int=0; i<10; i++)
				{
					trainingSpeed += Math.abs(currentNetwork.getSingleOutput(i)-convertToNumber(outputTestString.charAt(i)))
					currentNetwork.score-=Math.abs(currentNetwork.getSingleOutput(i)-convertToNumber(outputTestString.charAt(i)));
					if(convertToLetter(currentNetwork.getSingleOutput(i)).match(outputTestString.charAt(i)))
						currentNetwork.score+=10;
					outs+=convertToLetter(currentNetwork.getSingleOutput(i));
					
				}
				trace(outs);
			}
			
			
		}
		
		private function convertToLetter(number:Number):String
		{
			
			return String.fromCharCode(65+Math.floor(26.0*number));
		}

		private function convertToNumber(str:String):Number
		{
			return (str.charCodeAt(0)-65)/26.0;
		}
	}
	
}
