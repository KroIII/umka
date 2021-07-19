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
	
	Если Параметры.Отбор.Свойство("Программа") 
	   И ЗначениеЗаполнено(Параметры.Отбор.Программа) Тогда
		
		Программа = Параметры.Отбор.Программа;
		
		АвтоЗаголовок = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Пути к программе %1 на серверах Linux'"), Программа);
		
		Элементы.СписокПрограмма.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если Не ЗначениеЗаполнено(Программа) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элементы.Список.ТекущаяСтрока);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Программа", Программа));
	
	ОткрытьФорму("РегистрСведений.ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux.ФормаЗаписи",
		ПараметрыФормы, Элементы.Список, ,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	УдаляемаяСтрока          = Элементы.Список.ТекущаяСтрока;
	УдаляемаяСтрокаПрограмма = Элементы.Список.ТекущиеДанные.Программа;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	Оповестить("Запись_ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux",
		Новый Структура("Программа", УдаляемаяСтрокаПрограмма), УдаляемаяСтрока);
	
КонецПроцедуры

#КонецОбласти
