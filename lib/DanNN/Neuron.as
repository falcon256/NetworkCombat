package lib.DanNN {
	
	public class Neuron {

		public var isSigmoid:Boolean;
		public var isReLu:Boolean;
		public var isTanh:Boolean;	
		public var childNeurons:Array;
		public var childWeights:Array;
		public var childBiases:Array;		
		public var isLeaf:Boolean;	
		public var value:Number;		
		
		public function Neuron(children:Array)
		{
			value=0;
			childNeurons = new Array();
			childWeights = new Array();
			childBiases = new Array();
			
			if(children!=null)
			{
				for(var i:int = 0; i < children.length; i++){
					childNeurons[i]=children[i];
					childWeights[i]=0;
					childBiases[i]=0;
				}
			}
			else
			{
				isLeaf = true;
			}
		}
		
		public function setChildNeurons(arr:Array):void
		{
			childNeurons = arr;
			for (var i:int = 0; i<childNeurons.length; i++) {
				childWeights[i]=0;
				childBiases[i]=0;
			}
		}
		
		public function mutateNeuron(w:Number, b:Number):void
		{
			for (var i:int = 0; i<childNeurons.length; i++)
			{
				childWeights[i]+=randPosNeg()*w;
				childBiases[i]+=randPosNeg()*b;
			}
		}
		
		public function randPosNeg():Number
		{
			return Math.random()-Math.random();
		}
		
		public function Tick()
		{
			for(var i:int = 0; i < childNeurons.length; i++){
				var node:Neuron = childNeurons[i];
				node.value+=activateTanh((value*childWeights[i])+childBiases[i]);
			}
		}
		
		//the web says tanh(x) = 1-2/(1+exp(2*x)) = (exp(2*x)-1)/(exp(2*x)+1)
		public function activateTanh(n:Number):Number
		{
			return (Math.exp(2*n)-1)/(Math.exp(2*n)+1);
		}
	}
	
}
