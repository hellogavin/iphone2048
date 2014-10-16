//---------------------------------------------------------
//Description:
//
//Modify:
//    2014-10-13 create by Gavin
//
//---------------------------------------------------------
package
{
	import com.gavin.game.manager.GameManager;
	import com.gavin.game.staticData.Direction;
	import com.gavin.game.view.Grid;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TransformGestureEvent;
	import flash.ui.Keyboard;

	public class iphone2048 extends Sprite
	{
		public function iphone2048()
		{
			super();

			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initView();
			addEvent();
		}

		private function initView():void
		{
			this.graphics.beginFill(0x999999);
			this.graphics.drawRect(0, 0, 640, 1136);
			this.graphics.endFill();
			this.addChild(Grid.getInstance());
			Grid.getInstance().createRandomCell();
		}

		private function addEvent():void
		{
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, touchEnd);
		}

		protected function touchEnd(event:TransformGestureEvent):void
		{
			var changeX:Number = event.offsetX;
			var changeY:Number = event.offsetY;
			if (Math.abs(changeX) > Math.abs(changeY))
			{
				if (changeX > 0)
					touchScreen(Direction.RIGHT);
				else if (changeX < 0)
					touchScreen(Direction.LEFT);
			}
			else if (Math.abs(changeX) < Math.abs(changeY))
			{
				if (changeY > 0)
					touchScreen(Direction.DOWN);
				else if (changeY < 0)
					touchScreen(Direction.UP);
			}
		}

		private function touchScreen(direction:int):void
		{
			if (Grid.getInstance().tweening)
				return;
			GameManager.getInstance().moves = 0;
			switch (direction)
			{
				case Direction.UP:
					GameManager.getInstance().upProcess();
					break;
				case Direction.LEFT:
					GameManager.getInstance().leftProcess();
					break;
				case Direction.RIGHT:
					GameManager.getInstance().rightProcess();
					break;
				case Direction.DOWN:
					GameManager.getInstance().downProcess();
					break;
				case Keyboard.R:
					Grid.getInstance().resetGame();
					Grid.getInstance().createRandomCell();
					break;
			}
			if (GameManager.getInstance().moves > 0)
				Grid.getInstance().createRandomCell();
		}

		private function removeEvent():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
		}

		private function keyUp(event:KeyboardEvent):void
		{
			if (Grid.getInstance().tweening)
				return;
			GameManager.getInstance().moves = 0;
			switch (event.keyCode)
			{
				case Keyboard.UP:
					GameManager.getInstance().upProcess();
					break;
				case Keyboard.LEFT:
					GameManager.getInstance().leftProcess();
					break;
				case Keyboard.RIGHT:
					GameManager.getInstance().rightProcess();
					break;
				case Keyboard.DOWN:
					GameManager.getInstance().downProcess();
					break;
				case Keyboard.R:
					Grid.getInstance().resetGame();
					Grid.getInstance().createRandomCell();
					break;
			}
			if (GameManager.getInstance().moves > 0)
				Grid.getInstance().createRandomCell();

		}
	}
}
