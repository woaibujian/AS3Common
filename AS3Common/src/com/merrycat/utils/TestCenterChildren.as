package com.merrycat.utils
{
	import flash.display.StageScaleMode;
	import flash.display.Sprite;

	/**
	 * @author:		Merrycat
	 * @createDate:	2011-9-13	����12:19:36
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="1000", height="600")]
	public class TestCenterChildren extends Sprite
	{
		private var childrenContainer : Sprite;
		
		public function TestCenterChildren()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			childrenContainer = new Sprite();
			childrenContainer.x = 1000/2;
			childrenContainer.y = 600/2;
			this.addChild(childrenContainer);
			
			var centerPoint:Sprite = new Sprite();
			centerPoint.graphics.beginFill(0xff0000);
			centerPoint.graphics.drawCircle(0, 0, 10);
			centerPoint.graphics.endFill();
			centerPoint.x = 1000/2;
			centerPoint.y = 600/2;
			this.addChild(centerPoint);

			var child1 : Sprite = getChild();
			child1.x = -200;
			child1.y = -100;
			childrenContainer.addChild(child1);
			var child2 : Sprite = getChild();
			child2.x = 0;
			child2.y = 0;
			childrenContainer.addChild(child2);
			var child3 : Sprite = getChild();
			child3.x = 100;
			child3.y = 100;
			childrenContainer.addChild(child3);
			
			Disp2.centerChildren(childrenContainer);
		}

		private function getChild() : Sprite
		{
			var child : Sprite = new Sprite();
			child.graphics.beginFill(0);
			child.graphics.drawRect(0, 0, 100, 100);
			child.graphics.endFill();
			return child;
		}
	}
}
