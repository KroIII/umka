﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПравилаПоУмолчанию();
	
	ТипЗначенияСвойства = Параметры.ТипЗначения;
	МассивТипов = ТипЗначенияСвойства.Типы();
	КоличествоТиповСвойства = МассивТипов.Количество();
	
	УстановитьКлючНазначенияФормы(МассивТипов);
	
	Элементы.СтраницаПравилоОбработкиСтрок.Видимость = (МассивТипов.Найти(Тип("Строка")) <> Неопределено);
	Элементы.СтраницаПравилоОбработкиЧисла.Видимость = (МассивТипов.Найти(Тип("Число")) <> Неопределено);
	Элементы.СтраницаПравилоОбработкиБулево.Видимость = (МассивТипов.Найти(Тип("Булево")) <> Неопределено);
	Элементы.СтраницаПравилоОбработкиДаты.Видимость = (МассивТипов.Найти(Тип("Дата")) <> Неопределено);
	Элементы.СтраницаПравилаОбработкиХранилищаЗначений.Видимость = (МассивТипов.Найти(Тип("ХранилищеЗначения")) <> Неопределено);
	
	Если КоличествоТиповСвойства = 1 Тогда
		Если Элементы.СтраницаПравилоОбработкиСтрок.Видимость Тогда
			Элементы.СтраницаПравилоОбработкиСтрок.ОтображатьЗаголовок = Ложь;
		ИначеЕсли Элементы.СтраницаПравилоОбработкиЧисла.Видимость Тогда
			Элементы.СтраницаПравилоОбработкиЧисла.ОтображатьЗаголовок = Ложь;
		ИначеЕсли Элементы.СтраницаПравилоОбработкиБулево.Видимость Тогда
			Элементы.СтраницаПравилоОбработкиБулево.ОтображатьЗаголовок = Ложь;
		ИначеЕсли Элементы.СтраницаПравилоОбработкиДаты.Видимость Тогда
			Элементы.СтраницаПравилоОбработкиДаты.ОтображатьЗаголовок = Ложь;
		ИначеЕсли Элементы.СтраницаПравилаОбработкиХранилищаЗначений.Видимость Тогда
			Элементы.СтраницаПравилаОбработкиХранилищаЗначений.ОтображатьЗаголовок = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПравилоЧислоПриИзменении(Элемент)
	Если ПравилоЧисло = "НеИзменять"
		Или ПравилоЧисло = "Очистить" Тогда
		Элементы.ЗначениеЧисла.Доступность = Ложь;
	Иначе
		Элементы.ЗначениеЧисла.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилоДатаПриИзменении(Элемент)
	Если ПравилоДата = "НеИзменять"
		Или ПравилоДата = "СлучайноеЗначение" Тогда
		Элементы.ЗначениеДата.Доступность = Ложь;
	Иначе
		Элементы.ЗначениеДата.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Результат = ИндивидуальныеНастройкиОбработкиСвойства();
	
	Если Результат.ПравилоОбработки.Количество() <> 0 Тогда
		Оповестить("СкрытиеПерсональныхДанных_УстановленоПравилоОбработки", Результат);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ИндивидуальныеНастройкиОбработкиСвойства()
	
	Представление = "";
	ПравилоОбработки = Новый СписокЗначений;
	
	Если Элементы.СтраницаПравилоОбработкиСтрок.Видимость Тогда
		ПравилоОбработки.Добавить("Строка", ПравилоСтрока);
		
		Если КоличествоТиповСвойства = 1 И ЗначениеЗаполнено(ПравилоСтрока) Тогда
			Представление = Элементы.ПравилоСтрока.СписокВыбора.НайтиПоЗначению(ПравилоСтрока).Представление;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.СтраницаПравилоОбработкиЧисла.Видимость Тогда
		
		Если ПравилоЧисло = "Умножить" Тогда
			ПредставлениеЧисла = НСтр("ru = 'Умножить на %1'");
			ПредставлениеЧисла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеЧисла, ЗначениеЧисла);
			
			ИтоговоеПравило = ПравилоЧисло + ";" + ЗначениеЧисла;
		ИначеЕсли ПравилоЧисло = "Разделить" Тогда
			ПредставлениеЧисла = НСтр("ru = 'Разделить на %1'");
			ПредставлениеЧисла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеЧисла, ЗначениеЧисла);
			
			ИтоговоеПравило = ПравилоЧисло + ";" + ЗначениеЧисла;
		ИначеЕсли ПравилоЧисло = "Прибавить" Тогда
			ПредставлениеЧисла = НСтр("ru = 'Прибавить %1'");
			ПредставлениеЧисла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеЧисла, ЗначениеЧисла);
			
			ИтоговоеПравило = ПравилоЧисло + ";" + ЗначениеЧисла;
		ИначеЕсли ПравилоЧисло = "Вычесть" Тогда
			ПредставлениеЧисла = НСтр("ru = 'Вычесть %1'");
			ПредставлениеЧисла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеЧисла, ЗначениеЧисла);
			
			ИтоговоеПравило = ПравилоЧисло + ";" + ЗначениеЧисла;
		ИначеЕсли ПравилоЧисло = "НеИзменять" Тогда
			ПредставлениеЧисла = НСтр("ru = 'Не изменять'");
			ИтоговоеПравило = ПравилоЧисло;
		ИначеЕсли ПравилоЧисло = "СлучайноеЗначение" Тогда
			ПредставлениеЧисла = НСтр("ru = 'Случайное значение'");
			ИтоговоеПравило = ПравилоЧисло;
		Иначе
			ПредставлениеЧисла = НСтр("ru = 'Очистить'");
			ИтоговоеПравило = ПравилоЧисло;
		КонецЕсли;
		
		ПравилоОбработки.Добавить("Число", ИтоговоеПравило);
		
		Если КоличествоТиповСвойства = 1 Тогда
			Представление = ПредставлениеЧисла;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.СтраницаПравилоОбработкиБулево.Видимость Тогда
		ПравилоОбработки.Добавить("Булево", ПравилоБулево);
		
		Если КоличествоТиповСвойства = 1 Тогда
			Представление = Элементы.ПравилоБулево.СписокВыбора.НайтиПоЗначению(ПравилоБулево).Представление;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.СтраницаПравилоОбработкиДаты.Видимость Тогда
		
		Если ПравилоДата = "Прибавить" Тогда
			ПредставлениеДаты = НСтр("ru = 'Прибавить дней: %1'");
			ПредставлениеДаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеДаты, ЗначениеДата);
			
			ИтоговоеПравило = ПравилоДата + ";" + ЗначениеДата;
		ИначеЕсли ПравилоДата = "Вычесть" Тогда
			ПредставлениеДаты = НСтр("ru = 'Вычесть дней: %1'");
			ПредставлениеДаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеДаты, ЗначениеДата);
			
			ИтоговоеПравило = ПравилоДата + ";" + ЗначениеДата;
		ИначеЕсли ПравилоДата = "СлучайноеЗначение" Тогда
			ПредставлениеДаты = НСтр("ru = 'Случайное значение'");
			ИтоговоеПравило = ПравилоДата;
		Иначе
			ПредставлениеДаты = НСтр("ru = 'Не изменять'");
			ИтоговоеПравило = ПравилоДата;
		КонецЕсли;
		
		ПравилоОбработки.Добавить("Дата", ИтоговоеПравило);
		Если КоличествоТиповСвойства = 1 Тогда
			Представление = ПредставлениеДаты;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.СтраницаПравилаОбработкиХранилищаЗначений.Видимость Тогда
		ПравилоОбработки.Добавить("ХранилищеЗначения", ПравилоХранилищеЗначений);
		
		Если КоличествоТиповСвойства = 1 Тогда
			Представление = Элементы.ПравилоХранилищеЗначений.СписокВыбора.НайтиПоЗначению(ПравилоХранилищеЗначений).Представление;
		КонецЕсли;
	КонецЕсли;
	
	Если Представление = "" Тогда
		Представление = НСтр("ru = 'Индивидуальные настройки'");
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Представление", Представление);
	Результат.Вставить("ПравилоОбработки", ПравилоОбработки);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьПравилаПоУмолчанию()
	
	ОбщиеПравилаОбработки = Параметры.ОбщиеПравилаОбработки;
	
	Если ТипЗнч(ОбщиеПравилаОбработки) = Тип("СписокЗначений") Тогда
		Для Каждого Правило Из ОбщиеПравилаОбработки Цикл
			Если Правило.Значение = "Строка" Тогда
				ПравилоСтрока = Правило.Представление;
			ИначеЕсли Правило.Значение = "Число" Тогда
				УстановитьПравилаЧиселИДат(Правило.Представление, "Число");
			ИначеЕсли Правило.Значение = "Булево" Тогда
				ПравилоБулево = Правило.Представление;
			ИначеЕсли Правило.Значение = "Дата" Тогда
				УстановитьПравилаЧиселИДат(Правило.Представление, "Дата");
			ИначеЕсли Правило.Значение = "ХранилищеЗначений" Тогда
				ПравилоХранилищеЗначений = Правило.Представление;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ПравилоБулево = ОбщиеПравилаОбработки.ПравилоБулево;
		УстановитьПравилаЧиселИДат(ОбщиеПравилаОбработки.ПравилоДата, "Дата");
		УстановитьПравилаЧиселИДат(ОбщиеПравилаОбработки.ПравилоЧисло, "Число");
		ПравилоСтрока = ОбщиеПравилаОбработки.ПравилоСтрока;
		ПравилоХранилищеЗначений = ОбщиеПравилаОбработки.ПравилоХранилищеЗначений;
	КонецЕсли;
	
	Элементы.ЗначениеДата.Доступность = Не (ПравилоДата = "НеИзменять");
	Элементы.ЗначениеЧисла.Доступность = Не ((ПравилоЧисло = "НеИзменять") Или (ПравилоЧисло = "Очистить") Или (ПравилоЧисло = "СлучайноеЗначение"));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПравилаЧиселИДат(Правило, Тип)
	
	ПравилоМассив = СтрРазделить(Правило, ";");
	Если ПравилоМассив.Количество() = 1 Тогда
		Если Тип = "Число" Тогда
			ПравилоЧисло = Правило;
		Иначе
			ПравилоДата = Правило;
		КонецЕсли;
	Иначе
		Если Тип = "Число" Тогда
			ПравилоЧисло = ПравилоМассив[0];
			ЗначениеЧисла = ПравилоМассив[1];
		Иначе
			ПравилоДата = ПравилоМассив[0];
			ЗначениеДата = ПравилоМассив[1];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКлючНазначенияФормы(МассивТипов)
	
	КлючФормы = "";
	Для Каждого Тип Из МассивТипов Цикл
		КлючФормы = КлючФормы + Строка(Тип);
	КонецЦикла;
	КлючНазначенияИспользования = КлючФормы;
	КлючСохраненияПоложенияОкна = КлючФормы;
	
КонецПроцедуры

#КонецОбласти