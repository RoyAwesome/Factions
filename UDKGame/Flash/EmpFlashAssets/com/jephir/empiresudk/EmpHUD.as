﻿package com.jephir.empiresudk {
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.external.ExternalInterface;
	import scaleform.gfx.Extensions;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	public class EmpHUD extends MovieClip {
		public var topLeftHUD:MovieClip;
		public var topRightHUD:MovieClip;
		public var bottomLeftHUD:MovieClip;
		public var bottomRightHUD:MovieClip;
		public var healthBarStartPositionX:Number = bottomLeftHUD.getChildByName('healthBar').x;
		
		public function EmpHUD() {
			Extensions.enabled = true;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, function () {
				ExternalInterface.call("ResizeHUD");
			});
		}
		
		public function SetPlayerHealth(health:int, maxHealth:int):void
		{
			var healthBar = bottomLeftHUD.getChildByName('healthBar');
			healthBar.x = -healthBar.width + healthBarStartPositionX + (health / maxHealth * healthBar.width);
		}
		
		public function SetResources(resources:int):void
		{
			var resourceCount:TextField = topRightHUD.getChildByName('resourceCount') as TextField;
			resourceCount.text = resources.toString();
		}
	}
}