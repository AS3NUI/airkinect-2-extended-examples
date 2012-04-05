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

package com.as3nui.airkinect.extended.demos.ui.display {
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.display.BaseTimerSprite;

	public class SimpleSelectionTimer extends BaseTimerSprite {
		private var _size:Number = 25;
		private var _color:uint;
		public function SimpleSelectionTimer(color:uint = 0xff0000) {
			_color = color;
			draw();
		}

		private function draw():void {
			this.graphics.clear();

			this.graphics.lineStyle(1);
			this.graphics.beginFill(0xffffff, .4);
			this.graphics.drawRect(-_size/2,-_size/2,_size, _size);

			this.graphics.lineStyle(0);
			this.graphics.beginFill(_color, 1);
			this.graphics.drawRect(-_size/2,_size/2, _size, -(_progress * _size));
		}

		override public function onProgress(progress:Number):void {
			super.onProgress(progress);
			draw();
		}
	}
}