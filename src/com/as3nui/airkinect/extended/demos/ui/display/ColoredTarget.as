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
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.components.Target;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.events.CursorEvent;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class ColoredTarget extends Target {
		private var _frontIcon:Sprite;
		private var _dsf:DropShadowFilter = new DropShadowFilter();


		public function ColoredTarget(color:uint = 0x00ff00) {
			var rectangle:Shape = new Shape();
			rectangle.graphics.beginFill(color);
			rectangle.graphics.drawRect(0,0,100,100);

			var simpleSelectionTimer:SimpleSelectionTimer = new SimpleSelectionTimer(0x0000ff);
			super(rectangle,  simpleSelectionTimer, null, 4);

			_frontIcon = new Sprite();
			_frontIcon.graphics.beginFill(0xff0000);
			_frontIcon.graphics.drawRect(0,0,50,50);
			_frontIcon.x = 25;
			_frontIcon.y = 25;
		}


		override protected function onAddedToStage():void {
			super.onAddedToStage();
			this.addChild(_frontIcon)
		}


		override protected function onRemovedFromStage():void {
			super.onRemovedFromStage();
			if(this.contains(_frontIcon)) this.removeChild(_frontIcon)
		}


		override protected function onCursorOver(event:CursorEvent):void {
			super.onCursorOver(event);
			_frontIcon.z = 1;
			_frontIcon.filters = [_dsf];

			var pp:PerspectiveProjection=new PerspectiveProjection();
			pp.fieldOfView=35;
			pp.projectionCenter=new Point(0,0);
			_frontIcon.transform.perspectiveProjection=pp;
		}

		override protected function onSelected():void {
			super.onSelected();
			resetFrontIcon();
		}

		override protected function onCursorOut(event:CursorEvent):void {
			super.onCursorOut(event);
			resetFrontIcon();
		}

		private function resetFrontIcon():void {
			_frontIcon.transform.matrix3D = null;
			_frontIcon.filters = [];
			_frontIcon.x = 25;
			_frontIcon.y = 25;
		}

		override protected function onCursorMove(event:CursorEvent):void {
			super.onCursorMove(event);
			var xRatio:Number = event.localX/this.width;
			xRatio -= .5;
			xRatio *= 2;
			
			var yRatio:Number = event.localY/this.height;
			yRatio -= .5;
			yRatio *= 2;

			var xRotationDiff:Number = -(xRatio * 20) - _frontIcon.rotationY;
			var yRotationDiff:Number = (yRatio * 10) - _frontIcon.rotationX;

			_frontIcon.transform.matrix3D.appendTranslation(-25,-25,0);
 			_frontIcon.transform.matrix3D.appendRotation(xRotationDiff, Vector3D.Y_AXIS);
 			_frontIcon.transform.matrix3D.appendRotation(yRotationDiff, Vector3D.X_AXIS);
 			_frontIcon.transform.matrix3D.appendTranslation(25,25,0);

			_dsf.distance = -xRatio * 20;
			_dsf.blurX = _dsf.blurY = 40;
			_dsf.strength = .7;
			_dsf.angle = 0;
			_frontIcon.filters = [_dsf];
		}
	}
}