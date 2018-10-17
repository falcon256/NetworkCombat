package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.text.TextFormat;
	import fl.motion.Color;
	import lib.DanNN.Network;
	import lib.DanNN.Neuron;
	
	public class IntroAnimation extends MovieClip {
		
		private var currentNetwork:Network;
		private var lastNetwork:Network;
		private var inputTestString:String =  "TEST@INPUT@@@@@@";
		private var outputTestString:String = "TEST@OUTPUT@GOOD";
		private var trainingSpeed:Number = 1;
		private var posColor:uint = 0x0099FF;
		private var negColor:uint = 0xFF4444;
		private var xMulti:int = 48;
		private var yMulti:int = 64;
		private var xOffset:Number=100;
		private var yOffset:Number=100;
		private var averageFrameRate:Number = 1;
		private var startTime:Number=0;
		private var framesNumber:Number = 0;
		public function disable()
		{
			removeEventListener(Event.ENTER_FRAME, doTick);
		}
		public function IntroAnimation() 
		{
			trace("intro starting");
			startTime = getTimer();
			currentNetwork = new Network(6,16);
			lastNetwork = new Network(6,16);
			
			for(var i:Number = 0; i<1; i+=(1.0/25.9))
			{
				trace(convertToLetter(i)+" "+convertToLetter(convertToNumber(convertToLetter(i))));
			}
			addEventListener(Event.ENTER_FRAME, doTick);

		}
		
		private function doTick(evt:Event)
		{
			framesNumber++;
			var currentTime:Number = (getTimer() - startTime) / 1000;
			var fps:Number = (Math.floor((framesNumber/currentTime)*10.0)/10.0);
			
			averageFrameRate+=fps*0.01;
			averageFrameRate*=0.998;
			this.graphics.clear(); 
			var outs:String = "";
			var i:int=0;
			for(var ticks:int; ticks<averageFrameRate; ticks++)
			{
				if(currentNetwork.score>lastNetwork.score)
					lastNetwork=currentNetwork;
				
				currentNetwork = lastNetwork.mutateAndReturnNewNetwork(Math.random()*0.001*trainingSpeed*sliderNeuronMutationChance.value,Math.random()*0.0001*trainingSpeed*sliderNeuronWeightDelta.value,Math.random()*0.0001*trainingSpeed*sliderNeuronBiasDelta.value);
				
				for(i = 0; i<16; i++)
					currentNetwork.setSingleInput(i,convertToNumber(inputTestString.charAt(i)));
				
				currentNetwork.tickNetwork();
				currentNetwork.score=0;
				trainingSpeed = sliderNeuronBiasDelta.value+sliderNeuronMutationChance.value+sliderNeuronWeightDelta.value;
				outs = "";
				for(i = 0; i<16; i++)
				{
					//trainingSpeed += Math.abs(currentNetwork.getSingleOutput(i)-convertToNumber(outputTestString.charAt(i)))
					currentNetwork.score-=Math.abs(currentNetwork.getSingleOutput(i)-(convertToNumber(outputTestString.charAt(i))+0.02))*3.0;
					if(convertToLetter(currentNetwork.getSingleOutput(i)).match(outputTestString.charAt(i)))
						currentNetwork.score+=10;
					outs+=convertToLetter(currentNetwork.getSingleOutput(i));
					
				}
				//trace(outs);
			}

			this.InputLabel.text = inputTestString.replace(/@/g, " "); 
			this.OutputLabel.text = outs.replace(/@/g, " "); 
			var myTextFormat:TextFormat = new TextFormat();
			myTextFormat.size = 20
			//myTextFormat.color = 0xFFFFFF;
			//score.PlayerScore.setStyle("textFormat", myTextFormat);
			var maxAbsValue:Number = 0;
			myTextFormat.size = 20
			this.InputLabel.setStyle("textFormat", myTextFormat);
			this.OutputLabel.setStyle("textFormat", myTextFormat);
			
			for(var iy:int=0; iy <currentNetwork.getAllNodes().length;iy++)
			{
				for(var ix:int=0; ix<currentNetwork.getAllNodes()[iy].length;ix++)
				{
					if(maxAbsValue<Math.abs(currentNetwork.getAllNodes()[iy][ix].value))
						maxAbsValue=Math.abs(currentNetwork.getAllNodes()[iy][ix].value);
				}
			}
			
			
			for(iy=0; iy <currentNetwork.getAllNodes().length;iy++)
			{
				for(ix=0; ix<currentNetwork.getAllNodes()[iy].length;ix++)
				{
					var fill:int = Math.abs((currentNetwork.getAllNodes()[iy][ix].value/maxAbsValue)*255.0);
					this.graphics.beginFill(fill<<16 + fill<<8 + fill);
					this.graphics.lineStyle(4, posColor, .75);
					this.graphics.drawCircle(ix*xMulti+xOffset,iy*yMulti+yOffset,10);
					this.graphics.endFill();
					
				}
			}	
			
			for(iy=0; iy <currentNetwork.getAllNodes().length-1;iy++)
			{
				for(ix=0; ix<currentNetwork.getAllNodes()[iy].length;ix++)
				{
					this.graphics.lineStyle(4, posColor, .75);
					var nx:int = findHighestWeight(currentNetwork.getAllNodes()[iy][ix])
					this.graphics.moveTo(ix*xMulti+xOffset, iy*yMulti+yOffset);
					this.graphics.lineTo(nx*xMulti+xOffset, (iy+1)*yMulti+yOffset);
					this.graphics.lineStyle(4, negColor, .75);
					nx = findLowestWeight(currentNetwork.getAllNodes()[iy][ix])
					this.graphics.moveTo(ix*xMulti+xOffset, iy*yMulti+yOffset);
					this.graphics.lineTo(nx*xMulti+xOffset, (iy+1)*yMulti+yOffset);
				}
			}
			
					
			
			drawTrainingSpeedBar(trainingSpeed);
			drawScoreBar(Math.max(currentNetwork.score,lastNetwork.score));
		}
		
		private function drawTrainingSpeedBar(num:Number)
		{
			this.graphics.lineStyle(xMulti, negColor, 1.0);
			this.graphics.moveTo(xMulti*currentNetwork.getAllNodes()[0].length+xOffset,yMulti*currentNetwork.getAllNodes().length+yOffset);
			this.graphics.lineTo(xMulti*currentNetwork.getAllNodes()[0].length+xOffset,yMulti*currentNetwork.getAllNodes().length+yOffset-(num*2.5));
		}
		
		private function drawScoreBar(num:Number)
		{
			this.graphics.lineStyle(xMulti, posColor, 1.0);
			this.graphics.moveTo(xMulti*(currentNetwork.getAllNodes()[0].length+1)+xOffset,yMulti*currentNetwork.getAllNodes().length+yOffset);
			this.graphics.lineTo(xMulti*(currentNetwork.getAllNodes()[0].length+1)+xOffset,yMulti*currentNetwork.getAllNodes().length+yOffset-(num*2));
		}
		
		private function convertToLetter(number:Number):String
		{
			
			return String.fromCharCode(65+Math.floor(26.0*number));
		}

		private function convertToNumber(str:String):Number
		{
			return (str.charCodeAt(0)-65)/26.0;
		}
		
		private function findLowestWeight(node:Neuron):int
		{
			var currentI:int = 0;
			var currentW:Number = 0;
			for(var i:int=0; i<node.childWeights.length; i++)
			{
				if(node.childWeights[i]<currentW)
				{
					currentI=i;
					currentW=node.childWeights[i];
				}
			}
			return currentI;
		}
		
		private function findHighestWeight(node:Neuron):int
		{
			var currentI:int = 0;
			var currentW:Number = 0;
			for(var i:int=0; i<node.childWeights.length; i++)
			{
				if(node.childWeights[i]>currentW)
				{
					currentI=i;
					currentW=node.childWeights[i];
				}
			}
			return currentI;
		}
	}
	
}
