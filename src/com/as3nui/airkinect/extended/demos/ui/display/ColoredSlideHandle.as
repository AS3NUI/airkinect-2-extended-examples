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
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.components.SlideHandle;

	import flash.display.Shape;

	public class ColoredSlideHandle extends SlideHandle {
		protected var _color:uint;
		protected var _radius:uint;

		public function ColoredSlideHandle(color:uint, radius:uint = 20, direction:String = SlideHandle.LEFT) {
			_color = color;
			_radius = radius;

			var circle:Shape = new Shape();
			circle.graphics.beginFill(_color);
			circle.graphics.drawCircle(_radius,_radius,_radius);

			var selectedCircle:Shape = new Shape();
			selectedCircle.graphics.beginFill(0x0000ff);
			selectedCircle.graphics.drawCircle(_radius,_radius,_radius);

			var disabledIcon:Shape = new Shape();
			disabledIcon.graphics.beginFill(0xeeeeee);
			disabledIcon.graphics.drawCircle(_radius,_radius,_radius);

			var track:Shape = new Shape();
			track.graphics.beginFill(0x0000ff, .5);

			switch(direction){
				case SlideHandle.RIGHT:
					track.graphics.drawRect(0,0, 300, _radius*2);
					break;
				case SlideHandle.LEFT:
					track.graphics.drawRect(0, 0, -300, _radius*2);
					break;
				case SlideHandle.UP:
					track.graphics.drawRect(0,0, _radius*2, -300);
					break;
				case SlideHandle.DOWN:
					track.graphics.drawRect(0,0, _radius*2, 300);
					break;

			}
			super(circle, track, null, disabledIcon, direction);
		}
	}
}