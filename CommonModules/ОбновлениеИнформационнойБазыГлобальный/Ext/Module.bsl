﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Проверяет статус отложенного обновления. Если обновление завершилось
// с ошибками - информирует об этом пользователя и администратора.
//
Процедура ПроверитьСтатусОтложенногоОбновления() Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ПоказатьСообщениеОбОшибочныхОбработчиках") Тогда
		ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ИндикацияХодаОтложенногоОбновленияИБ");
	Иначе
		ОбновлениеИнформационнойБазыКлиент.ОповеститьОтложенныеОбработчикиНеВыполнены();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
