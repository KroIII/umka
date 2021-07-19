﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСсылку(Наименование, СобиратьСтатистикуКонфигурации = Ложь) Экспорт
	ХешНаименования = ХешНаименования(Наименование);
	
	Ссылка = НайтиПоХешу(ХешНаименования);
	Если Ссылка = Неопределено Тогда
		Ссылка = СоздатьНовый(Наименование, ХешНаименования, СобиратьСтатистикуКонфигурации);
	КонецЕсли;
		
	Возврат Ссылка;
КонецФункции

Функция СобиратьСтатистикуКонфигурации(Наименование) Экспорт
	ХешНаименования = ХешНаименования(Наименование);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ОбластиСтатистики.СобиратьСтатистикуКонфигурации
	|ИЗ
	|	РегистрСведений.ОбластиСтатистики КАК ОбластиСтатистики
	|ГДЕ
	|	ОбластиСтатистики.ХешНаименования = &ХешНаименования
	|";
	Запрос.УстановитьПараметр("ХешНаименования", ХешНаименования);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		СобиратьСтатистикуКонфигурации = Ложь;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		СобиратьСтатистикуКонфигурации = Выборка.СобиратьСтатистикуКонфигурации;
	КонецЕсли;
	
	Возврат СобиратьСтатистикуКонфигурации
КонецФункции

Функция ХешНаименования(Наименование)
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA1);
	ХешированиеДанных.Добавить(Наименование);
	ХешНаименования = СтрЗаменить(Строка(ХешированиеДанных.ХешСумма), " ", "");
	
	Возврат ХешНаименования;
КонецФункции

Функция НайтиПоХешу(Хеш)
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ОбластиСтатистики.ИдентификаторОбласти
	|ИЗ
	|	РегистрСведений.ОбластиСтатистики КАК ОбластиСтатистики
	|ГДЕ
	|	ОбластиСтатистики.ХешНаименования = &ХешНаименования
	|";
	Запрос.УстановитьПараметр("ХешНаименования", Хеш);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Ссылка = Неопределено;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Ссылка = Выборка.ИдентификаторОбласти;
	КонецЕсли;
	
	Возврат Ссылка;
КонецФункции

Функция СоздатьНовый(Наименование, ХешНаименования, СобиратьСтатистикуКонфигурации)
	НачатьТранзакцию();
	
	Попытка
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОбластиСтатистики");
		ЭлементБлокировки.УстановитьЗначение("ХешНаименования", ХешНаименования);
				
		Блокировка.Заблокировать();
		
		Ссылка = НайтиПоХешу(ХешНаименования);
		
		Если Ссылка = Неопределено Тогда
			Ссылка = Новый УникальныйИдентификатор();
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			НовЗапись = НаборЗаписей.Добавить();
			НовЗапись.ХешНаименования = ХешНаименования;
			НовЗапись.ИдентификаторОбласти = Ссылка;
			НовЗапись.Наименование = Наименование;
			НовЗапись.СобиратьСтатистикуКонфигурации = СобиратьСтатистикуКонфигурации;
			НаборЗаписей.Записать(Ложь);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Ссылка;
КонецФункции

#КонецОбласти

#КонецЕсли
