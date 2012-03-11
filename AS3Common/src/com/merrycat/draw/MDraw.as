package com.merrycat.draw 
{
	import flash.display.Sprite;

	/**
	 * @author merrycat
	 * 绘制图形
	 */
	public class MDraw 
	{
		
		/**
		 * 绘制扇形
		 * @param	t				绘制图形的对象
		 * @param	x				原点x坐标
		 * @param	y				原点y坐标
		 * @param	r				半径
		 * @param	angle			扇面覆盖角度
		 * @param	startFrom		起始角度
		 * @param	fillColor		扇面颜色
		 */
		public static function drawSector(t : Sprite,x : Number = 0,y : Number = 0,
			r : Number = 100,angle : Number = 100,startFrom : Number = 0,
			fillColor : uint = 0x000000, fillAlpha:Number = 1) : void 
		{
			t.graphics.beginFill(fillColor, fillAlpha);
			t.graphics.lineStyle(0, 0x000000, 0);
			t.graphics.moveTo(x, y);
			
			angle = (Math.abs(angle) > 360) ? 360 : angle;
			var n : Number = Math.ceil(Math.abs(angle) / 45);
			var angleA : Number = angle / n;
			angleA = angleA * Math.PI / 180;
			startFrom = startFrom * Math.PI / 180;
			t.graphics.lineTo(x + r * Math.cos(startFrom), y + r * Math.sin(startFrom));
			for (var i:int = 1;i <= n;i++) 
			{
				startFrom += angleA;
				var angleMid:Number = startFrom - angleA / 2;
				var bx:Number = x + r / Math.cos(angleA / 2) * Math.cos(angleMid);
				var by:Number = y + r / Math.cos(angleA / 2) * Math.sin(angleMid);
				var cx:Number = x + r * Math.cos(startFrom);
				var cy:Number = y + r * Math.sin(startFrom);
				t.graphics.curveTo(bx, by, cx, cy);
			}
			if (angle != 360) 
			{
				t.graphics.lineTo(x, y);
			}
			t.graphics.endFill();
		}
	}
}
