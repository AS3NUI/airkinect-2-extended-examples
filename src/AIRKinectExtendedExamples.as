package
{
	import com.as3nui.airkinect.extended.demos.core.DemoBase;
	import com.as3nui.airkinect.extended.demos.pointcloud.PointCloudWriterDemo;
	import com.as3nui.airkinect.extended.demos.simulator.SimulatorDemo;
	import com.as3nui.airkinect.extended.demos.simulator.SimulatorHelperDemo;
	import com.as3nui.airkinect.extended.demos.ui.UICrankHandleDemo;
	import com.as3nui.airkinect.extended.demos.ui.UIHandleDemo;
	import com.as3nui.airkinect.extended.demos.ui.UIHotSpotDemo;
	import com.as3nui.airkinect.extended.demos.ui.UIRepeatHandleDemo;
	import com.as3nui.airkinect.extended.demos.ui.UISandboxDemo;
	import com.as3nui.airkinect.extended.demos.ui.UISlideHandleDemo;
	import com.as3nui.airkinect.extended.demos.ui.UITargetDemo;
	import com.bit101.components.ComboBox;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF(frameRate="60", width="1024", height="768", backgroundColor="#FFFFFF")]
	public class AIRKinectExtendedExamples extends Sprite
	{
		
		public static const DEMO_CLASSES:Vector.<Object> = Vector.<Object>([
			{label: "UI Sandbox Demo", data: UISandboxDemo},
			{label: "UI Handle Demo", data: UIHandleDemo},
			{label: "UI SlideHandle Demo", data: UISlideHandleDemo},
			{label: "UI CrankHandle Demo", data: UICrankHandleDemo},
			{label: "UI TargetDemo", data: UITargetDemo},
			{label: "UI HotSpot Demo", data: UIHotSpotDemo},
			{label: "UI RepeatHandle Demo", data: UIRepeatHandleDemo},
			{label: "PointCloud Writer Demo", data: PointCloudWriterDemo},
			{label: "Simulator Demo", data: SimulatorDemo},
			{label: "Simulator Helper Demo", data: SimulatorHelperDemo}
		]);
		
		private var _currentDemoIndex:int = -1;
		public function get currentDemoIndex():int { return _currentDemoIndex; }
		
		public function set currentDemoIndex(value:int):void
		{
			if(value == -1) value = DEMO_CLASSES.length - 1;
			if(value >= DEMO_CLASSES.length) value = 0;
			if (_currentDemoIndex == value)
				return;
			_currentDemoIndex = value;
			currentDemoChanged();
		}
		
		public function set currentDemoClass(value:Class):void
		{
			for(var i:uint = 0; i < DEMO_CLASSES.length; i++)
			{
				if(DEMO_CLASSES[i].data == value)
				{
					this.currentDemoIndex = i;
					return;
				}
			}
		}
		
		private var currentDemo:DemoBase;
		
		private var demoBox:ComboBox;
		
		public function AIRKinectExtendedExamples()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.nativeWindow.visible = true;
			
			demoBox = new ComboBox(this, 10, 10);
			demoBox.setSize(200, demoBox.height);
			demoBox.addEventListener(Event.SELECT, demoSelectHandler, false, 0, true);
			
			for each(var demoItem:Object in DEMO_CLASSES)
			{
				demoBox.addItem(demoItem);
			}
			
			//start default demo
//			currentDemoClass = UISandboxDemo;

			currentDemoClass = SimulatorHelperDemo;

			stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
		}

		protected function demoSelectHandler(event:Event):void
		{
			currentDemoIndex = demoBox.selectedIndex;
		}
		
		private function currentDemoChanged():void
		{
			if(currentDemo != null)
			{
				removeChild(currentDemo);
			}
			demoBox.selectedIndex = _currentDemoIndex;
			currentDemo = new DEMO_CLASSES[_currentDemoIndex].data();
			addChildAt(currentDemo, 0);
			resizeHandler();
		}
		
		protected function resizeHandler(event:Event = null):void
		{
			if(currentDemo != null)
			{
				currentDemo.setSize(stage.stageWidth, stage.stageHeight);
			}
		}
	}
}