#Область ДополнительныеОбработки

Функция СведенияОВнешнейОбработке() Экспорт
	
	МассивНазначений = Новый Массив;
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид", "ДополнительнаяОбработка");
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "Монитор RAS 1C");
	ПараметрыРегистрации.Вставить("Версия", "2020.10.19");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация", ИнформацияПоИсторииИзменений());
	ПараметрыРегистрации.Вставить("ВерсияБСП", "1.2.1.4");
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд,
	                "Настройка 'Монитор RAS 1C'",
					"МониторRAS_1C",
					"ОткрытиеФормы",
					Истина,
					"",
					"ФормаНастроек"
					);
	ДобавитьКоманду(ТаблицаКоманд,
	                "Монитор 'RAS 1C'",
					"МониторRAS_1C",
					"ОткрытиеФормы",
					Истина,
					"",
					"ФормаМонитора"
					); 					
	ДобавитьКоманду(ТаблицаКоманд,
	                "ПолучитьДанныеКластераФоново",
					"ПолучитьДанныеКластераФоново",
					"ВызовСерверногоМетода",
					Ложь,
					"",
					"ФормаМонитора",
					Ложь
					);

	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("ПросмотрВсе", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ИмяФормы", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "", ИмяФормы="",ПросмотрВсе=Истина)
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	НоваяКоманда.ИмяФормы = ИмяФормы;
	НоваяКоманда.ПросмотрВсе = ПросмотрВсе;
	
КонецПроцедуры

Функция ИнформацияПоИсторииИзменений()
	Возврат "
	| <div style='text-indent: 25px;'>Данная обработка позволяет загружать данные из консоли кластера 1С с использованием клиента rac.exe и службы ras.exe</div>
	| <div style='text-indent: 25px;'>Форма 'Монитор RAS 1C' повзоляет выполнять мониторинг, просмотр истории, и некоторые оперативные действия (завершения сеанса пользователя)</div>
	| <div style='text-indent: 25px;'>Форма 'Настройка Монитор RAS 1C' позволяет выполнить настройку загрузки данных, определения агрегирующих функций замеров и их сохранение</div>
	| <div style='text-indent: 25px;'>Для работы на сервере 1С должен быть обязательно запущена служба ras. Команда для установки может иметь следующий формат:<br />
	|  <code>sc create ""1C:Enterprise RAS"" binpath= ""\""C:/Program Files/1cv8/8.3.10.2466/bin/ras.exe\"" cluster --service --port=1545 localhost:1540""</code> <br /> (обратите внимние, что после свойства 'binpath=' должен идти пробел)</div>
	| <hr />
	| Подробную информацию смотрите по адресу интернет: <a target='_blank' href='https://github.com/Polyplastic/1c-parsing-tech-log'>https://github.com/Polyplastic/1c-parsing-tech-log</a>";
	
КонецФункции

Процедура ВыполнитьКоманду(Знач ИдентификаторКоманды, ПараметрыКоманды=Неопределено) Экспорт
	
	Если ИдентификаторКоманды="ПолучитьДанныеКластераФоново" Тогда
		
		// только при наличии параметров
		Если ПараметрыКоманды=Неопределено Тогда
			Возврат;
		КонецЕсли;
		list = ПараметрыКоманды.list;
		cluster = ПараметрыКоманды.cluster;
		мПараметры = ПараметрыКоманды.мПараметры;
		АдресХранилища = ПараметрыКоманды.АдресХранилища;
		СтруктураДанныхОтвета = ПолучитьСписок(мПараметры,list);
		СтруктураДанныхОтвета.Вставить("list",list);
		СтруктураДанныхОтвета.Вставить("cluster",cluster);
		ПараметрыКоманды.Вставить("РезультатВыполнения",СтруктураДанныхОтвета);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаДаных

Процедура ВыполнитьЗагрузкуДанных(Замер,ДополнительнаяОбработка=Неопределено) Экспорт
	
	ЗагрузитьДанныеВЗамерСервер(Замер);	
	
КонецПроцедуры

Функция ЗагрузитьДанныеВЗамерСервер(Замер) Экспорт

	// получим настройки загрузки
	мНастройка = УправлениеХранилищемНастроекВызовСервера.ДанныеИзБезопасногоХранилища(Замер);
	
	Если мНастройка=Неопределено Тогда
		ЗаписьЖурналаРегистрации("ЗагрузитьДанныеВЗамерСервер",УровеньЖурналаРегистрации.Ошибка,Неопределено,Замер,"Не созданы настройки для операции произвольной загрузки по замеру ("+Замер+")");
		Возврат 0;
	КонецЕсли;
	
	// создадим если нужно
	RAS_СоздатьСвойстваВБазеЕслиНужно();
	
	РазмерФайла = 0;
	ПрочитаноСтрок = 0;
	ДатаНачалаЧтения = ТекущаяДата();
	ДатаПрочитанныхДанных = ДатаНачалаЧтения;
	КодировкаТекстаФайла = мНастройка.КодировкаТекстаФайла;
	ВерсияПлатформы1С = мНастройка.ВерсияПлатформы1С;
	ИмяСервера = мНастройка.ИмяСервера;
	ПортRAS = мНастройка.ПортRAS;
	РежимОбработкиДанных = мНастройка.РежимОбработкиДанных;
	ПутьКИсполняемомуФайлуRAC = мНастройка.ПутьКИсполняемомуФайлуRAC;
	СохранятьВсеДетальныеЗаписи = мНастройка.СохранятьВсеДетальныеЗаписи;

	Корзина = мНастройка.Корзина;
	Кластеры = мНастройка.Кластеры;  		
	
	//инициализация фильтров
	РеквизитыЗамера = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Замер, "ФильтрТипСобытия,ФильтрСвойстваСобытия,ФильтрСвойстваСобытияКроме,ФильтрДлительность,НачалоПериода,КонецПериода,ТипЗамера,ДополнительнаяОбработка");
	НачалоПериода 	= РеквизитыЗамера.НачалоПериода;
	КонецПериода 	= РеквизитыЗамера.КонецПериода;
	РеквизитыЗамера.Вставить("ФильтрТипСобытия", РеквизитыЗамера.ФильтрТипСобытия.Получить());
	ЕстьФильтрТипСобытия = РеквизитыЗамера.ФильтрТипСобытия<>Неопределено И РеквизитыЗамера.ФильтрТипСобытия.Количество()>0;
	ЕстьФильтрСвойстваСобытия = ЗначениеЗаполнено(РеквизитыЗамера.ФильтрСвойстваСобытия);
	ЕстьФильтрДлительность = ЗначениеЗаполнено(РеквизитыЗамера.ФильтрДлительность); 
	АдресURL = "/Замер/"+Строка(Замер.UUID());
	
	ФайлЗамера = Справочники.ФайлыЗамера.ПолучитьФайлПоПолномуИмени(Замер, АдресURL);
	
	//еще раз проверим прочитан полностью
	СостояниеЧтения = РегистрыСведений.СостояниеЧтения.ПолучитьСостояние(ФайлЗамера);
	Если СостояниеЧтения.ЧтениеЗавершено Тогда
		Возврат 0;
	КонецЕсли;
	
	
	ПрочитаноСтрок = СостояниеЧтения.ПрочитаноСтрок;
	
	// кешируем быстрый поиск
	СоответсвиеКластеров = новый Соответствие;
	Для каждого стр из Кластеры Цикл
		СоответсвиеКластеров.Вставить(стр.cluster,стр);
	КонецЦикла;	
	
	// определим из корзины, какие данные будем сохранять
	СоответсвиеКластеровКорзины = новый Соответствие;
	Для каждого стр из Корзина Цикл
		масс = СоответсвиеКластеровКорзины.Получить(стр.cluster);
		Если масс=Неопределено Тогда
			масс = новый Соответствие;
			масс.Вставить(стр.list,стр.list);
			СоответсвиеКластеровКорзины.Вставить(стр.cluster,масс);
		Иначе
			масс.Вставить(стр.list,стр.list);
			СоответсвиеКластеровКорзины.Вставить(стр.cluster,масс);
		КонецЕсли;
	КонецЦикла;
	
	СоответствиеТиповСобытий = новый Соответствие;
	
	Для каждого стр из Корзина Цикл
		СоответствиеТиповСобытий.Вставить(стр.list);
	КонецЦикла;
	
	// найдем типы событий
	Для каждого стр из СоответствиеТиповСобытий Цикл
		СоответствиеТиповСобытий.Вставить(стр.Ключ,ПолучитьСоздатьТипСобытия(стр.Ключ));
	КонецЦикла;
	
	вхПараметры = новый Структура();
	вхПараметры.Вставить("ПутьКИсполняемомуФайлуRAC",""""+мНастройка.ПутьКИсполняемомуФайлуRAC+"""");
	вхПараметры.Вставить("КодировкаТекстаФайла",мНастройка.КодировкаТекстаФайла);
	
	СтруктураЗаписи 			= ОбновлениеДанных.ПолучитьСтруктуруЗаписиСправочник();
	СтруктураЗаписи.Владелец 	= Замер;
	СтруктураЗаписи.Файл 		= ФайлЗамера;
	СтруктураЗаписи.ДатаСобытия = ТекущаяДата();
	
	ПолноеСоответствиеСвойств = ПолучитьПолноеСоответствиеСвойств();	
	
	// погнали делать запросы
	Для каждого стр из СоответсвиеКластеровКорзины Цикл
		
		парам_кластера = СоответсвиеКластеров.Получить(стр.Ключ);
		Если парам_кластера=Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		cluster = парам_кластера.cluster;
		вхПараметры.Вставить("server",парам_кластера.server);
		вхПараметры.Вставить("port_ras",XMLСтрока(парам_кластера.port_ras));
		вхПараметры.Вставить("cluster",парам_кластера.cluster);
		вхПараметры.Вставить("cluster_user",парам_кластера.cluster_user);
		вхПараметры.Вставить("cluster_pwd",парам_кластера.cluster_pwd);
		
		
		// пройдемся по всем спикам
		Для каждого эл_спис из стр.Значение Цикл
			
			ПрочитаноСтрок = ПрочитаноСтрок+1;
			СтруктураДанныхОтвета = ПолучитьСписок(вхПараметры,эл_спис.Значение); 
			СтруктураЗаписи.Вставить("ДополнительныеСвойства",новый Структура);
			Наименование = Формат(СтруктураЗаписи.ДатаСобытия,"ДФ=yyyy-MM-dd:H-mm-ss")+"/"+эл_спис.Значение;
			СтруктураЗаписи.ТипСобытия = СоответствиеТиповСобытий.Получить(эл_спис.Значение);
			
			// будем сохранять, если стоит условие иначе только агрегация
			//TODO: добавить возможность сохранения выбранных не агрегированных строк
			Если СохранятьВсеДетальныеЗаписи=Истина Тогда
				
				СтруктураЗаписи.ДополнительныеСвойства.Вставить("Наименование",Наименование);
				
	
				// сохраняем все данные
				Для каждого стр_замер из СтруктураДанныхОтвета.МассивСоответствиеДанных Цикл
					//часть реквизитов будет одинакова для всего файла
					СтруктураЗаписи.НомерСтрокиФайла = стр_замер.Получить("line-number");
					СтруктураЗаписи.КлючевыеСвойства.Очистить(); 	
					// ТипСобытия тип списка добавить
					ДобавитьСвойстваСерверКластер(парам_кластера, СтруктураЗаписи);
					
					Для каждого эл_св из стр_замер Цикл
						Описание = ПолноеСоответствиеСвойств.Получить(эл_св.Ключ);
						Свойство = ПолучитьСвойствоБезопасно(?(Описание=Неопределено,Неопределено,Описание.Синоним),эл_св.Ключ);
						СтруктураЗаписи.КлючевыеСвойства.Вставить(Свойство, эл_св.Значение);					
					КонецЦикла;
					
					Справочники.СобытияЗамера.ЗаписатьСобытиеЧисло(СтруктураЗаписи);					
				КонецЦикла; 
				
			КонецЕсли;
			
			//часть реквизитов будет одинакова для всего файла
			СтруктураЗаписи.КлючевыеСвойства.Очистить();
			СтруктураЗаписи.НомерСтрокиФайла = 0;
			СтруктураЗаписи.ДополнительныеСвойства.Вставить("Наименование",Наименование+"/агрегир");
			
			// пройдемся по агрегирующим функциям                        
			МассивСтруктурАгрегацииДанных = ВычислитьФункцииАгрегации(СтруктураДанныхОтвета.МассивСоответствиеДанных,Корзина,эл_спис.Значение,cluster);
			ДобавитьСвойстваСерверКластер(парам_кластера, СтруктураЗаписи);			
			
			// только агрегирующие функции 
			Для каждого эл_агрег из МассивСтруктурАгрегацииДанных Цикл
				Описание = ПолноеСоответствиеСвойств.Получить(эл_агрег.name);
				Свойство = ПолучитьСвойствоБезопасно(?(Описание=Неопределено,Неопределено,Описание.Синоним),эл_агрег.name,эл_агрег.func);
				СтруктураЗаписи.КлючевыеСвойства.Вставить(Свойство, эл_агрег.value);
			КонецЦикла;
			
			Если МассивСтруктурАгрегацииДанных.Количество()>0 Тогда 
				Справочники.СобытияЗамера.ЗаписатьСобытиеЧисло(СтруктураЗаписи);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;	

	
	// Обновление инфорации о количестве прочитанных строк
	РегистрыСведений.СостояниеЧтения.УстановитьСостояние(
		ФайлЗамера, 
		ДатаНачалаЧтения,
		ПрочитаноСтрок, 
		ДатаНачалаЧтения,
		РазмерФайла,
		ДатаПрочитанныхДанных);
		

	Возврат 0;
	
	
КонецФункции

Функция ПолучитьСвойствоБезопасно(Знач name_rus, Знач synonim_eng,Знач func="") Экспорт
	
	Попытка
		synonim_eng = synonim_eng + ?(func="",""," ("+ func+")");
		Если ЗначениеЗаполнено(name_rus) Тогда			
			name_rus = name_rus + ?(func="",""," ("+ func+")");
			Свойство = СправочникиСерверПовтИсп.ПолучитьСвойствоПоИмениСинониму(name_rus,synonim_eng);
		Иначе
			Свойство = СправочникиСерверПовтИсп.ПолучитьСвойство(synonim_eng);
		КонецЕсли;
	Исключение
		// совместимость со старыми версиями
		Свойство = СправочникиСерверПовтИсп.ПолучитьСвойство(synonim_eng);
	Конецпопытки;

	Возврат Свойство;
	
КонецФункции

Процедура ДобавитьСвойстваСерверКластер(Знач парам_кластера, Знач СтруктураЗаписи)
	
	Перем Свойство;
	
	// вставим сервер и кластер
	Свойство = ПолучитьСвойствоБезопасно("сервер","server");
	СтруктураЗаписи.КлючевыеСвойства.Вставить(Свойство, парам_кластера.server);					
	
	Свойство = ПолучитьСвойствоБезопасно("кластер","cluster");
	СтруктураЗаписи.КлючевыеСвойства.Вставить(Свойство, парам_кластера.name);

	Свойство = ПолучитьСвойствоБезопасно("ключ","key");
	СтруктураЗаписи.КлючевыеСвойства.Вставить(Свойство, парам_кластера.server+"("+Формат(парам_кластера.port_ras,"ЧРГ=' '")+")->"+парам_кластера.name);

КонецПроцедуры

Функция ПолучитьСоздатьТипСобытия(Знач Наименование)
	ТипСобытия = Неопределено;
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	События.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.События КАК События
	|ГДЕ
	|	События.Наименование = &Наименование
	|	И НЕ События.ПометкаУдаления";
	Запрос.УстановитьПараметр("Наименование",Наименование);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТипСобытия = Выборка.Ссылка;
	Иначе
		ТипОбъект = Справочники.События.СоздатьЭлемент();
		ТипОбъект.Код = Наименование;
		ТипОбъект.Наименование = Наименование;
		ТипОбъект.Записать();
		ТипСобытия = ТипОбъект.Ссылка;
	КонецЕсли;
	
	Возврат ТипСобытия; 
КонецФункции

Процедура RAS_СоздатьСвойстваВБазеЕслиНужно() Экспорт
	
	// проверим, что хотя-бы один реквизит есть в базе
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	Свойства.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Свойства КАК Свойства
	|ГДЕ
	|	НЕ Свойства.ПометкаУдаления
	|	И (Свойства.Наименование = &Наименование
	|			ИЛИ Свойства.Синоним = &Синоним)";
	Запрос.УстановитьПараметр("Наименование","cpu-time-last-5min");
	Запрос.УстановитьПараметр("Синоним","cpu-time-last-5min");
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	СоответствиеСвойств = ПолучитьПолноеСоответствиеСвойств();
	
	Для каждого стр из  СоответствиеСвойств Цикл
		Если НЕ ЗначениеЗаполнено(стр.Ключ) Тогда
			Продолжить;
		КонецЕсли;
		
		СвойствоОбъект = Справочники.Свойства.СоздатьЭлемент();
		СвойствоОбъект.Наименование = стр.Значение.Синоним; // в синониме русский, а мы хотим наоборот
		СвойствоОбъект.Код = стр.Ключ;
		СвойствоОбъект.Синоним = стр.Ключ;
		
		Если стр.Значение.Тип = "Число" Тогда
			СвойствоОбъект.ЧисловойРежим = Истина;      
		КонецЕсли;           
		
		СвойствоОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область RAS

Функция ПолучитьСписок(вхПараметры,list) экспорт
	
	мПараметры = новый Структура();
	мПараметры.Вставить("ПутьКИсполняемомуФайлуRAC",""""+вхПараметры.ПутьКИсполняемомуФайлуRAC+"""");
	мПараметры.Вставить("server",вхПараметры.server);
	мПараметры.Вставить("port_ras",XMLСтрока(вхПараметры.port_ras));
	мПараметры.Вставить("cluster",вхПараметры.cluster);
	мПараметры.Вставить("cluster_user",вхПараметры.cluster_user);
	мПараметры.Вставить("cluster_pwd",вхПараметры.cluster_pwd);
	мПараметры.Вставить("КодировкаТекстаФайла",вхПараметры.КодировкаТекстаФайла);
	
	ТекстНачалаСтроки = list;
	Если Найти(list,"licenses") Тогда
		Массив = СтрРазделить(list," ",Ложь);
		КомандаКонсоли = Массив[0]+" list licenses"; 
		ТекстНачалаСтроки = Массив[0];
	иначе
		КомандаКонсоли = list+" list"; 
	КонецЕсли;
	
	СтруктураДанныхОтвета = RAS_ПрочитатьДанныеОтветаКоманды(КомандаКонсоли,мПараметры,ТекстНачалаСтроки);
	
	Возврат СтруктураДанныхОтвета;	
	
КонецФункции

Функция ЗавершитьСеансПользователя(вхПараметры) Экспорт
	
	мПараметры = новый Структура();
	мПараметры.Вставить("ПутьКИсполняемомуФайлуRAC",""""+вхПараметры.ПутьКИсполняемомуФайлуRAC+"""");
	мПараметры.Вставить("server",вхПараметры.server);
	мПараметры.Вставить("port_ras",XMLСтрока(вхПараметры.port_ras));
	мПараметры.Вставить("cluster",вхПараметры.cluster);
	мПараметры.Вставить("cluster_user",вхПараметры.cluster_user);
	мПараметры.Вставить("cluster_pwd",вхПараметры.cluster_pwd);
	мПараметры.Вставить("session",вхПараметры.session);
	мПараметры.Вставить("КодировкаТекстаФайла",вхПараметры.КодировкаТекстаФайла);
	
	СтруктураДанныхОтвета = RAS_ПрочитатьДанныеОтветаКоманды("session terminate", мПараметры, "session");
	
	Возврат СтруктураДанныхОтвета;	
КонецФункции

Функция ПолучитьСписокСерверов(вхПараметры) Экспорт	
	мПараметры = новый Структура();
	мПараметры.Вставить("ПутьКИсполняемомуФайлуRAC",""""+вхПараметры.ПутьКИсполняемомуФайлуRAC+"""");
	мПараметры.Вставить("server",вхПараметры.server);
	мПараметры.Вставить("port_ras",XMLСтрока(вхПараметры.port_ras));
	мПараметры.Вставить("cluster",вхПараметры.cluster);
	мПараметры.Вставить("cluster_user",вхПараметры.cluster_user);
	мПараметры.Вставить("cluster_pwd",вхПараметры.cluster_pwd);
	мПараметры.Вставить("КодировкаТекстаФайла",вхПараметры.КодировкаТекстаФайла);
	
	СтруктураДанныхОтвета = RAS_ПрочитатьДанныеОтветаКоманды("server list", мПараметры,"server");
	
	Возврат СтруктураДанныхОтвета;
	
КонецФункции


Функция RAS_ПрочитатьДанныеОтветаКоманды(Знач ИмяШаблона, мПараметры, Знач ТекстНачалаСтроки)
	
	НачалоЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
	ТекстОшибки = "";
	
	// временные файлы
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	ИмяВременногоФайлаCMD = ПолучитьИмяВременногоФайла("cmd");	
	мПараметры.Вставить("ИмяВременногоФайла",ИмяВременногоФайла);
	СоответсвиеСинонимовСвойств = ПолучитьПолноеСоответствиеСвойств();
	
	// шаблон запроса
	Шаблон = RAS_ПолучитьТекстШаблона(ИмяШаблона);
	ТекстКоманды = RAS_ПодставитьПараметрыВШаблон(Шаблон,мПараметры);
	
	// выполняем запрос
	СоздатьCMD(ИмяВременногоФайлаCMD,ТекстКоманды);
	ЗапуститьПриложение(ИмяВременногоФайлаCMD,,Истина);
	
	// читаем файл
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	Если НЕ ЗначениеЗаполнено(мПараметры.КодировкаТекстаФайла) Тогда
		мПараметры.КодировкаТекстаФайла = "UTF8";
	КонецЕсли;
	Попытка
		КодировкаТекстаФайла = КодировкаТекста[мПараметры.КодировкаТекстаФайла];
	Исключение
		КодировкаТекстаФайла = мПараметры.КодировкаТекстаФайла;
	КонецПопытки;
	ТекстовыйДокумент.Прочитать(ИмяВременногоФайла,КодировкаТекстаФайла);
	МассивСоответствиеДанных = новый Массив;
	ПервыеДанные = Истина;
	СоответствиеДанных = новый Соответствие;
	номерстроки = 0;
	
	//TODO: обработать событие ошибки
	Для ш=0 по ТекстовыйДокумент.КоличествоСтрок() Цикл
		Строка = ТекстовыйДокумент.ПолучитьСтроку(ш);
		
		МассивДанных = СтрРазделить(Строка,":");
		Если МассивДанных.Количество()<2 Тогда
			Продолжить;
		КонецЕсли;
		
		// имя параметра
		ИмяПараметра = СокрЛП(МассивДанных[0]);
		
		// новая строка
		Если ИмяПараметра=ТекстНачалаСтроки Тогда
			Если ПервыеДанные=Ложь Тогда
				МассивСоответствиеДанных.Добавить(СоответствиеДанных);				
			КонецЕсли;
			СоответствиеДанных = новый Соответствие;
			номерстроки = номерстроки+1;
			СоответствиеДанных.Вставить("decision","");
			СоответствиеДанных.Вставить("line-number",номерстроки);
			ПервыеДанные = Ложь;
		КонецЕсли;  
		
		ПозицияДвоеточия = Найти(Строка,":");
		ДанныеПараметра = СокрЛП(Прав(Строка,СтрДлина(Строка)-ПозицияДвоеточия));
		НРегДанныеПараметра = НРег(ДанныеПараметра);
		Описание = СоответсвиеСинонимовСвойств.Получить(ИмяПараметра);
		// попробуем привести к строке
		Попытка
			Если Описание=Неопределено Тогда
					// скорее всего время
				Если Найти(ДанныеПараметра,":") И Найти(ДанныеПараметра,"-") И Найти(ДанныеПараметра,"T") Тогда
					СоответствиеДанных.Вставить(ИмяПараметра,ПреобразоватьСтрокуВДату(ДанныеПараметра));		
				ИначеЕсли НРегДанныеПараметра="yes" ИЛИ НРегДанныеПараметра="no" ИЛИ  НРегДанныеПараметра="да" ИЛИ НРегДанныеПараметра="нет" Тогда
					СоответствиеДанных.Вставить(ИмяПараметра,?(НРегДанныеПараметра="yes" ИЛИ НРегДанныеПараметра="да",Истина,Ложь));
				ИначеЕсли НЕ ЗначениеЗаполнено(ДанныеПараметра) ИЛИ Найти(ДанныеПараметра,".") ИЛИ Найти(ДанныеПараметра,"/") // это строка
					ИЛИ Найти(ДанныеПараметра,"\") ИЛИ Найти(ДанныеПараметра,":") Тогда
					СоответствиеДанных.Вставить(ИмяПараметра,ДанныеПараметра);
				Иначе 
					СоответствиеДанных.Вставить(ИмяПараметра,Число(ДанныеПараметра));
					// приведем к значение к секундам
					Если ИмяПараметра="db-proc-took" 
					ИЛИ ИмяПараметра="duration-current"
					ИЛИ ИмяПараметра="duration-current-dbms" Тогда
						Значение = Окр(СоответствиеДанных.Получить(ИмяПараметра)/1000,3,1);
						СоответствиеДанных.Вставить(ИмяПараметра,Значение);
					КонецЕсли;		
				КонецЕсли;
			Иначе
				Если Описание.Тип="Число" Тогда
					СоответствиеДанных.Вставить(ИмяПараметра,Число(ДанныеПараметра));
					Если ЗначениеЗаполнено(Описание.Коэффициент) Тогда
						Значение = Окр(СоответствиеДанных.Получить(ИмяПараметра)/Описание.Коэффициент,3,1);
						СоответствиеДанных.Вставить(ИмяПараметра,Значение);
					КонецЕсли;
				ИначеЕсли Описание.Тип="Дата" ИЛИ Описание.Тип="ДатаВремя" Тогда
					СоответствиеДанных.Вставить(ИмяПараметра,ПреобразоватьСтрокуВДату(ДанныеПараметра));
				ИначеЕсли Описание.Тип="Булево" Тогда
					СоответствиеДанных.Вставить(ИмяПараметра,?(ДанныеПараметра="yes" ИЛИ ДанныеПараметра="да",Истина,Ложь));
				Иначе 
					СоответствиеДанных.Вставить(ИмяПараметра,ДанныеПараметра);
				КонецЕсли; 
			КонецЕсли;
		Исключение
			СоответствиеДанных.Вставить(ИмяПараметра,ДанныеПараметра);		
		Конецпопытки;
		
	КонецЦикла;
	
	// Добваим ключ подсветки строки
	СоответствиеДанных.Вставить("decision","");
	// Добваим номер строки
	СоответствиеДанных.Вставить("line-number",номерстроки);
	МассивСоответствиеДанных.Добавить(СоответствиеДанных);	
	
	Длительность = (ТекущаяУниверсальнаяДатаВМиллисекундах()-НачалоЗамера)/1000;
	
	// удалим
	Попытка
		УдалитьФайлы(ИмяВременногоФайла);
		УдалитьФайлы(ИмяВременногоФайлаCMD);
	Исключение
	КонецПопытки;
	
	СтруктураДанныхОтвета = новый Структура();
	СтруктураДанныхОтвета.Вставить("МассивСоответствиеДанных",МассивСоответствиеДанных);
	СтруктураДанныхОтвета.Вставить("Длительность",Длительность);
	СтруктураДанныхОтвета.Вставить("duration",Длительность);
	СтруктураДанныхОтвета.Вставить("ТекстОшибки",ТекстОшибки);
	
	Возврат СтруктураДанныхОтвета;

КонецФункции

Функция  RAS_ПодставитьПараметрыВШаблон(Знач Шаблон, Знач мПараметры)
	
	Текст = Шаблон;
	
	// пароль должен быть вместе с пользователем, иначе должно быть пусто
	Если мПараметры.Свойство("cluster_user") И НЕ ЗначениеЗаполнено(мПараметры.cluster_user) ИЛИ
		мПараметры.Свойство("cluster_pwd") И НЕ ЗначениеЗаполнено(мПараметры.cluster_pwd) Тогда
		Текст = СтрЗаменить(Текст,"--cluster-user=%cluster_user%","");
		Текст = СтрЗаменить(Текст,"--cluster-pwd=%cluster_pwd%","");
	КонецЕсли;
	
	Для каждого стр из мПараметры Цикл
		Текст = СтрЗаменить(Текст,"%"+стр.Ключ+"%",стр.Значение);
	КонецЦикла;
	
	Возврат Текст;
КонецФункции

Функция RAS_ПолучитьТекстШаблона(Знач ИмяШаблона) Экспорт
	
	Текст = "";
	
	Если ИмяШаблона="cluster list" Тогда
		Текст = "%ПутьКИсполняемомуФайлуRAC% cluster %server%:%port_ras% list out->%ИмяВременногоФайла%";
	ИначеЕсли ИмяШаблона="session list licenses" Тогда
		Текст = "%ПутьКИсполняемомуФайлуRAC% session %server%:%port_ras% --cluster=%cluster% --cluster-user=%cluster_user% --cluster-pwd=%cluster_pwd% list --licenses out->%ИмяВременногоФайла%";
	ИначеЕсли ИмяШаблона="session list" Тогда
		Текст = "%ПутьКИсполняемомуФайлуRAC% session %server%:%port_ras% --cluster=%cluster% --cluster-user=%cluster_user% --cluster-pwd=%cluster_pwd% list out->%ИмяВременногоФайла%";
	ИначеЕсли ИмяШаблона="session terminate" Тогда
		Текст = "%ПутьКИсполняемомуФайлуRAC% session %server%:%port_ras% --cluster=%cluster% --cluster-user=%cluster_user% --cluster-pwd=%cluster_pwd% terminate --session=%session% out->%ИмяВременногоФайла%";
	ИначеЕсли ИмяШаблона="connection list" Тогда
		Текст = "%ПутьКИсполняемомуФайлуRAC% connection %server%:%port_ras% --cluster=%cluster% --cluster-user=%cluster_user% --cluster-pwd=%cluster_pwd% list out->%ИмяВременногоФайла%";
	ИначеЕсли ИмяШаблона="infobase list" Тогда
		Текст = "%ПутьКИсполняемомуФайлуRAC% infobase %server%:%port_ras% --cluster=%cluster% --cluster-user=%cluster_user% --cluster-pwd=%cluster_pwd% summary list out->%ИмяВременногоФайла%";
	ИначеЕсли ИмяШаблона="server list" Тогда
		Текст = "%ПутьКИсполняемомуФайлуRAC% server %server%:%port_ras% --cluster=%cluster% --cluster-user=%cluster_user% --cluster-pwd=%cluster_pwd% list out->%ИмяВременногоФайла%";
	ИначеЕсли ИмяШаблона="process list licenses" Тогда
		Текст = "%ПутьКИсполняемомуФайлуRAC% process %server%:%port_ras% --cluster=%cluster% --cluster-user=%cluster_user% --cluster-pwd=%cluster_pwd% list --licenses out->%ИмяВременногоФайла%";
	ИначеЕсли ИмяШаблона="process list" Тогда
		Текст = "%ПутьКИсполняемомуФайлуRAC% process %server%:%port_ras% --cluster=%cluster% --cluster-user=%cluster_user% --cluster-pwd=%cluster_pwd% list out->%ИмяВременногоФайла%";
	ИначеЕсли ИмяШаблона="manager list" Тогда
		Текст = "%ПутьКИсполняемомуФайлуRAC% manager %server%:%port_ras% --cluster=%cluster% --cluster-user=%cluster_user% --cluster-pwd=%cluster_pwd% list out->%ИмяВременногоФайла%";
	КонецЕсли; 	
	
	Возврат Текст;
КонецФункции

Процедура СоздатьCMD(Знач ИмяФайла, Знач Команда)
	
	ЗаписатьФайлВформате_UTF8_без_BOM("cmd.exe /c " + Команда, ИмяФайла);
	
КонецПроцедуры

функция ЗаписатьФайлВформате_UTF8_без_BOM(текст,полноеИмяФайла)

    // записываем в файл с символами BOM в начале файле	
    ТекстовыйФайлUTF8_Bom = Новый ТекстовыйДокумент();
    ТекстовыйФайлUTF8_Bom.ДобавитьСтроку(текст);
    ТекстовыйФайлUTF8_Bom.Записать(полноеИмяФайла,"UTF-8");
	
    // открываем файл и считываем символы после символов BOM
    Данные = Новый ДвоичныеДанные(полноеИмяФайла);
    Строка64=Base64Строка(Данные);
    Строка64=Прав(Строка64,СтрДлина(Строка64)-4);
    ДанныеНаЗапись=Base64Значение(Строка64);
    ДанныеНаЗапись.Записать(полноеИмяФайла); // записываем
	
КонецФункции

// Функция, позволяющая завершить некий процесс на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
//    ProccessName - Имя процесса, который необходимо завершить.
// Возвращаемое значение:
//    Количество завершенных процессов.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
Функция Computer_StartProccess(Знач Command,Computer = ".",Сообщение = "") Экспорт
    
    Попытка
        PID = 0 ;
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2:Win32_Process");
        WinMGMT.Create(Command,,,PID);
 
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Сообщение = ТекстОшибки;
		#Если Сервер Тогда
			ЗаписьЖурналаРегистрации("МониторRAS_1C.Computer_StartProccess",УровеньЖурналаРегистрации.Ошибка,,ТекстОшибки,,);
		#КонецЕсли
		Сообщить(ТекстОшибки);
		PID = -1;
    КонецПопытки;

    Возврат PID;

КонецФункции

Функция ПреобразоватьСтрокуВДату(Знач ДатаСтрокой) Экспорт
	Дата = Дата('00010101000000');
	Попытка
		ДатаСтрокой = СтрЗаменить(ДатаСтрокой,"-","");
		ДатаСтрокой = СтрЗаменить(ДатаСтрокой,"T","");
		ДатаСтрокой = СтрЗаменить(ДатаСтрокой,":","");
		Дата = Дата(ДатаСтрокой);
	Исключение
		Возврат Дата('00010101000000');
	КонецПопытки;
	Возврат Дата;
КонецФункции

Функция ПолучитьСоответсвиеСинонимовСвойств() Экспорт
	
	Соответствие = новый Соответствие;
	
	Соответствие.Вставить("decision","проблема (уровень)");
	Соответствие.Вставить("line-number","номер строки");
	Соответствие.Вставить("server","сервер");
	Соответствие.Вставить("server-name","сервер имя");
	Соответствие.Вставить("session","сессия");
	Соответствие.Вставить("connection","соединение");
	Соответствие.Вставить("process","процесс");
	Соответствие.Вставить("cluster","кластер");
	Соответствие.Вставить("cluster-name","кластер имя");
	Соответствие.Вставить("infobase","инф. база");
	Соответствие.Вставить("infobase-name","инф. база  имя");
	
	//infobase
	Соответствие.Вставить("name","имя");
	Соответствие.Вставить("descr","описание");
	
	//session
	Соответствие.Вставить("session-id","номер сеанса");	
	Соответствие.Вставить("started-at","время начала");	
	Соответствие.Вставить("locale","язык");	
	Соответствие.Вставить("host","компьютер");	
	Соответствие.Вставить("last-active-at","последняя активность");	
	Соответствие.Вставить("app-id","приложение");	
	Соответствие.Вставить("user-name","пользователь");	
	Соответствие.Вставить("hibernate","спящий");	
	Соответствие.Вставить("cpu-time-last-5min","процессорное время (5 мин)");
	Соответствие.Вставить("cpu-time-total","процессорное время (всего)");	
	Соответствие.Вставить("hibernate-session-terminate-time","завершить через");
	Соответствие.Вставить("passive-session-hibernate-time","заснуть через");
	Соответствие.Вставить("memory-total","память (всего)");
	Соответствие.Вставить("memory-last-5min","память (5 мин)");
	Соответствие.Вставить("memory-current","память (текущая)");	
	Соответствие.Вставить("read-total","чтение (всего)");
	Соответствие.Вставить("read-current","чтение (текущее)");
	Соответствие.Вставить("read-last-5min","чтение (5 мин)");	
	Соответствие.Вставить("duration-all-dbms","время вызовов СУБД (всего)");
	Соответствие.Вставить("dbms-bytes-last-5min","данных СУБД (5 мин)");
	Соответствие.Вставить("duration-last-5min-dbms","время вызовов СУБД (5 мин)");
	Соответствие.Вставить("dbms-bytes-all","данных СУБД (всего)");
	Соответствие.Вставить("write-current","запись (текущая)");
	Соответствие.Вставить("write-total","запись (всего)");
	Соответствие.Вставить("write-last-5min","запсиь (5 мин)");
	Соответствие.Вставить("cpu-time-total","процессорное время (всего)");
	Соответствие.Вставить("cpu-time-current","процессорное время (текущее)");
	Соответствие.Вставить("cpu-time-last-5min","процессорное (5 мин)");
	
	Соответствие.Вставить("duration-current-service","время вызовов сервисов (текущее)");
	Соответствие.Вставить("duration-last-5min-service","время вызовов сервисов (5 мин)");
	Соответствие.Вставить("duration-all-service","время вызовов сервисов (всего)");

	
	
	Соответствие.Вставить("duration-current","время вызова (текущее)");
	Соответствие.Вставить("db-proc-info","соединение с СУБД");
	Соответствие.Вставить("db-proc-took","захвачено СУБД");
	
	Соответствие.Вставить("bytes-all","объем данных (всего)");
	Соответствие.Вставить("bytes-last-5min","объем данных (5 мин)");
	
	Соответствие.Вставить("calls-all","количество вызовов (всего)");
	Соответствие.Вставить("calls-last-5min","количество вызовов (5 мин)");
	
	Соответствие.Вставить("duration-all","время вызовов (всего)");
	Соответствие.Вставить("duration-last-5min","время вызовов (5 мин)");
	
	Соответствие.Вставить("db-proc-took-at","время захвата СУБД");
	
	Соответствие.Вставить("duration-current-dbms","время вызова СУБД (текущее)");
	//Соответствие.Вставить("","");
	//Соответствие.Вставить("","");
	//Соответствие.Вставить("","");     			
	
	//connection
	Соответствие.Вставить("session-number","сеанс");
	Соответствие.Вставить("connected-at","начало работы");
	Соответствие.Вставить("application","приложение");

	//process
	Соответствие.Вставить("port","порт");
	Соответствие.Вставить("memory-size","память КБ");
	Соответствие.Вставить("pid","PID");
	Соответствие.Вставить("running","активен");
	Соответствие.Вставить("is-enable","включен");
	Соответствие.Вставить("use","использование");
	Соответствие.Вставить("available-perfomance","дост. произв.");
	Соответствие.Вставить("connections","кол-во соединений");
	Соответствие.Вставить("issued-by-server","выдано сервером");
	Соответствие.Вставить("license-type","тип лицензии");
	Соответствие.Вставить("net","сетевая");
	Соответствие.Вставить("series","серии");
	Соответствие.Вставить("full-name","полное имя");
	
	
	Соответствие.Вставить("current-service-name","имя текущего сервиса");
	Соответствие.Вставить("data-separation","разделитель данных");
	
	Возврат Соответствие;
	
КонецФункции

Функция ПолучитьПолноеСоответствиеСвойств() Экспорт
	
	Соответствие = новый Соответствие();
	
	ТабДокумент = ПолучитьМакет("Макет");
	ТаблицаЗначений = ПреобразоватьТабличныйДокументВТаблицуЗначений(ТабДокумент);
	
	Для каждого стр из ТаблицаЗначений Цикл
		Структура = новый Структура("Свойство,Синоним,Тип,Коэффициент,Комментарий",стр[1],стр[2],стр[4],стр[5],стр[6]);
		Если ЗначениеЗаполнено(Структура.Коэффициент) Тогда
			Структура.Коэффициент = Число(Структура.Коэффициент);
		Иначе
			Структура.Коэффициент = 0;
		КонецЕсли;
		Соответствие.Вставить(стр[1],Структура);		
	КонецЦикла;

	
	Возврат Соответствие;
	
КонецФункции

Функция ПреобразоватьТабличныйДокументВТаблицуЗначений(ТабДокумент)
	ПоследняяСтрока = ТабДокумент.ВысотаТаблицы;
	ПоследняяКолонка = ТабДокумент.ШиринаТаблицы;
	ОбластьЯчеек = ТабДокумент.Область(1, 1, ПоследняяСтрока, ПоследняяКолонка);
	// Создаем описание источника данных на основании области ячеек табличного документа.
	ИсточникДанных = Новый ОписаниеИсточникаДанных(ОбластьЯчеек);
	// Создаем объект для интеллектуального построения отчетов,
	// указываем источник данных и выполняем построение отчета.
	ПостроительОтчета = Новый ПостроительОтчета;
	ПостроительОтчета.ИсточникДанных = ИсточникДанных;
	ПостроительОтчета.Выполнить();
	// Результат выгружаем в таблицу значений.
	ТабЗначений = ПостроительОтчета.Результат.Выгрузить();
	Возврат ТабЗначений
КонецФункции

Функция ОкруглитьДоМинуты(ПараметрДата,НаправлениеВверх=Истина)
	
	Секунды = Секунда(ПараметрДата);
	Если НаправлениеВверх=Истина Тогда
		ВремяОкругления = ПараметрДата-Секунды+60;
	Иначе
		ВремяОкругления = ПараметрДата-Секунды;
	КонецЕсли;
	
	Возврат ВремяОкругления;
	
КонецФункции

#КонецОбласти

#Область Агрегирования

// получить таблицу агрегации
Функция ВычислитьФункцииАгрегации(Знач МассивСоответствиеДанных, Знач Корзина, Знач list, Знач cluster) Экспорт
	
	// очистили
	МассивСтруктурАгрегацииДанных = новый Массив;	
	
	// дальше
	Для каждого стр из Корзина Цикл
		Если стр.list<>list ИЛИ  стр.cluster<>cluster Тогда
			Продолжить;
		КонецЕсли;			
		value = ПолучитьЗначениеФункцииТаблицы(МассивСоответствиеДанных,стр.name,стр.func);
		Если value=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(value)=Тип("Соответствие") Тогда
			Для каждого эл_мас из value Цикл
				стр_н = новый Структура("value,name,synonim,func,list,cluster",0,"","","","","");
				МассивСтруктурАгрегацииДанных.Добавить(стр_н);
				ЗаполнитьЗначенияСвойств(стр_н,стр);		
				стр_н.value = эл_мас.Значение;
				стр_н.name = стр_н.name+" -> "+эл_мас.Ключ;
				стр_н.synonim = ?(ЗначениеЗаполнено(стр_н.synonim),стр_н.synonim,стр_н.name)+" -> "+эл_мас.Ключ;
			КонецЦикла;
		Иначе
			стр_н = новый Структура("value,name,synonim,func,list,cluster",0,"","","","","");
			МассивСтруктурАгрегацииДанных.Добавить(стр_н);
			ЗаполнитьЗначенияСвойств(стр_н,стр);		
			стр_н.value = value;
		КонецЕсли;
		
	КонецЦикла;	
	
	Возврат МассивСтруктурАгрегацииДанных;
	
КонецФункции

// вычисляем функции агрегации
Функция ПолучитьЗначениеФункцииТаблицы(МассивСоответствиеДанных, name, func) Экспорт
	
	Значение = 0;
	Количество = МассивСоответствиеДанных.Количество();
	
	Если Количество>0 Тогда
		Если МассивСоответствиеДанных[0].Получить(name)=Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если func="count" Тогда
		Значение = Количество;
	ИначеЕсли func="count ValueIsFilled" 
	ИЛИ func="count ЗначениеЗаполнено" Тогда
		Для каждого стр из МассивСоответствиеДанных Цикл
			данные = стр.Получить(name);
			Если ЗначениеЗаполнено(данные) Тогда 
				Значение = Значение + 1;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли func="min" Тогда
		Если НЕ Количество=0 Тогда	
			Значение = МассивСоответствиеДанных[0].Получить(name);
			Если Значение=Неопределено Тогда
				Возврат Неопределено;
			КонецЕсли;			
			Для каждого стр из МассивСоответствиеДанных Цикл
				данные = стр.Получить(name);
				Если данные<Значение Тогда
					Значение = данные;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	ИначеЕсли func="max" Тогда
		Если НЕ Количество=0 Тогда	
			Значение = МассивСоответствиеДанных[0].Получить(name);
			Если Значение=Неопределено Тогда
				Возврат Неопределено;
			КонецЕсли;
			Для каждого стр из МассивСоответствиеДанных Цикл
				данные = стр.Получить(name);
				Если данные>Значение Тогда
					Значение = данные;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	ИначеЕсли func="sum" Тогда
		Для каждого стр из МассивСоответствиеДанных Цикл
			данные = стр.Получить(name);
			Значение = Значение + данные;
		КонецЦикла;
	ИначеЕсли func="avg" Тогда
		Если НЕ Количество=0 Тогда
			Для каждого стр из МассивСоответствиеДанных Цикл
				данные = стр.Получить(name);
				Значение = Значение + данные;
			КонецЦикла;
			Значение = Окр(Значение/Количество,3,РежимОкругления.Окр15как20);
		КонецЕсли;
	ИначеЕсли func="group count distinct" Тогда
		Значение = новый Соответствие;
		Для каждого стр из МассивСоответствиеДанных Цикл
			данные = стр.Получить(name);
			Количество = Значение.Получить(данные);
			Если Количество=Неопределено Тогда
				Количество = 0;
			КонецЕсли;
			Значение.Вставить(данные,Количество+1);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

#КонецОбласти