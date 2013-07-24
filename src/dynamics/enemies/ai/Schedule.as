package dynamics.enemies.ai
{
	
	public class Schedule extends Object
	{
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		public var tasks:Array; // Список задач.
		public var interrupts:ConditionList; // Список условий для прерывания выполнения набора действий.
		
		//---------------------------------------
		// PROTECTED VARIABLES
		//---------------------------------------
		protected var _name:String;
		protected var _taskIndex:int;
		protected var _isCompleted:Boolean;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function Schedule(name:String = "")
		{
			tasks = [];
			interrupts = new ConditionList();
			
			_name = name;
			_taskIndex = 0;
			_isCompleted = false;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Добавляет новую задачу в список задач.
		 * 
		 * @param	func	 Указатель на функцию задачу.
		 * @param	arg	 Аргументы которые могут быть переданы в выполняемую функцию.
		 */
		public function addTask(func:Function, arg:Array = null):void
		{
			tasks.push({ func:func, arg:arg });
		}
		
		/**
		 * Добавляет несколько новых задач в список задач.
		 * 
		 * @param	funcList	 Массив функций задач.
		 */
		public function addFewTasks(funcList:Array /* of Function */):void
		{
			var n:int = funcList.length;
			for (var i:int = 0; i < n; i++)
			{
				tasks.push({ func:funcList[i], arg:null });
			}
		}
		
		/**
		 * Добавляет условие для прерывания.
		 * 
		 * @param	value	 Значение условия для прерывания.
		 */
		public function addInterrupt(value:uint):void
		{
			interrupts.set(value);
		}
		
		/**
		 * Добавляет несколько условий для прерывания.
		 * 
		 * @param	interruptsList	 Массив условий для прерывания.
		 */
		public function addFewInterrupts(interruptsList:Array /* of uint or int */):void
		{
			var n:int = interruptsList.length;
			for (var i:int = 0; i < n; i++)
			{
				interrupts.set(interruptsList[i]);
			}
		}
		
		/**
		 * Процессинг набора действий.
		 */
		public function update():void
		{
			if (_isCompleted)
			{
				return;
			}
			
			// Получение текущей задачи.
			var o:Object = tasks[_taskIndex];
			if (o != null)
			{
				// Выполнение функции задачи.
				if ((o.func as Function).apply(this, o.arg))
				{
					// Если функция вернула true, значит задача завершена,
					// переходим к следующей задачи.
					_taskIndex++;
					if (_taskIndex >= tasks.length)
					{
						// Все задачи выполнены.
						complete();
					}
				}
			}
			else
			{
				complete();
			}
		}
		
		/**
		 * Проверяет завершено ли выполнение текущего набора действий.
		 * 
		 * @param	conditions	 Список текущих условий которые могут завершить 
		 * выполнение набора действий преждевременно.
		 * 
		 * @return		Возвращает true если выполнение набора действий завершено.
		 */
		public function isCompleted(conditions:ConditionList):Boolean
		{
			if (interrupts.isIntersects(conditions))
			{
				return true;
			}
			
			return _isCompleted;
		}
		
		/**
		 * Сброс набора действий.
		 */
		public function reset():void
		{
			_taskIndex = 0;
			_isCompleted = false;
		}
		
		/**
		 * @private
		 */
		public function toString():String
		{
			return "{Schedule: " + _name + 
				", numTasks: " + tasks.length.toString() +
				", numInterrupts: " + interrupts.members.length.toString() + "}";
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @private
		 */
		protected function complete():void
		{
			_taskIndex = 0;
			_isCompleted = true;
		}
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * @private
		 */
		public function get name():String
		{
			return _name;
		}

	}

}