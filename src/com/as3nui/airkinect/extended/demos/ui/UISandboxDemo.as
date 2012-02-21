/*
 * Copyright (c) 2012 AS3NUI
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is furnished to
 * do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package com.as3nui.airkinect.extended.demos.ui {
	import com.as3nui.airkinect.extended.demos.ui.display.ColoredCrankHandle;
	import com.as3nui.airkinect.extended.demos.ui.display.ColoredHandle;
	import com.as3nui.airkinect.extended.demos.ui.display.ColoredSlideHandle;
	import com.as3nui.airkinect.extended.demos.ui.display.ColoredTarget;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.components.Handle;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.components.SlideHandle;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.events.UIEvent;

	import flash.display.Sprite;
	import flash.text.TextField;

	public class UISandboxDemo extends BaseUIDemo {

		private var _container:Sprite;

		private var _info:TextField;
		private var _slideOutput:TextField;

		public function UISandboxDemo() {
			_container = new Sprite();
			this.addChild(_container);
		}

		override protected function startDemoImplementation():void {
			super.startDemoImplementation();
			createHandles();
			createSlideHandles();
			createTargets();
			createCrankHandles();
		}

		override protected function stopDemoImplementation():void {
			super.stopDemoImplementation();
			this.removeChildren();
		}

		private function createCrankHandles():void {
			var crankHandle:ColoredCrankHandle = new ColoredCrankHandle();
			crankHandle.x = 300;
			crankHandle.y = 300;
			this.addChild(crankHandle);

			crankHandle.addEventListener(UIEvent.MOVE, onCrankMove, false, 0, true);
			crankHandle.showCaptureArea();
			crankHandle.drawDebug = true;
		}

		private function createTargets():void {
			var target:ColoredTarget = new ColoredTarget();
			target.x = 10;
			target.y = 300;
			this.addChild(target);
		}

		private function createSlideHandles():void {
			var leftSlideHandle:ColoredSlideHandle = new ColoredSlideHandle(0x00ff00, 30, SlideHandle.LEFT);
			leftSlideHandle.x = 600;
			leftSlideHandle.y = 300;
			this.addChild(leftSlideHandle);
			leftSlideHandle.addEventListener(UIEvent.SELECTED, onLeftSlideSelected, false, 0, true);
//			leftSlideHandle.showCaptureArea();

			var rightSlideHandle:ColoredSlideHandle = new ColoredSlideHandle(0x00ff00, 30, SlideHandle.RIGHT);
			rightSlideHandle.x = 600;
			rightSlideHandle.y = 500;
			rightSlideHandle.addEventListener(UIEvent.SELECTED, onRightSlideSelected, false, 0, true);
			this.addChild(rightSlideHandle);
//			rightSlideHandle.showCaptureArea();

			_slideOutput = new TextField();
			_slideOutput.text = "Slide to change";
			_slideOutput.x = 600;
			_slideOutput.y = 400;
			this.addChild(_slideOutput);

		}

		private function createHandles():void {
			_info = new TextField();
			_info.y = 50;
			this.addChild(_info);

			var handle:Handle;
			var spacing:uint = 100;
			var totalHandles:int = 10;

			for (var i:uint = 0; i < totalHandles; i++) {
				handle = new ColoredHandle(Math.random() * 0xffffff, totalHandles + Math.round(Math.random() * 30));
				handle.x = 50+ (i * spacing);
				handle.y = 100;

				_container.addChild(handle);
				handle.addEventListener(UIEvent.SELECTED, onHandleSelected, false, 0, true);
				//handle.showCaptureArea();
			}
		}

		private function onCrankMove(event:UIEvent):void {
			trace(event.value * (180/Math.PI));
		}

		private function onRightSlideSelected(event:UIEvent):void {
			_slideOutput.text = "Right Slide";
		}

		private function onLeftSlideSelected(event:UIEvent):void {
			_slideOutput.text = "Left Slide";
		}

		private function onHandleSelected(event:UIEvent):void {
			_info.text = event.currentTarget.name + " Selected";
		}
	}
}