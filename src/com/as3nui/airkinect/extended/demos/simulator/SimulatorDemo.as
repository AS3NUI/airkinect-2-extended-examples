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
	import com.as3nui.nativeExtensions.air.kinect.KinectConfig;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.extended.simulator.UserPlayer;
	import com.as3nui.nativeExtensions.air.kinect.extended.simulator.UserRecorder;
	import com.as3nui.nativeExtensions.air.kinect.extended.simulator.data.UserRecording;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	public class SimulatorDemo extends DemoBase {
		protected const KinectMaxDepthInFlash:Number = 200;

		protected var rgbBitmap:Bitmap;
		protected var _skeletonContainer:Sprite;
		protected var _userRecorder:UserRecorder;
		protected var _userPlayer:UserPlayer;
		protected var _kinect:Kinect;

		public function SimulatorDemo() { }

		override protected function startDemoImplementation():void {
			super.startDemoImplementation();
			_kinect = Kinect.getKinect();

			var config:KinectConfig = new KinectConfig();
			config.skeletonEnabled = true;
			config.rgbEnabled = true;
			config.rgbResolution = CameraResolution.RESOLUTION_320_240;

			_kinect.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, rgbImageUpdateHandler);
			_kinect.start(config);

			initRGBCamera();
			initDemo();
		}

		override protected function stopDemoImplementation():void {
			super.stopDemoImplementation();
			this.removeChildren();
			rgbBitmap.bitmapData.dispose();
			rgbBitmap = null;
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
			_userRecorder = new UserRecorder(_kinect);
			_userPlayer = new UserPlayer(_kinect);

			_skeletonContainer = new Sprite();
			this.addChild(_skeletonContainer);

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			createUI();
		}

		//Enterframe
		protected function onEnterFrame(event:Event):void {
			drawSkeletons();
		}

		protected function createUI():void {
			var recordButton:SimpleButton = new SimpleButton("Record", 0xeeeeee);
			recordButton.x = 10;
			recordButton.y = 20;
			this.addChild(recordButton);
			recordButton.addEventListener(MouseEvent.CLICK, onRecordClick, false, 0, true);

			var playButton:SimpleButton = new SimpleButton("Play", 0xeeeeee);
			playButton.x = 10;
			playButton.y = 60;
			this.addChild(playButton);
			playButton.addEventListener(MouseEvent.CLICK, onPlayClick, false, 0, true);

			var stopButton:SimpleButton = new SimpleButton("Stop", 0xeeeeee);
			stopButton.x = 70;
			stopButton.y = 20;
			this.addChild(stopButton);
			stopButton.addEventListener(MouseEvent.CLICK, onStopClick, false, 0, true);
		}

		protected function onRecordClick(event:MouseEvent):void {
			trace("recording");
			_userRecorder.record();
		}

		protected function onStopClick(event:MouseEvent):void {
			if (!_userRecorder.recording) return;

			trace("Stopped");
			_userRecorder.stop();
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(_userRecorder.currentRecordingJSON);

			var fr:FileReference = new FileReference();
			fr.addEventListener(Event.SELECT, onSaveSuccess);
			fr.addEventListener(Event.CANCEL, onSaveCancel);
			fr.save(ba, "skeletonRecording.json");
		}

		protected function onSaveSuccess(e:Event):void {

		}

		protected function onSaveCancel(e:Event):void {
		}


		protected function onPlayClick(event:MouseEvent):void {
			loadJSON();
		}

		protected function loadJSON():void {
			var jsonFilter:FileFilter = new FileFilter("XML", "*.json");
			var file:File = new File();
			file.addEventListener(Event.SELECT, onFileSelected);
			file.browseForOpen("Please select a file...", [jsonFilter]);
		}

		protected function onFileSelected(event:Event):void {
			var fileStream:FileStream = new FileStream();
			try {
				fileStream.open(event.target as File, FileMode.READ);
				var userRecording:Object = JSON.parse(fileStream.readUTFBytes(fileStream.bytesAvailable));
				fileStream.close();
				_userPlayer.play(userRecording, true);
			} catch (e:Error) {
				trace("Error loading Config : " + e.message);
			}
		}

		protected function drawSkeletons():void {
			_skeletonContainer.removeChildren();

			for each(var user:User in _kinect.users)
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

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class SimpleButton extends Sprite {
	protected var _label:String;
	protected var _color:uint;
	protected var _text:TextField;

	public function SimpleButton(label:String, color:uint):void {
		this.mouseChildren = false;
		this.mouseEnabled = this.buttonMode = true;

		_label = label;
		_color = color;
		draw();
	}

	protected function draw():void {
		if (_text) {
			if (this.contains(_text))this.removeChild(_text);
			_text = null;
		}

		_text = new TextField();
		_text.text = _label;
		_text.autoSize = TextFieldAutoSize.LEFT;
		_text.x = 5;
		_text.y = 5;
		_text.selectable = false;
		this.addChild(_text);

		this.graphics.clear();
		this.graphics.beginFill(_color);
		this.graphics.drawRect(0, 0, _text.width + 10, _text.height + 10);
	}

	public function get label():String {
		return _label;
	}

	public function set label(value:String):void {
		_label = value;
		draw();
	}
}
	