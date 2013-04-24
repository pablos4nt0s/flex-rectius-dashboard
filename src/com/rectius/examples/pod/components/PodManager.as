////////////////////////////////////////////////////////////////////////////////
//
//  RECTIUS - RIA WEBLOG
//  http://www.rectius.com.br/blog
//
////////////////////////////////////////////////////////////////////////////////

package com.rectius.examples.pod.components
{
	import com.rectius.examples.pod.events.PodWindowEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	/**
	 *  A PodManager class defines two content areas which holds 
	 *  instances of PodWindow class.
	 * 
	 *  @author Pablo Souza
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class PodManager extends SkinnableContainer
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PodManager()
		{
			super();
			
			FlexGlobals.topLevelApplication.addEventListener(PodWindowEvent.RESTORE, restoreHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts 
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  top container
		//----------------------------------
		
		[SkinPart(required="true")]
		
		/**
		 *  Defines the top container. 
		 * 
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var firstContainer:Group;
		
		//----------------------------------
		//  bottom container
		//----------------------------------
		
		[SkinPart(required="true")]
		
		/**
		 *  Defines the bottom container. 
		 * 
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var secondContainer:Group;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  minimizedPods
		//----------------------------------
		
		[Bindable]
		/**
		 *  The set of minimized pods. 
		 * 
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var minimizedPods:ArrayCollection = new ArrayCollection();
		
		[ArrayElementType("com.rectius.examples.pod.components.PodWindow")]
		public var firstElements:Array;
		
		[ArrayElementType("com.rectius.examples.pod.components.PodWindow")]
		public var secondElements:Array;
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var podElement:PodWindow;
			
			for each(podElement in firstElements)
			{
				podElement.addEventListener(PodWindowEvent.CHANGE, changeHandler);
				podElement.addEventListener(PodWindowEvent.MAXIMIZE, maximizeHandler);
				podElement.addEventListener(PodWindowEvent.MINIMIZE, minimizeHandler);
				podElement.addEventListener(PodWindowEvent.NORMAL, normalHandler);
				
				firstContainer.addElement(podElement);
			}
			for each(podElement in secondElements)
			{
				podElement.addEventListener(PodWindowEvent.CHANGE, changeHandler);
				podElement.addEventListener(PodWindowEvent.MAXIMIZE, maximizeHandler);
				podElement.addEventListener(PodWindowEvent.MINIMIZE, minimizeHandler);
				podElement.addEventListener(PodWindowEvent.NORMAL, normalHandler);
				
				secondContainer.addElement(podElement);
			}
			
			changeContainerAspect(firstContainer, firstContainer.numElements > 0 ? true : false);
			changeContainerAspect(secondContainer, secondContainer.numElements > 0 ? true : false);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handler methods
		//
		//--------------------------------------------------------------------------
		
		protected function changeHandler(event:PodWindowEvent):void
		{
			// changes the podwindow position
			var source:Pod = event.data.source;
			var target:Pod = event.data.target;
			var sourceParent:IVisualElementContainer = source.parent as IVisualElementContainer;
			var targetParent:IVisualElementContainer = target.parent as IVisualElementContainer;
			
			var sourceIndex:int = sourceParent.getElementIndex(source);
			var targetIndex:int = targetParent.getElementIndex(target);
			
			targetParent.addElementAt(source, targetIndex);
			sourceParent.addElementAt(target, sourceIndex);
		}
		
		protected function restoreHandler(event:PodWindowEvent):void
		{
			// removes a podwindow from the minimized list 
			var pod:Pod = Pod(event.data);
			minimizedPods.removeItemAt(minimizedPods.getItemIndex(pod));
			// adds a podwindow to the podmanager component
			pod.podParent.addElement(pod);
			
			// adjusts the screen
			changePodAspect(firstContainer, true, PodWindow.WINDOW_NORMAL);
			changePodAspect(secondContainer, true, PodWindow.WINDOW_NORMAL);
			changeContainerAspect(firstContainer, firstContainer.numElements == 0 ? false : true);
			changeContainerAspect(secondContainer, secondContainer.numElements == 0 ? false : true);
		}
		
		protected function minimizeHandler(event:PodWindowEvent):void
		{
			// adds a podwindow to minimized list
			var pod:Pod = Pod(event.data);
			pod.podParent.removeElement(pod);
			minimizedPods.addItem(pod);
			
			// adjusts the screen
			changePodAspect(firstContainer, true);
			changePodAspect(secondContainer, true);
			changeContainerAspect(firstContainer, firstContainer.numElements == 0 ? false : true);
			changeContainerAspect(secondContainer, secondContainer.numElements == 0 ? false : true);
		}
		
		protected function maximizeHandler(event:PodWindowEvent):void
		{
			var pod:Pod = Pod(event.data);
			var parentId:String = Group(pod.podParent).id;
			
			
			changeContainerAspect(parentId == "firstContainer" ? secondContainer : firstContainer, false);
			
			for (var index:int = 0; index < pod.podParent.numElements; index++)
			{
				var element:Pod = pod.podParent.getElementAt(index) as Pod;
				if(element != pod)
				{
					element.visible = false;
					element.includeInLayout = false;
				}
			}
		}
		
		protected function normalHandler(event:PodWindowEvent):void
		{
			changeContainerAspect(firstContainer, firstContainer.numElements == 0 ? false : true);
			changeContainerAspect(secondContainer, secondContainer.numElements == 0 ? false : true);
			var pod:Pod = Pod(event.data);
			changePodAspect(pod.podParent, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function changePodAspect(container:IVisualElementContainer, action:Boolean, mode:String=null):void
		{
			for (var index:int = 0; index < container.numElements; index++)
			{
				var element:Pod = Pod(container.getElementAt(index));
				element.visible = action;
				element.includeInLayout = action;
				if(mode)
					element.mode = mode;
					
			}
		}
		
		private function changeContainerAspect(container:IVisualElement, action:Boolean):void
		{
			container.visible = action;	
			container.includeInLayout = action;	
		}
		
	}
}