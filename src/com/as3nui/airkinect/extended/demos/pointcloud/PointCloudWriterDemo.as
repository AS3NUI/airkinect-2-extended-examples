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

package com.as3nui.airkinect.extended.demos.pointcloud {
	import com.as3nui.airkinect.extended.demos.core.DemoBase;
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.PointCloudEvent;
	import com.as3nui.nativeExtensions.air.kinect.extended.pointcloud.PointCloudWriter;

	import flash.events.KeyboardEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;

	public class PointCloudWriterDemo extends DemoBase {
		private var _depthPoints:ByteArray;
		private var _device:Kinect;
		private var renderer:PointCloudRenderer;
		private var _pointCloudResolution:Point;

		public function PointCloudWriterDemo() { }

		override protected function startDemoImplementation():void {
			super.startDemoImplementation();
			var perspectiveProjection: PerspectiveProjection = new PerspectiveProjection( );
			perspectiveProjection.fieldOfView = 60.0;

			var settings:KinectSettings = new KinectSettings();
			settings.pointCloudEnabled = true;
			settings.pointCloudDensity = 4;

			_pointCloudResolution = settings.pointCloudResolution = CameraResolution.RESOLUTION_640_480;

			renderer = new PointCloudRenderer(settings);
			addChild(renderer);

			_device = Kinect.getDevice();
			_device.addEventListener(DeviceEvent.STARTED, kinectStartedHandler, false, 0, true);
			_device.addEventListener(DeviceEvent.STOPPED, kinectStoppedHandler, false, 0, true);
			_device.addEventListener(PointCloudEvent.POINT_CLOUD_UPDATE, pointCloudUpdateHandler, false, 0, true);

			_device.start(settings);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		override protected function stopDemoImplementation():void {
			super.stopDemoImplementation();

			_device.stop();
			_device.removeEventListener(DeviceEvent.STARTED, kinectStartedHandler, false);
			_device.removeEventListener(DeviceEvent.STOPPED, kinectStoppedHandler, false);
			_device.removeEventListener(PointCloudEvent.POINT_CLOUD_UPDATE, pointCloudUpdateHandler, false);

			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.removeChildren();
		}

		protected function kinectStartedHandler(event:DeviceEvent):void {

		}

		protected function kinectStoppedHandler(event:DeviceEvent):void {

		}

		private function onKeyUp(event:KeyboardEvent):void {
			if(event.keyCode == Keyboard.S) savePoints();
		}

		protected function pointCloudUpdateHandler(event:PointCloudEvent):void {
			_depthPoints = event.pointCloudData;
			renderer.updatePoints(_depthPoints);
		}

		private function savePoints():void {
			if(!_depthPoints) return;
//			PointCloudHelper.savePTS(_depthPoints, _pointCloudResolution.x, _pointCloudResolution.y, 2048);
//			PointCloudHelper.saveXYZ(_depthPoints, _pointCloudResolution.x, _pointCloudResolution.y, 2048);
			PointCloudWriter.savePLY(_depthPoints, _pointCloudResolution.x, _pointCloudResolution.y, 2048);
		}
	}
}