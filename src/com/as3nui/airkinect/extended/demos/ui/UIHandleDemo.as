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
	import com.as3nui.airkinect.extended.demos.ui.display.SimpleSelectionTimer;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.components.Handle;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.components.SelectableHandle;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.events.UIEvent;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class UIHandleDemo extends BaseUIDemo {
		private var _container:Sprite;

		private var _info:TextField;

		//Image Stuff
		[Embed(source="/../assets/embeded/images/mel_idle.png")]
		private var IconIdle:Class;

		[Embed(source="/../assets/embeded/images/mel_selected.png")]
		private var IconSelected:Class;

		public function UIHandleDemo() {
			_container = new Sprite();
			this.addChild(_container);
		}

		override protected function startDemoImplementation():void {
			super.startDemoImplementation();
			createHandles();
		}

		override protected function stopDemoImplementation():void {
			super.stopDemoImplementation();
			this.removeChildren();
		}

		private function createHandles():void {
			_info = new TextField();
			_info.y = 20;
			this.addChild(_info);

			var handle:Handle = new SelectableHandle(new IconIdle() as Bitmap, new SimpleSelectionTimer(), new IconSelected() as Bitmap, null, 1, .1, .1, .3);
			_container.addChild(handle);

			handle.x = (stage.stageWidth / 2) - (handle.width / 2);
			handle.y = (stage.stageHeight / 2) - (handle.height / 2);
			handle.addEventListener(UIEvent.SELECTED, onHandleSelected);
			handle.showCaptureArea();
		}

		private function onHandleSelected(event:UIEvent):void {
			_info.text = event.currentTarget.name + " Selected";
		}
	}
}