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
	
	Если Не Параметры.ПрограммноеОткрытие Тогда
		ВызватьИсключение
			НСтр("ru = 'Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
	ПропуститьПерезапуск = Параметры.ПропуститьПерезапуск;
	
	МакетДокумента = Обработки.ЛегальностьПолученияОбновлений.ПолучитьМакет(
		"УсловияРаспространенияОбновлений");
	
	ТекстПредупреждения = МакетДокумента.ПолучитьТекст();
	ИнформационнаяБазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	// СтандартныеПодсистемы.ЦентрМониторинга
	ЦентрМониторингаСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга");
	Если ЦентрМониторингаСуществует Тогда
		МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
		ПараметрыЦентраМониторинга = МодульЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторингаВнешнийВызов();
				
		Если (НЕ ПараметрыЦентраМониторинга.ВключитьЦентрМониторинга И  НЕ ПараметрыЦентраМониторинга.ЦентрОбработкиИнформацииОПрограмме) Тогда
			РазрешитьОтправкуСтатистики = Истина;
			Элементы.ГруппаОтправкаСтатистики.Видимость = Истина;
		Иначе
			РазрешитьОтправкуСтатистики = Истина;
			Элементы.ГруппаОтправкаСтатистики.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ГруппаОтправкаСтатистики.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ЦентрМониторинга
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
		Элементы.ФормаПродолжить.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
	
	ТекущийЭлемент = Элементы.ПодтверждениеБулево;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ИнформационнаяБазаФайловая
	   И СтрНайти(ПараметрЗапуска, "ВыполнитьОбновлениеИЗавершитьРаботу") > 0 Тогда
		
		ЗаписатьПодтверждениеЛегальностиПолученияОбновлений();
		Отказ = Истина;
		СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Истина);
		ПодключитьОбработчикОжидания("ПодтвердитьЛегальностьПолученияОбновления", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОсновныеДействияФормыПродолжить(Команда)
	
	Результат = ПодтверждениеБулево;
	
	Если Результат <> Истина Тогда
		Если Параметры.ПоказыватьПредупреждениеОПерезапуске И НЕ ПропуститьПерезапуск Тогда
			ПрекратитьРаботуСистемы();
		КонецЕсли;
	Иначе
		ЗаписатьПодтверждениеЛегальностиИОтправкиСтатистики(РазрешитьОтправкуСтатистики);
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	ИначеЕсли Результат <> Истина Тогда
		Если Параметры.ПоказыватьПредупреждениеОПерезапуске И НЕ ПропуститьПерезапуск Тогда
			ПрекратитьРаботуСистемы();
		КонецЕсли;
	Иначе
		ЗаписатьПодтверждениеЛегальностиИОтправкиСтатистики(РазрешитьОтправкуСтатистики);
	КонецЕсли;
	
	Оповестить("ЛегальностьПолученияОбновлений", Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодтвердитьЛегальностьПолученияОбновления()
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Ложь);
	
	ВыполнитьОбработкуОповещения(ЭтотОбъект.ОписаниеОповещенияОЗакрытии, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьПодтверждениеЛегальностиИОтправкиСтатистики(РазрешитьОтправкуСтатистики)
	
	ЗаписатьПодтверждениеЛегальностиПолученияОбновлений();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЦентрМониторингаСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга");
	Если ЦентрМониторингаСуществует Тогда
		МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
		
		ПараметрыОтправкиСтатистики = Новый Структура("ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме", Неопределено, Неопределено);
		ПараметрыОтправкиСтатистики = МодульЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторингаВнешнийВызов(ПараметрыОтправкиСтатистики);
		
		Если (НЕ ПараметрыОтправкиСтатистики.ВключитьЦентрМониторинга И ПараметрыОтправкиСтатистики.ЦентрОбработкиИнформацииОПрограмме) Тогда
			// Настроена отправка статистики стороннему разработчику
			// настройки не меняем.
			//
		Иначе
			Если РазрешитьОтправкуСтатистики Тогда
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ВключитьЦентрМониторинга", РазрешитьОтправкуСтатистики);
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ЦентрОбработкиИнформацииОПрограмме", Ложь);
				РегЗадание = МодульЦентрМониторингаСлужебный.ПолучитьРегламентноеЗаданиеВнешнийВызов("СборИОтправкаСтатистики", Истина);
				МодульЦентрМониторингаСлужебный.УстановитьРасписаниеПоУмолчаниюВнешнийВызов(РегЗадание);
			Иначе
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ВключитьЦентрМониторинга", РазрешитьОтправкуСтатистики);
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ЦентрОбработкиИнформацииОПрограмме", Ложь);
				МодульЦентрМониторингаСлужебный.УдалитьРегламентноеЗаданиеВнешнийВызов("СборИОтправкаСтатистики");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьПодтверждениеЛегальностиПолученияОбновлений()
	УстановитьПривилегированныйРежим(Истина);
	ОбновлениеИнформационнойБазыСлужебный.ЗаписатьПодтверждениеЛегальностиПолученияОбновлений();
КонецПроцедуры

#КонецОбласти