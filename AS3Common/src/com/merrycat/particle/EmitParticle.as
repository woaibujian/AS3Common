package com.merrycat.particle
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * @author:		Merrycat
	 * @version:	2010-12-15	����11:17:27
	 * @desc:		位图离子类（待完善）
	 */
	public class EmitParticle extends Sprite
	{
		private static const MAX_NUM : uint = 1000;
		private static const EMIT_NUM : Number = 1;
		private static const GRAVITY : Number = 0.5;
		private static const FRICTION : Number = 0.98;
		private var particles : Vector.<Particle>;
		private var count : int = 0;
		private var orijinal : BitmapData;
		private var canvas : BitmapData;
		
		private var _w : Number;
		private var _h : Number;
		
		public function EmitParticle(dispClass : Class, w:Number, h:Number)
		{
			var disp : DisplayObject = new dispClass();
			
			_w = w;
			_h = h;

			orijinal = new BitmapData(disp.width, disp.height, true, 0x0);
			orijinal.draw(disp, new Matrix(1, 0, 0, 1, disp.width >> 1, disp.height >> 1));

			canvas = new BitmapData(w, h, true, 0xFFFFFFFF);
			addChild(new Bitmap(canvas));

			particles = new Vector.<Particle>(MAX_NUM, true);
			for (var i : int = 0; i < MAX_NUM; i++)
			{
				var p : Particle = new Particle();
				p.x = int.MAX_VALUE;
				p.y = int.MAX_VALUE;

				particles[i] = p;
			}
			addEventListener(Event.ENTER_FRAME, update);
		}

		private function emit() : void
		{
			var p : Particle = particles[count];
			p.enable = true;
			p.vx = 20 * (Math.random() - 0.5);
			p.vy = -20 * (Math.random() - 0.5);
//			p.x = mouseX;
//			p.y = mouseY;
			p.x = _w >> 1;
			p.y = _h >> 1;
			count++;
			if (count == particles.length)
				count = 0;
		}

		private function hideParticle(p : Particle) : void
		{
			p.enable = false;
			p.x = int.MAX_VALUE;
			p.y = int.MAX_VALUE;
		}

		private function update(evt : Event) : void
		{
			for (var i : int = 0; i < EMIT_NUM; i++)
				emit();

			canvas.lock();
			canvas.fillRect(canvas.rect, 0xFFFFFFFF);

			for (i = 0; i < MAX_NUM; i++)
			{
				var p : Particle = particles[i];
				if (p.enable)
				{
					p.x += p.vx;
					p.y += p.vy;
					p.vx *= FRICTION;
					p.vy *= FRICTION;
					p.vy += GRAVITY;
					if (p.y > 465)
					{
						hideParticle(p);
					}
					else
					{
						canvas.copyPixels(orijinal, orijinal.rect, new Point(p.x, p.y), null, null, true);
					}
				}
			}

			canvas.unlock();
		}
	}
}
internal final class Particle
{
	public var x : Number = 0;
	public var y : Number = 0;
	public var vx : Number = 0;
	public var vy : Number = 0;
	public var enable : Boolean = false;
}