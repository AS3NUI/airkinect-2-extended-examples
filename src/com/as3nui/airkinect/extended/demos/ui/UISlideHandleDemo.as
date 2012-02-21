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
	import com.as3nui.airkinect.extended.demos.ui.display.ColoredSlideHandle;
	import com.as3nui.airkinect.extended.demos.ui.display.SimpleSelectionTimer;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.components.SlideHandle;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.components.Target;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.events.UIEvent;
	import com.greensock.TweenLite;

	import flash.display.Sprite;

	public class UISlideHandleDemo extends BaseUIDemo {
		private var _gallery:Sprite;

		//Gallery
		private var _totalSections:uint;

		private var _totalSectionSize:Number;
		private var _currentSectionIndex:int;
		private var _sectionPadding:Number;

		//Sliders
		private var _rightSlideHandle:ColoredSlideHandle;
		private var _leftSlideHandle:ColoredSlideHandle;

		public function UISlideHandleDemo() {
		}

		override protected function startDemoImplementation():void {
			super.startDemoImplementation();
			createGallery();
			createHandles();
		}

		override protected function stopDemoImplementation():void {
			super.stopDemoImplementation();
			_leftSlideHandle.removeEventListener(UIEvent.SELECTED, onLeftSlideSelected);
			_leftSlideHandle.removeEventListener(UIEvent.MOVE, onLeftMove);

			_rightSlideHandle.removeEventListener(UIEvent.SELECTED, onRightSlideSelected);
			_rightSlideHandle.removeEventListener(UIEvent.MOVE, onRightMove);

			this.removeChildren();
		}

		private function createGallery():void {
			_gallery = new Sprite();
			this.addChild(_gallery);

			function getBox():Sprite {
				var s:Sprite = new Sprite();
				s.graphics.beginFill(Math.random() * 0xffffff);
				s.graphics.drawRect(0, 0, 200, 200);
				return s;
			}

			var box:Sprite = getBox();
			_totalSections = 4;
			var totalRows:uint = 3;
			var totalColumns:int = 2;

			var rowSpacing:uint = 25;
			var colSpacing:uint = 25;
			_totalSectionSize = (totalRows * box.width) + (totalRows * rowSpacing);
			_sectionPadding = (stage.stageWidth - _totalSectionSize) / 2;

			var target:Target;
			for (var sectionIndex:uint = 0; sectionIndex < _totalSections; sectionIndex++) {
				for (var row:uint = 0; row < totalRows; row++) {
					for (var col:uint = 0; col < totalColumns; col++) {
						box = getBox();
						target = new Target(box, new SimpleSelectionTimer());
						target.x += ((sectionIndex + 1) * _sectionPadding);
						target.x += ((sectionIndex * totalRows) * box.width);
						target.x += ((sectionIndex * totalRows) * rowSpacing);
						target.x += (row * box.width);
						target.x += (row * rowSpacing);
						target.y = col * (box.height + colSpacing);
						_gallery.addChild(target);
					}
				}
			}

			_currentSectionIndex = Math.floor(_totalSections / 2);
			_gallery.x = -_currentSectionIndex * (_totalSectionSize + _sectionPadding);
			_gallery.y = (stage.stageHeight / 2) - (_gallery.height / 2);
		}

		private function createHandles():void {
			_leftSlideHandle = new ColoredSlideHandle(0x00ff00, 30, SlideHandle.LEFT);
			this.addChild(_leftSlideHandle);
			_leftSlideHandle.x = 930;
			_leftSlideHandle.y = (stage.stageHeight / 2) - 30;
			_leftSlideHandle.addEventListener(UIEvent.SELECTED, onLeftSlideSelected, false, 0, true);
			_leftSlideHandle.addEventListener(UIEvent.MOVE, onLeftMove, false, 0, true);
//			_leftSlideHandle.showCaptureArea();

			_rightSlideHandle = new ColoredSlideHandle(0x00ff00, 30, SlideHandle.RIGHT);
			_rightSlideHandle.x = 10;
			_rightSlideHandle.y = _leftSlideHandle.y;
			_rightSlideHandle.addEventListener(UIEvent.SELECTED, onRightSlideSelected, false, 0, true);
			_rightSlideHandle.addEventListener(UIEvent.MOVE, onRightMove, false, 0, true);
			this.addChild(_rightSlideHandle);
//			_rightSlideHandle.showCaptureArea();
		}

		private function onRightMove(event:UIEvent):void {
			if (_currentSectionIndex <= 0) return;
			var originalX:Number = -_currentSectionIndex * (_totalSectionSize + _sectionPadding);
			var destinationX:Number = originalX + (event.value * ((_totalSectionSize + _sectionPadding) / 2));
			TweenLite.to(_gallery, .3, {x:destinationX});
		}

		private function onLeftMove(event:UIEvent):void {
			if (_currentSectionIndex >= (_totalSections - 1)) return;
			var originalX:Number = -_currentSectionIndex * (_totalSectionSize + _sectionPadding);
			var destinationX:Number = originalX - (event.value * ((_totalSectionSize + _sectionPadding) / 2));
			TweenLite.to(_gallery, .3, {x:destinationX});
		}

		private function onRightSlideSelected(event:UIEvent):void {
			if (_currentSectionIndex <= 0) return;
			_currentSectionIndex--;
			TweenLite.to(_gallery, 1, {x:-_currentSectionIndex * (_totalSectionSize + _sectionPadding)});
			updateSliders();
		}


		private function onLeftSlideSelected(event:UIEvent):void {
			if (_currentSectionIndex >= (_totalSections - 1)) return;
			_currentSectionIndex++;
			TweenLite.to(_gallery, 1, {x:-_currentSectionIndex * (_totalSectionSize + _sectionPadding)});
			updateSliders();
		}

		private function updateSliders():void {
			if (_currentSectionIndex >= (_totalSections - 1)) {
				_leftSlideHandle.enabled = false;
			} else if (!_leftSlideHandle.enabled) {
				_leftSlideHandle.enabled = true;
			}

			if (_currentSectionIndex <= 0) {
				_rightSlideHandle.enabled = false;
			} else if (!_rightSlideHandle.enabled) {
				_rightSlideHandle.enabled = true;
			}
		}
	}
}