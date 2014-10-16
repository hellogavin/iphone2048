package com.gavin.game.view
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * ...
	 * @author Gavin
	 */
	public class Cell extends Sprite
	{

		public function Cell()
		{
			init();
		}

		private var _Text:TextField;
		public var posX:int;
		public var posY:int;
		private var _Value:int;
		private var _isStacked:Boolean;
		private var _BgContainer:Shape;
		private var _ColorFlag:int = 0;

		public static var cellSize:int = 148;
		private static var colors:Array = [0xEEE4DA, 0xE0D4BE, 0xF3B07B, 0xF59563, 0xF57D5B, 0xF65D3B, 0xE2492D, 0xFF9933, 0xCC6600, 0xFF9900, 0xFF0000, 0xEEE4DA];

		private function init():void
		{
			_BgContainer = new Shape();
			this.addChild(_BgContainer);
			color = 0xE0D4BE;
			_Text = new TextField();
			_Text.width = cellSize;
			_Text.selectable = false;
			_Text.defaultTextFormat = new TextFormat("framd", 60, 0xFFFFFF, true);
			_Text.autoSize = TextFieldAutoSize.CENTER;
			this.addChild(_Text);
		}

		public function get value():int
		{
			return _Value;
		}

		public function set value(val:int):void
		{
			_Value = val;
			_ColorFlag = -1;
			while (val * 0.5 > 0)
			{
				val *= 0.5;
				_ColorFlag++;
			}
			if (_Value <= 0)
			{
				_Text.text = "";
				color = 0xCCC0B4;
			}
			else
			{
				_Text.text = _Value + '';
				_Text.y = (cellSize - _Text.textHeight) * 0.5;
				color = colors[_ColorFlag];
			}
		}

		public function stack():void
		{
			value *= 2;
			_isStacked = true;
		}

		public function get isStacked():Boolean
		{
			return _isStacked;
		}

		private function set color(value:int):void
		{
			_BgContainer.graphics.clear();

			_BgContainer.graphics.beginFill(value);
			_BgContainer.graphics.drawRoundRect(0, 0, cellSize, cellSize, 8, 8);
			_BgContainer.graphics.endFill();
		}

		public function set isStacked(bool:Boolean):void
		{
			_isStacked = bool;
		}
	}

}
