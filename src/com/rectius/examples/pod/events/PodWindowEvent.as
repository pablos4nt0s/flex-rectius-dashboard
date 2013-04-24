package com.rectius.examples.pod.events
{
	import flash.events.Event;
	
	public class PodWindowEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const MINIMIZE:String = "minimize";
		public static const MAXIMIZE:String = "maximize";
		public static const NORMAL:String = "normal";
		public static const RESTORE:String = "restore";
		public static const CHANGE:String = "change";
		
		public var data:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function PodWindowEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: Event
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function clone():Event
		{
			return new PodWindowEvent(type, bubbles, cancelable, data);
		}
	}
}