﻿
Процедура ПередЗаписью(Отказ, Замещение)
    
    Если ОбменДанными.Загрузка тогда
        Возврат
    КонецЕсли; 
    
    Для Каждого стр из ЭтотОбъект Цикл 
        Если  стр.Заявка.Проверена  
            и не РольДоступна("_ИзменениеВыполненныхПроверенныхЗаявок") 
            и не РольДоступна("ПолныеПрава") 
            и не ДополнительныеСвойства.Свойство("ПропускатьПроверкуЗакрытойЗаявки") тогда
            ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Заявка %1 закрыта!!!",стр.Заявка),стр.Заявка,,,Отказ);
        КонецЕсли;
        стр.КодСтроки = ?( стр.КодСтроки = "",новый УникальныйИдентификатор, стр.КодСтроки);
        стр.ЧасыКлиенту  = ?(стр.ЧасыКлиенту = 0 ,?(стр.Задача.БизнесПроцесс.НеВыставлятьКонтрагенту,0,стр.ЧасыКлиенту),стр.ЧасыКлиенту);
        стр.ВидОбращения = ?(стр.ВидОбращения.Пустая(), стр.Задача.БизнесПроцесс.ВидОбращения, стр.ВидОбращения );
        стр.НомерСервисДеск = ?(стр.НомерСервисДеск = "", стр.Задача.БизнесПроцесс.НомерСервисДеск, стр.НомерСервисДеск );
        стр.Задание = ?(стр.Задание = "", стр.Задача.БизнесПроцесс.Наименование, стр.Задание );
    КонецЦикла;
    
    
    Если не Отказ  и не ДополнительныеСвойства.Свойство("НеЗаписыватьОписание") тогда
        мзадачи = ЭтотОбъект.Выгрузить(,"Задача");
        мзадачи.Свернуть("Задача");
        мас = Новый  Массив;
        мас.Добавить(мзадачи.ВыгрузитьКолонку("Задача"));
        ФоновыеЗадания.Выполнить("_ОбщийМодульСервер.ОбновитьОписанияЗадач", мас, новый УникальныйИдентификатор);
    КонецЕсли;
    //Если  не ДополнительныеСвойства.Свойство("ВнесениеЧлИзЗаявки") тогда
    //    
    //    Для Каждого стр из ЭтотОбъект Цикл 
    //    КонецЦикла;
    //    Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ДокументСтарый" ) тогда
    //        мас.Добавить(ЭтотОбъект.ДополнительныеСвойства.ДокументСтарый)
    //    КонецЕсли;
    //    мас.Добавить(ЭтотОбъект.Отбор.Заявка.Значение);
    //    
    //    ФоновыеЗадания.Выполнить("_ОбщийМодульСервер.ПеренестиЧлВЗаявку", мас, новый УникальныйИдентификатор);
    //КонецЕсли;
КонецПроцедуры

 
