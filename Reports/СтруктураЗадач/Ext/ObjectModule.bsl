﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
    
    Массив = новый Массив;                                                                                                            
    ПолучитьИерархию(
    КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(
    КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(новый ПараметрКомпоновкиДанных("мЗаявка")
    ).ИдентификаторПользовательскойНастройки).Значение,
    Массив); 
    КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Ссылки", Массив); 
    
    мин = ТекущаяДата();
    Макс = ТекущаяДата();
    
    Для Каждого стр из Массив Цикл 
        мин = мин(мин, стр.ДатаОкончания);
        Макс = Макс(Макс, стр.ДатаОкончания);
    КонецЦикла;
    КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДатаНачала", мин); 
    КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДатаОкончания", Макс); 
    
    
    
    
КонецПроцедуры


Процедура  ПолучитьИерархию(Ссылка,Массив)
    
    Запрос = новый Запрос("ВЫБРАТЬ
    | _СвязанныеЗаявки.Ссылка КАК Ссылка
    |ИЗ
    | КритерийОтбора._СвязанныеЗаявки(&сс) КАК _СвязанныеЗаявки") ;
    Запрос.УстановитьПараметр("СС",Ссылка);
    
    Для  Каждого  стр из Запрос.Выполнить().Выгрузить()Цикл 
        Если Массив.найти(стр.ссылка) = Неопределено тогда
            Массив.добавить(стр.ссылка);
            ПолучитьИерархию(стр.ссылка,Массив)
        КонецЕсли;
    КонецЦикла;
    
КонецПроцедуры