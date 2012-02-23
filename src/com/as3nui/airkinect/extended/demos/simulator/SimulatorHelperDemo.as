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

package com.as3nui.airkinect.extended.demos.simulator {
	import com.as3nui.airkinect.extended.demos.core.DemoBase;
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.extended.simulator.helpers.SkeletonSimulatorHelper;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class SimulatorHelperDemo extends DemoBase {
		protected const KinectMaxDepthInFlash:Number = 200;

		protected var rgbBitmap:Bitmap;
		protected var _skeletonContainer:Sprite;
		protected var _device:Kinect;

		public function SimulatorHelperDemo() { }

		override protected function startDemoImplementation():void {
			super.startDemoImplementation();
			_device = Kinect.getDevice();

			var setting:KinectSettings = new KinectSettings();
			setting.skeletonEnabled = true;
			setting.rgbEnabled = true;
			setting.rgbResolution = CameraResolution.RESOLUTION_320_240;

			_device.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, rgbImageUpdateHandler, false, 0, true);
			_device.start(setting);

			initRGBCamera();
			initDemo();
		}

		override protected function stopDemoImplementation():void {
			super.stopDemoImplementation();
			this.removeChildren();
			rgbBitmap.bitmapData.dispose();
			rgbBitmap = null;
			_device.stop();
			_device.removeEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, rgbImageUpdateHandler);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
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

		override protected function layout():void {
			super.layout();
			root.transform.perspectiveProjection.projectionCenter = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
			rgbBitmap.y = stage.stageHeight - rgbBitmap.height;
		}

		protected function initDemo():void {
			SkeletonSimulatorHelper.init(stage, _device);

			_skeletonContainer = new Sprite();
			this.addChild(_skeletonContainer);

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		//Enterframe
		protected function onEnterFrame(event:Event):void {
			drawSkeletons();
		}

		protected function drawSkeletons():void {
			_skeletonContainer.removeChildren();

			for each(var user:User in _device.users)
			{
				if(user.hasSkeleton)
				{
					for each(var joint:SkeletonJoint in user.skeletonJoints)
					{
						if(joint.positionConfidence > .5)
						{
							var color:uint = (joint.positionRelative.z / (KinectMaxDepthInFlash * 4)) * 255 << 16 | (1 - (joint.positionRelative.z / (KinectMaxDepthInFlash * 4))) * 255 << 8 | 0;
							var jointSprite:Sprite = createCircleForPosition(joint.positionRelative, color);
							_skeletonContainer.addChild(jointSprite);
						}
					}
				}
				//user center position
				var userCenterSprite:Sprite = createCircleForPosition(user.positionRelative, 0xFF0000);
				_skeletonContainer.addChild(userCenterSprite);
			}
		}

		private function createCircleForPosition(positionRelative:Vector3D, color:uint):Sprite
		{
			var xPos:Number = ((positionRelative.x + 1) * .5) * explicitWidth;
			var yPos:Number = ((positionRelative.y - 1) / -2) * explicitHeight;
			var zPos:Number = positionRelative.z * KinectMaxDepthInFlash;

			var circle:Sprite = new Sprite();
			circle.graphics.beginFill(color);
			circle.graphics.drawCircle(0, 0, 15);
			circle.graphics.endFill();
			circle.x = xPos;
			circle.y = yPos;
			circle.z = zPos;

			return circle;
		}

	}
}
	