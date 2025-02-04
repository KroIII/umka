﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    Если объект.Ссылка.Пустая() тогда
        объект.Старт = ТекущаяДата();
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура НазваниеПриИзменении(Элемент)
    
    Объект.Наименование = объект.Название +" "+ Объект.Контрагент + " " + объект.Периодичность
    
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
    
    Если объект.Старт > Объект.СрокОкончания и ЗначениеЗаполнено(Объект.СрокОкончания) тогда
        ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Дата окончания не может быть меньше старта",,"СрокОкончания","объект.СрокОкончания",Отказ);
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура СметаСотрудникПриИзменении(Элемент)
    
    ТС = Элементы.Смета.ТекущаяСтрока;
    СметаСотрудникПриИзмененииНаСервере(ТС);
    
КонецПроцедуры

&НаСервере
Процедура СметаСотрудникПриИзмененииНаСервере(ТС) Экспорт
    
    
    стр = объект.Смета.НайтиПоИдентификатору(ТС);
    стр.Роль = стр.сотрудник.Роль;
    
КонецПроцедуры
