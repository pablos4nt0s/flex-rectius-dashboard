////////////////////////////////////////////////////////////////////////////////
//
//  RECTIUS - RIA WEBLOG
//  http://www.rectius.com.br/blog
//
////////////////////////////////////////////////////////////////////////////////

package com.rectius.examples.pod.components
{
	import com.rectius.examples.pod.events.PodWindowEvent;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import mx.core.DragSource;
	import mx.core.IVisualElementContainer;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.ButtonBase;
	import spark.components.supportClasses.TextBase;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the user selects the minimize button.
	 *
	 *  @eventType com.rectius.examples.pod.events.PodWindowEvent.MINIMIZE
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="minimize", type="com.rectius.examples.pod.events.PodWindowEvent")]
	
	/**
	 *  Dispatched when the user selects the maximize button.
	 *
	 *  @eventType com.rectius.examples.pod.events.PodWindowEvent.MAXIMIZE
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="maximize", type="com.rectius.examples.pod.events.PodWindowEvent")]
	
	/**
	 *  Dispatched when the user selects the restore button.
	 *
	 *  @eventType com.rectius.examples.pod.events.PodWindowEvent.NORMAL
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="normal", type="com.rectius.examples.pod.events.PodWindowEvent")]
	
	/**
	 *  Dispatched when the user changes the pod position.
	 *
	 *  @eventType com.rectius.examples.pod.events.PodWindowEvent.CHANGE
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="change", type="com.rectius.examples.pod.events.PodWindowEvent")]
	
	//--------------------------------------
	//  SkinStates
	//--------------------------------------
	
	/**
	 *  Maximized view state.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[SkinState("maximized")]
	
	/**
	 *  Minimized view state.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[SkinState("minimized")]
	
	/**
	 *  Default view state.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[SkinState("normal")]
	
	/**
	 *  The PodWindow class defines a window that can be moved around the screen.
	 *  It includes a minimize button, a maximize button and a title label.
	 * 
	 *  @author Pablo Souza  
	 * 
	 *  @langversion 3.0
 	 *  @playerversion Flash 10
 	 *  @playerversion AIR 1.5
 	 *  @productversion Flex 4
	 */
	public class PodWindow extends SkinnableContainer
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PodWindow()
		{
			super();
			
			this.addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			this.addEventListener(DragEvent.DRAG_DROP, dragDropHandler);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		public static const WINDOW_MAXIMIZED:String = "maximized";
		public static const WINDOW_MINIMIZED:String = "minimized";
		public static const WINDOW_NORMAL:String = "normal";
		
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts 
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  minimizeButton
		//---------------------------------- 
		
		[SkinPart(required="true")]
		public var minimizeButton:ButtonBase;
		
		//----------------------------------
		//  maximizeButton
		//---------------------------------- 
		
		[SkinPart(required="true")]
		public var maximizeButton:ButtonBase;
		
		//----------------------------------
		//  moveArea
		//---------------------------------- 
		
		[SkinPart(required="true")]
		
		/**
		 *  The area where the user must click and drag to move the window.
		 *
		 *  <p>To drag the container, click and hold the mouse pointer in 
		 *  the title bar area of the window, then move the mouse. 
		 *  Create a custom skin class to change the move area.</p>
		 */
		public var moveArea:InteractiveObject;
		
		//----------------------------------
		//  titleField
		//---------------------------------- 
		
		[SkinPart(required="false")]
		
		/**
		 *  The skin part that defines the appearance of the 
		 *  title text in the container.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var titleDisplay:TextBase;
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties 
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  mode
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _mode:String = "normal";
		
		[Inspectable(enumeration="minimized,maximized,normal")]
		/**
		 *  Defines the current mode of the PodWindow.
		 * 
		 *  @default normal
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4 
		 */
		public function get mode():String
		{
			return _mode;
		}
		
		/**
		 *  @private
		 */
		public function set mode(value:String):void
		{
			if(value == mode)
				return;
			
			if(value == WINDOW_NORMAL)
			{
				_mode = value;
				dispatchEvent(new PodWindowEvent(PodWindowEvent.NORMAL, this));
			}
			else if(value == WINDOW_MAXIMIZED)
			{
				_mode = value;	
				dispatchEvent(new PodWindowEvent(PodWindowEvent.MAXIMIZE, this));
			}
			else if(value == WINDOW_MINIMIZED)
			{
				_mode = value;	
				dispatchEvent(new PodWindowEvent(PodWindowEvent.MINIMIZE, this));
			}
			invalidateSkinState();
		}
		
		//----------------------------------
		//  podParent
		//---------------------------------- 
		public var podParent:IVisualElementContainer;
		
		//----------------------------------
		//  title
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _title:String = "";
		
		[Bindable]
		
		/**
		 *  Title or caption displayed in the title bar. 
		 *
		 *  @default ""
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get title():String 
		{
			return _title;
		}
		
		/**
		 *  @private
		 */
		public function set title(value:String):void 
		{
			_title = value;
			
			if (titleDisplay)
				titleDisplay.text = title;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: UIComponent, SkinnableComponent
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if (instance == moveArea)
			{
				moveArea.doubleClickEnabled = true;
				moveArea.addEventListener(MouseEvent.DOUBLE_CLICK, maximizeButton_clickHandler);
				moveArea.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			}
			else if(instance == titleDisplay)
			{
				titleDisplay.text = title;
			}
			else if (instance == minimizeButton)
			{
				minimizeButton.focusEnabled = false;
				minimizeButton.addEventListener(MouseEvent.CLICK, minimizeButton_clickHandler);
			}
			else if(instance == maximizeButton)
			{
				maximizeButton.focusEnabled = false;
				maximizeButton.addEventListener(MouseEvent.CLICK, maximizeButton_clickHandler);
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == moveArea)
			{
				moveArea.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			}
			else if (instance == minimizeButton)
			{
				minimizeButton.removeEventListener(MouseEvent.CLICK, minimizeButton_clickHandler);
			}
			else if(instance == maximizeButton)
			{
				maximizeButton.removeEventListener(MouseEvent.CLICK, maximizeButton_clickHandler);
			}
		}
		
		/**
		 *  @private
		 */
		override protected function getCurrentSkinState():String
		{
			if(enabled == false)
			{
				return super.getCurrentSkinState();
			}
			else if (mode == WINDOW_NORMAL)
			{
				return WINDOW_NORMAL;
			}
			else if (mode == WINDOW_MAXIMIZED)
			{
				return WINDOW_MAXIMIZED;
			}
			else
			{
				return WINDOW_MINIMIZED;
			}
		}

		
		//--------------------------------------------------------------------------
		// 
		// Event Handlers
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  minimizeButton Handler
		//----------------------------------
		
		/**
		 *  @private
		 *  Dispatches the "minimize" event when the minimizeButton is clicked.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected function minimizeButton_clickHandler(event:MouseEvent):void
		{
			podParent = this.parent as IVisualElementContainer;
			mode = WINDOW_MINIMIZED;
			invalidateDisplayList();
		}
		
		//----------------------------------
		//  maximizeButton Handler
		//----------------------------------
		
		/**
		 *  @private
		 *  Dispatches the "maximize"/"normal" event when the maximizeButton is clicked.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected function maximizeButton_clickHandler(event:MouseEvent):void
		{
			podParent = this.parent as IVisualElementContainer;
			mode = (mode == WINDOW_MAXIMIZED) ? WINDOW_NORMAL : WINDOW_MAXIMIZED;
			invalidateDisplayList();
		}
		
		//----------------------------------
		//  mouseMove Handler
		//----------------------------------
		
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			var dragInitiator:Pod = Pod(this);
			var dragSource:DragSource = new DragSource();
			dragSource.addData(dragInitiator, "podcontainer");
			DragManager.doDrag(dragInitiator, dragSource, event);
		}
		
		//----------------------------------
		//  dragEnter Handler
		//----------------------------------
		
		protected function dragEnterHandler(event:DragEvent):void
		{
			if (event.dragSource.hasFormat("podcontainer"))
			{
				DragManager.acceptDragDrop(Pod(event.currentTarget));
			}
		}
		
		//----------------------------------
		//  dragDrop Handler
		//----------------------------------
		
		protected function dragDropHandler(event:DragEvent):void
		{
			var podEvent:PodWindowEvent = new PodWindowEvent(PodWindowEvent.CHANGE,{source: event.dragInitiator , target: event.currentTarget}, true);
			dispatchEvent(podEvent);	
		}
		
	}
}