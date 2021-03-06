﻿package  {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import starling.core.Starling;

    [SWF(width="800", height="600", frameRate="30", backgroundColor="#cccccc")]
	public class Example_Robot_ChangeSpeed_BoneScale extends flash.display.Sprite {

		public function Example_Robot_ChangeSpeed_BoneScale() {
			starlingInit();
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseHandler);
		}

		private function mouseHandler(e:MouseEvent):void 
		{
			switch(e.type) {
				case MouseEvent.MOUSE_WHEEL:
					StarlingGame.instance.changeAnimationScale(e.delta > 0?1: -1);
					break;
			}
		}

		private function starlingInit():void {
			Starling.handleLostContext = true;
			var _starling:Starling = new Starling(StarlingGame, stage);
			//_starling.antiAliasing = 1;
			_starling.showStats = true;
			_starling.start();
		}
	}
}

import flash.events.Event;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.factories.StarlingFactory;

import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.text.TextField;

class StarlingGame extends Sprite {
	[Embed(source = "../assets/Robot.dbswf", mimeType = "application/octet-stream")]
	private static const ResourcesData:Class;

	public static var instance:StarlingGame;

	private var factory:StarlingFactory;
	private var armature:Armature;
	
	private var textField:TextField;

	public function StarlingGame() {
		instance = this;

		factory = new StarlingFactory();
		//
		factory.scaleForTexture = 2;
		
		factory.parseData(new ResourcesData());
		factory.addEventListener(flash.events.Event.COMPLETE, textureCompleteHandler);
	}

	private function textureCompleteHandler(_e:flash.events.Event):void {
		armature = factory.buildArmature("robot");
		var _display:Sprite = armature.display as Sprite;
		_display.x = 400;
		_display.y = 300;
		
		addChild(_display);
		armature.animation.gotoAndPlay("stop");
		WorldClock.clock.add(armature);
		addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);
		
		textField = new TextField(700, 30, "Scroll mouse wheel to change speed.", "Verdana", 16, 0, true);
		textField.x = 60;
		textField.y = 5;
		addChild(textField);
		
		changeAnimation();
		
		armature.getBone("upperbody").offset.scaleX = 2;
		armature.getBone("upperbody").offset.scaleY = 2;
	}

	public function changeAnimation():void 
	{
		do{
			var animationName:String = armature.animation.animationList[int(Math.random() * armature.animation.animationList.length)];
		}
		while (animationName == armature.animation.lastAnimationName);
		armature.animation.gotoAndPlay(animationName);
	}

	public function changeAnimationScale(_dir:int):void 
	{
		if (_dir > 0) {
			if (armature.animation.timeScale < 10) {
				armature.animation.timeScale += 0.1;
			}
		}else {
			if (armature.animation.timeScale > 0.2) {
				armature.animation.timeScale -= 0.1;
			}
		}
	}
	
	private function onEnterFrameHandler(_e:EnterFrameEvent):void {
		WorldClock.clock.advanceTime(-1);
	}
}
