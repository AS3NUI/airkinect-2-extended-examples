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
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.components.RepeatingSelectableHandle;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.components.Target;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.events.UIEvent;
	import com.greensock.TweenLite;

	import flash.display.Sprite;

	public class UIRepeatHandleDemo extends BaseUIDemo {
		private var _gallery:Sprite;

		//Gallery
		private var _totalSections:uint;

		private var _totalSectionSize:Number;
		private var _currentSectionIndex:int;
		private var _sectionPadding:Number;

		//Handles
		private var _leftHandle:RepeatingSelectableHandle;
		private var _rightHandle:RepeatingSelectableHandle;

		public function UIRepeatHandleDemo() {
		}

		override protected function startDemoImplementation():void {
			super.startDemoImplementation();
			createGallery();
			createHotSpots();
		}


		override protected function stopDemoImplementation():void {
			super.stopDemoImplementation();
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
			_totalSections = 15;
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

		private function createHotSpots():void {
			function getHotSpotGraphic():Sprite {
				var s:Sprite = new Sprite();
				s.graphics.beginFill(Math.random() * 0xffffff);
				s.graphics.drawRect(0, 0, 100, 50);
				return s;
			}

			_leftHandle = new RepeatingSelectableHandle(getHotSpotGraphic(), new SimpleSelectionTimer(), new SimpleSelectionTimer(0x00ff00));
			_leftHandle.addEventListener(UIEvent.SELECTED, onLeftSelected, false, 0, true);

			_rightHandle = new RepeatingSelectableHandle(getHotSpotGraphic(), new SimpleSelectionTimer(), new SimpleSelectionTimer(0x00ff00));
			_rightHandle.addEventListener(UIEvent.SELECTED, onRightSelected, false, 0, true);

			_leftHandle.x = 30;
			_leftHandle.y = 30;

			_rightHandle.x = 870;
			_rightHandle.y = 30;


			this.addChild(_leftHandle);
			this.addChild(_rightHandle);
		}

		private function onLeftSelected(event:UIEvent):void {
			_currentSectionIndex--;
			changeSections();
		}

		private function onRightSelected(event:UIEvent):void {
			_currentSectionIndex++;
			changeSections();
		}

		private function changeSections():void {
			TweenLite.to(_gallery, 1, {x:-_currentSectionIndex * (_totalSectionSize + _sectionPadding)});
			updateHandles();
		}

		private function updateHandles():void {

			//Right Handle
			if (_currentSectionIndex >= (_totalSections - 1)) {
				_rightHandle.enabled = false;
			} else if (!_rightHandle.enabled) {
				_rightHandle.enabled = true;
			}
			_rightHandle.alpha = _rightHandle.enabled ? 1 : .5;


			//Left Handle
			if (_currentSectionIndex <= 0) {
				_leftHandle.enabled = false;
			} else if (!_leftHandle.enabled) {
				_leftHandle.enabled = true;
			}

			_leftHandle.alpha = _leftHandle.enabled ? 1 : .5;
		}
	}
}