package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.events.*;
	public class BeginInterfaceSym extends MovieClip {
		
		
		public function BeginInterfaceSym() {
			NPLSlider.addEventListener(SliderEvent.CHANGE,onChange);
			LPNSlider.addEventListener(SliderEvent.CHANGE,onChange);
			BuildNetworkStructure.addEventListener(MouseEvent.CLICK, buildNetwork);
			NPLOutLabel.text=NPLSlider.value.toString();
			LPNOutLabel.text=LPNSlider.value.toString();
		}
		
		
		public function onChange(evt:Event)
		{
			NPLOutLabel.text=NPLSlider.value.toString();
			LPNOutLabel.text=LPNSlider.value.toString();
		}
		
		function buildNetwork(event:MouseEvent)
		{
			BuildNetworkStructure.visible=false;
			NPLSlider.visible=NPLSlider.enabled=false;
			LPNSlider.visible=LPNSlider.enabled=false;
			//NPLOutLabel.visible=NPLOutLabel.enabled=false;
			//LPNOutLabel.visible=LPNOutLabel.enabled=false;
		}
		
	}
	
}
