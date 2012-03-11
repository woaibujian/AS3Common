package com.merrycat.display {
	import com.merrycat.utils.ObjectPool;
	import org.casalib.time.EnterFrame;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	/**
	 * @author buj
	 */
	public class RoadRepeat extends Sprite{
		
		private var roadCell : Sprite;
		private var road : Sprite;
		private var roadMask : Sprite;
		
		private var speed : Number = 0;
		
		private var roadCells : Array = [];
		
		private var cellW : uint = 400;
		private var CellClass : Class;
		
		private var op : ObjectPool;
		
		public var moving : Boolean = false;
		
		public function RoadRepeat(className:String, roadRect:Rectangle, cellW:Number) 
		{
			this.cellW = cellW;
			
			road = new Sprite();
			this.addChild(road);
			
			roadMask = new Sprite();
			roadMask.graphics.beginFill(0x0000ff, 0.5);
			roadMask.graphics.drawRect(0, 0, roadRect.width, roadRect.height);
			roadMask.graphics.endFill();
			road.mask = roadMask;
			
			CellClass = getDefinitionByName(className) as Class;
			op = ObjectPool.getPool(CellClass);
			
			for (var i : int = 0; i < 2; i++) 
			{
				roadCell = op.borrowObject() as Sprite;
				roadCell.x = i * cellW;
				road.addChild(roadCell);
				roadCells.push(roadCell);
			}
			
			this.addChild(roadMask);
		}

		public function startMove(speed:Number) : void 
		{
			EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, onEF);
			moving = true;
			this.speed = speed;
		}

		public function stopMove() : void 
		{
			moving = false;
			EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEF);
		}

		
		private function onEF(e : Event) : void {
			for (var i : int = 0; i < roadCells.length; i++) 
			{
				roadCell = roadCells[i];
				roadCell.x += speed;
				
				if(i == 0)
				{
					if(roadCell.x + roadCell.width - speed < 0)
					{
						road.removeChild(roadCell);
						roadCells.shift();
						op.returnObject(roadCell);
						i--;
					}
				}
				
				if(i == roadCells.length - 1 && roadCell.x < 0)
				{
					roadCell = op.borrowObject() as Sprite;
					roadCell.x = roadCells[roadCells.length - 1].x + roadCell.width - speed;
					road.addChild(roadCell);
					roadCells.push(roadCell);
				}
			}
		}
	}
}
