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
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.СвойстваПодписи);
	
	Если Параметры.СвойстваПодписи.ПодписьВерна Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "");
		Элементы.Инструкция.Видимость     = Ложь;
		Элементы.ОписаниеОшибки.Видимость = Ложь;
	Иначе
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ОписаниеОшибки");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЭлектроннаяПодписьКлиент.ОткрытьИнструкциюПоТипичнымПроблемамПриРаботеСПрограммами();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьВФайл(Команда)
	
	ЭлектроннаяПодписьКлиент.СохранитьПодпись(АдресПодписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	
	Если ЗначениеЗаполнено(АдресСертификата) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(АдресСертификата);
		
	ИначеЕсли ЗначениеЗаполнено(Отпечаток) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(Отпечаток);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
