package lib.DanNN {
	import lib.DanNN.Neuron;
	public class Network {

		private var allNodes:Array;
		public var score:Number;
		public function Network(layers:int, nodes:int) {
			score=0;
			allNodes = new Array();
			var layerN:int;
			var nodeN:int;
			for(layerN = 0; layerN < layers; layerN++)
			{
				allNodes[layerN] = new Array();
				for(nodeN = 0; nodeN<nodes; nodeN++)
				{
					allNodes[layerN][nodeN] = new Neuron(null);
				}
			}
			for(layerN = layers-2; layerN >= 0; layerN--)
			{
				for(nodeN = 0; nodeN<nodes; nodeN++)
				{
					var n:Neuron = allNodes[layerN][nodeN];
					n.setChildNeurons(allNodes[layerN+1]);
				}
			}
		}
	
		
		public function setSingleInput(index:int, value:Number)
		{
			var n:Neuron = allNodes[0][index];
			n.value = value;
		}

		public function getSingleOutput(index:int):Number
		{
			var n:Neuron = allNodes[allNodes.length-1][index];
			return n.value;
		}
		
		public function tickNetwork():void
		{
			for(var x:Number = 0; x < allNodes.length; x++)
			{
				for(var y:Number = 0; y < allNodes[x].length; y++)
				{	
					var ne:Neuron = allNodes[x][y];
					ne.Tick();
				}
			}
		}
		
		public function mutateAndReturnNewNetwork(chanceOfMutation:Number, weightDelta:Number, biasDelta:Number ):Network
		{
			var layerN:int = allNodes.length;
			var oneLayer:Array = allNodes[0];
			var nodeN:int = oneLayer.length;
			var nodeX:int = 0;
			var newNet:Network = new Network(layerN,nodeN);
			for(layerN = 0; layerN < allNodes.length; layerN++)
			{
				var layer:Array = allNodes[layerN];
				for(nodeN = 0; nodeN<layer.length; nodeN++)
				{
					
					var n1:Neuron = allNodes[layerN][nodeN];
					var n2:Neuron = newNet.allNodes[layerN][nodeN];
					//trace(layerN+" "+nodeN+" "+n2.childNeurons.length);
					for(nodeX = 0; nodeX < layer.length; nodeX++)
					{
						
						n2.childWeights[nodeX] = n1.childWeights[nodeX];
						n2.childBiases[nodeX] = n1.childBiases[nodeX];
					}
					if(Math.random()>1.0-chanceOfMutation)
					{
						n2.mutateNeuron(weightDelta, biasDelta);
					}
				}
			}
			return newNet;
		}
		
		public function getAllNodes():Array
		{
			return this.allNodes;
		}
	}
	
}
