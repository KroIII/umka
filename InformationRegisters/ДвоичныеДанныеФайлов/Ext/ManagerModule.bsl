﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления.

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// для которых необходимо обновить записи в регистре.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииФайлов.Ссылка
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДвоичныеДанныеФайлов КАК ДвоичныеДанныеФайлов
		|		ПО ВерсииФайлов.Ссылка = ДвоичныеДанныеФайлов.Файл
		|ГДЕ
		|	ДвоичныеДанныеФайлов.Файл ЕСТЬ NULL 
		|	И ВерсииФайлов.ТипХраненияФайла = ЗНАЧЕНИЕ(Перечисление.ТипыХраненияФайлов.ВИнформационнойБазе)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВерсииФайлов.ДатаМодификацииУниверсальная УБЫВ";
	
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"); 
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// Обновить записи регистра.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ВерсииФайлов");
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			БлокировкаДанных = Новый БлокировкаДанных;
			ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.УдалитьХранимыеФайлыВерсий");
			ЭлементБлокировкиДанных.УстановитьЗначение("ВерсияФайла", Выборка.Ссылка);
			ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Разделяемый;
			БлокировкаДанных.Заблокировать();
			
			МенеджерЗаписиВерсииФайла = РегистрыСведений.УдалитьХранимыеФайлыВерсий.СоздатьМенеджерЗаписи();
			МенеджерЗаписиВерсииФайла.ВерсияФайла = Выборка.Ссылка;
			МенеджерЗаписиВерсииФайла.Прочитать();
			
			ДвоичныеДанные = МенеджерЗаписиВерсииФайла.ХранимыйФайл.Получить();
			
			МенеджерЗаписи = СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Файл = Выборка.Ссылка;
			МенеджерЗаписи.ДвоичныеДанныеФайла = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
			МенеджерЗаписи.Записать(Истина);
			
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			// Если не удалось обработать какой-либо документ, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать версию файла: %1 по причине:
			|%2'"), 
			Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
			Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ВерсииФайлов") Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Процедуре ПеренестиДвоичныеДанныеФайловВРегистрСведенийДвоичныеДанныеФайлов не удалось обработать некоторые версии файлов (пропущены): %1'"), 
		ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
		Метаданные.НайтиПоПолномуИмени("Справочник.ВерсииФайлов"),,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Процедура ПеренестиДвоичныеДанныеФайловВРегистрСведенийДвоичныеДанныеФайлов обработала очередную порцию версий: %1'"),
		ОбъектовОбработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
