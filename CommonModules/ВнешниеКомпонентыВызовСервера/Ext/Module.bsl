﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Информация о внешней компоненте по идентификатору и версии.
//
// Параметры:
//  Идентификатор - Строка - идентификатор объекта внешней компоненты.
//  Версия - Строка - (необязательный) версия компоненты. 
//
// Возвращаемое значение:
//  Структура - информация о компоненте
//      * Существует - Булево - признак отсутствия компоненты.
//      * ДоступноРедактирование - Булево - признак того, что компоненту может изменить администратор области.
//      * ОписаниеОшибки - Строка - краткое описание ошибки.
//      * Идентификатор - Строка - идентификатор объекта внешней компоненты.
//      * Версия - Строка - версия компоненты.
//      * Наименование - Строка - наименование и краткая информация о компоненте.
//
// Пример:
//
//  Результат = ВнешниеКомпонентыВызовСервера.ИнформацияОКомпоненте("InputDevice", "8.1.7.10");
//
//  Если Результат.Существует Тогда
//      Идентификатор = Результат.Идентификатор;
//      Версия        = Результат.Версия;
//      Наименование  = Результат.Наименование;
//  Иначе
//      ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ОписаниеОшибки);
//  КонецЕсли;
//
Функция ИнформацияОКомпоненте(Идентификатор, Версия = Неопределено) Экспорт
	
	Результат = РезультатИнформацияОКомпоненте();
	Результат.Идентификатор = Идентификатор;
	
	Информация = ВнешниеКомпонентыСлужебный.ИнформацияОСохраненнойКомпоненте(Идентификатор, Версия);
	
	Если Информация.Состояние = "НеНайдена" Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Внешняя компонента не найдена'");
		Возврат Результат;
	КонецЕсли;
	
	Если Информация.Состояние = "ОтключенаАдминистратором" Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Внешняя компонента отключена'");
		Возврат Результат;
	КонецЕсли;
	
	Результат.Существует = Истина;
	Результат.ДоступноРедактирование = Истина;
	
	Если Информация.Состояние = "НайденаВОбщемХранилище" Тогда
		Результат.ДоступноРедактирование = Ложь;
	КонецЕсли;
	
	Результат.Версия = Информация.Реквизиты.Версия;
	Результат.Наименование = Информация.Реквизиты.Наименование;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РезультатИнформацияОКомпоненте()
	
	Результат = Новый Структура;
	Результат.Вставить("Существует", Ложь);
	Результат.Вставить("ДоступноРедактирование", Ложь);
	Результат.Вставить("Идентификатор", "");
	Результат.Вставить("Версия", "");
	Результат.Вставить("Наименование", "");
	Результат.Вставить("ОписаниеОшибки", "");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти