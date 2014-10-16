package com.gavin.game.view
{
	import com.gavin.game.manager.GameManager;

	import flash.display.Sprite;

	/**
	 * ...
	 * @author Gavin
	 */
	public class Grid extends Sprite
	{
		public function Grid()
		{
			super();
			resetGame();
			var gridWidth:int = Cell.cellSize * gridNum + SPACE * (gridNum - 1);
			var gridHeight:int = Cell.cellSize * gridNum + SPACE * (gridNum - 1) + 124;

			//横线
			for (var i:int = 0; i <= gridNum; i++)
			{
				this.graphics.beginFill(0xFFFFFF);
				this.graphics.lineStyle(SPACE, 0xFFFFFF);
				var pointX:int = Cell.cellSize * i + SPACE * (i - 1) + SPACE * 0.5 + 124;
				this.graphics.moveTo(0, pointX);
				this.graphics.lineTo(gridWidth, pointX);
			}
			//竖线
			for (i = 1; i < gridNum; i++)
			{
				this.graphics.beginFill(0xFFFFFF);
				this.graphics.lineStyle(SPACE, 0xFFFFFF);
				var pointY:int = Cell.cellSize * i + SPACE * (i - 1) + SPACE * 0.5;
				this.graphics.moveTo(pointY, 124);
				this.graphics.lineTo(pointY, gridHeight);
			}
		}

		public function resetGame():void
		{
			if (_GridData != null)
			{
				for each (var cell:Cell in _GridData)
				{
					cell.value = 0;
				}
				return;
			}
			_GridData = new Vector.<Cell>();
			for (var i:int = 0; i < gridNum; i++)
			{
				for (var j:int = 0; j < gridNum; j++)
				{
					cell = new Cell();
					cell.posX = j;
					cell.posY = i;
					cell.x = cell.posX * (cell.width + SPACE);
					cell.y = cell.posY * (cell.height + SPACE) + 124;
					cell.value = 0;
					_GridData.push(cell);
					this.addChild(cell);
				}
			}
		}

		private static var _Instance:Grid;

		private var _GridData:Vector.<Cell>;

		public static var gridNum:int = 4;
		private const SPACE:int = 5;

		public var tweening:Boolean;

		public function createRandomCell():void
		{
			var freePosition:Vector.<Cell> = getFreePosition();
			if (freePosition.length == 0)
				return;
			var randomNum:int = int(Math.random() * freePosition.length)
			var cell:Cell = freePosition.splice(randomNum, 1)[0];
			cell.value = Math.random() >= 0.5 ? 2 : 4;
			if (cell.value == 2 && freePosition.length > 0)
			{
				cell = freePosition[int(Math.random() * freePosition.length)];
				cell.value = 2;
			}
		}

		private function getFreePosition():Vector.<Cell>
		{
			var freePosition:Vector.<Cell> = new Vector.<Cell>();
			for each (var cell:Cell in _GridData)
			{
				cell.isStacked = false;
				if (cell.value == 0)
					freePosition.push(cell);
			}
			return freePosition;
		}

		public function upProcess(cell:Cell):void
		{
			var $y:int = cell.posY;
			var $x:int = cell.posX;
			while (getCell($x, $y - 1) != null && getCell($x, $y - 1).value == 0)
			{
				if ($y <= 0)
					break;
				$y--;
				GameManager.getInstance().moves++;
			}
			if (cell.posY != $y)
			{
				getCell($x, $y).value = cell.value;
//				TweenMax.from(getCell($x, $y), 0.1, {y: cell.y});
				cell.value = 0;
			}

			var prevCell:Cell = getCell($x, $y - 1);
			if (prevCell != null && prevCell.value == getCell($x, $y).value && !prevCell.isStacked)
			{
				prevCell.stack();
				getCell($x, $y).value = 0;
//				TweenMax.from(prevCell, 0.1, {y: cell.y});
			}
		}

		public function downProcess(cell:Cell):void
		{
			var $y:int = cell.posY;
			var $x:int = cell.posX;
			while (getCell($x, $y + 1) != null && getCell($x, $y + 1).value == 0)
			{
				if ($y >= gridNum - 1)
					break;
				$y++;
				GameManager.getInstance().moves++;
			}
			if (cell.posY != $y)
			{
				getCell($x, $y).value = cell.value;
				cell.value = 0;
			}

			var nextCell:Cell = getCell($x, $y + 1);
			if (nextCell != null && nextCell.value == getCell($x, $y).value && !nextCell.isStacked)
			{
				nextCell.stack();
				getCell($x, $y).value = 0;
			}
//			TweenMax.from(nextCell, 0.1, {y: cell.y});
		}

		public function leftProcess(cell:Cell):void
		{
			var $y:int = cell.posY;
			var $x:int = cell.posX;
			while (getCell($x - 1, $y) != null && getCell($x - 1, $y).value == 0)
			{
				if ($x <= 0)
					break;
				$x--;
				GameManager.getInstance().moves++;
			}
			if (cell.posX != $x)
			{
				getCell($x, $y).value = cell.value;
				cell.value = 0;
			}

			var prevCell:Cell = getCell($x - 1, $y);
			if (prevCell != null && prevCell.value == getCell($x, $y).value && !prevCell.isStacked)
			{
				prevCell.stack();
				getCell($x, $y).value = 0;
			}
//			TweenMax.from(prevCell, 0.1, {x: cell.x});
		}

		public function rightProcess(cell:Cell):void
		{
			var $y:int = cell.posY;
			var $x:int = cell.posX;
			while (getCell($x + 1, $y) != null && getCell($x + 1, $y).value == 0)
			{
				if ($x >= gridNum - 1)
					break;
				$x++;
				GameManager.getInstance().moves++;
			}
			if (cell.posX != $x)
			{
				getCell($x, $y).value = cell.value;
				cell.value = 0;
			}

			var nextCell:Cell = getCell($x + 1, $y);
			if (nextCell != null && nextCell.value == getCell($x, $y).value && !nextCell.isStacked)
			{
				nextCell.stack();
				getCell($x, $y).value = 0;
			}
//			TweenMax.from(nextCell, 0.1, {x: cell.x});
		}

		public function getCell($x:int, $y:int):Cell
		{
			if ($x >= gridNum || $x < 0 || $y >= gridNum || $y < 0)
				return null;
			return _GridData[$y * gridNum + $x];
		}

		public static function getInstance():Grid
		{
			if (_Instance == null)
				_Instance = new Grid();
			return _Instance;
		}
	}

}
