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
	import com.as3nui.airkinect.extended.demos.core.DemoBase;
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectConfig;
	import com.as3nui.nativeExtensions.air.kinect.constants.JointIndices;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.KinectEvent;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.helpers.MouseSimulator;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.managers.UIManager;
	import com.as3nui.nativeExtensions.air.kinect.extended.ui.objects.Cursor;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;

	public class BaseUIDemo extends DemoBase {
		protected var rgbBitmap:Bitmap;
		protected var kinect:Kinect;
		protected var _leftHandCursor:Cursor;

		public function BaseUIDemo() {
		}


		override protected function startDemoImplementation():void {
			super.startDemoImplementation();
			UIManager.init(stage);

			//MouseSimulator.init(stage);

			kinect = Kinect.getKinect();

			var config:KinectConfig = new KinectConfig();
			config.rgbEnabled = true;
			config.skeletonEnabled = true;

			kinect.addEventListener(KinectEvent.STARTED, kinectStartedHandler, false, 0, true);
			kinect.addEventListener(KinectEvent.STOPPED, kinectStoppedHandler, false, 0, true);
			kinect.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, rgbImageUpdateHandler, false, 0, true);

			kinect.start(config);

			initRGBCamera();
			createCursor();
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}

		override protected function stopDemoImplementation():void {
			super.stopDemoImplementation();
			UIManager.dispose();
			MouseSimulator.uninit();
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			rgbBitmap.bitmapData.dispose();
			rgbBitmap = null;

			kinect.stop();
			kinect.removeEventListener(KinectEvent.STARTED, kinectStartedHandler, false);
			kinect.removeEventListener(KinectEvent.STOPPED, kinectStoppedHandler, false);
			kinect.removeEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, rgbImageUpdateHandler);
		}

		protected function kinectStartedHandler(event:KinectEvent):void {

		}

		protected function kinectStoppedHandler(event:KinectEvent):void {

		}

		protected function initRGBCamera():void {
			rgbBitmap = new Bitmap(new BitmapData(640, 480));
			rgbBitmap.scaleX = rgbBitmap.scaleY = .25;
			this.addChild(rgbBitmap);
			rgbBitmap.y = stage.stageHeight - rgbBitmap.height;
		}

		protected function rgbImageUpdateHandler(event:CameraImageEvent):void {
			rgbBitmap.bitmapData = event.imageData;
		}

		private function createCursor():void {
			var circle:Shape = new Shape();
			circle.graphics.lineStyle(2, 0x000000);
			circle.graphics.beginFill(0x00ff00);
			circle.graphics.drawCircle(0, 0, 20);

			_leftHandCursor = new Cursor("_kinect_", JointIndices.LEFT_HAND, circle);
			UIManager.addCursor(_leftHandCursor);
			_leftHandCursor.enabled = false;
		}

		private function enterFrameHandler(event:Event):void {

			if(kinect.usersWithSkeleton.length >0){
				var user:User = kinect.usersWithSkeleton[0];
				var leftHand:SkeletonJoint = user.leftHand;

				var pad:Number = .3;

				_leftHandCursor.enabled = true;
				if(leftHand.positionRelative.x > pad || leftHand.positionRelative.x < -pad) _leftHandCursor.enabled = false;
				if(leftHand.positionRelative.y > pad && leftHand.positionRelative.y < -pad) _leftHandCursor.enabled = false;

				if(!_leftHandCursor.enabled) return;


				var xPos:Number = (leftHand.positionRelative.x + pad) / (pad*2);
				var yPos:Number = (-leftHand.positionRelative.y + pad) / (pad*2);
				_leftHandCursor.update(xPos,  yPos,  leftHand.position.z);
			}
		}

		override protected function layout():void {
			super.layout();
			root.transform.perspectiveProjection.projectionCenter = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
			if (rgbBitmap) rgbBitmap.y = stage.stageHeight - rgbBitmap.height;
		}
	}
}