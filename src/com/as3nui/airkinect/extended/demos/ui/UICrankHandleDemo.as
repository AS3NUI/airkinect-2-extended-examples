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
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.events.UIEvent;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class UICrankHandleDemo extends BaseUIDemo {

		//Image Stuff
		[Embed(source="/../assets/embeded/images/monkey.jpg")]
		private var MonkeyImage:Class;

		//Handles
		private var _container:Sprite;
		private var _originalScale:Number;

		public function UICrankHandleDemo() { }

		override protected function startDemoImplementation():void {
			super.startDemoImplementation();
			_container = new Sprite();
			this.addChild(_container);
			this.addChild(rgbBitmap);

			var image:Bitmap = new MonkeyImage() as Bitmap;
			image.x -= image.width / 2;
			image.y -= image.height / 2;
			_container.addChild(image);

			_container.x = stage.stageWidth / 2;
			_container.y = stage.stageHeight / 2;
			_container.scaleX = _container.scaleY = .5;

			createHandles();
		}

		override protected function stopDemoImplementation():void {
			super.stopDemoImplementation();
			this.removeChildren();
		}

		private function createHandles():void {
			var crankHandle:ColoredCrankHandle = new ColoredCrankHandle();
			crankHandle.x = 800;
			crankHandle.y = 300;
			this.addChild(crankHandle);

			crankHandle.addEventListener(UIEvent.CAPTURE, onCrankCapture, false, 0, true);
			crankHandle.addEventListener(UIEvent.MOVE, onCrankMove, false, 0, true);
			//crankHandle.showCaptureArea();
			crankHandle.drawDebug = true;
		}

		private function onCrankCapture(event:UIEvent):void {
			_originalScale = _container.scaleX;
		}

		private function onCrankMove(event:UIEvent):void {
			var ratio:Number = event.value / (Math.PI * 2);
			//trace(event.value * (180/Math.PI));
			_container.scaleX = _container.scaleY = _originalScale + ratio;
		}
	}
}