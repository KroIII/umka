﻿

#Область НачальноеЗаполнениеДанных

&НаСервере
Процедура ЗаполнитьФорму(Отказ, СтандартнаяОбработка,ПараметрыФормы)
    
    Заявка = ПараметрыФормы.ссылка;
    НомерСтроки = ПараметрыФормы.НомерСтроки;
    ТолькоЧасы = ПараметрыФормы.ТолькоЧасы;
    
    Если НомерСтроки <> 0 тогда
        
        стр = заявка.ЧекЛисты[НомерСтроки-1];
        ЗаполнитьЗначенияСвойств(ЭтаФорма,стр);
        
        Выполнено = стр.часы <> 0; 
        
        //внесение часов по заданию
        //задание копируется новой строкой
        Если ТолькоЧасы тогда
            НомерСтроки = 0;
        КонецЕсли;
        
        //если вдруг у задания нет ИД - надо присвоить
        Если ИДЗадания = "" тогда
            ИДЗадания = новый УникальныйИдентификатор();
            Элементы.ОповещениеОЗаписи.Видимость = Истина;
        КонецЕсли;
        
        //заполнение вложений
        Влож = стр.Вложения.Получить();
        Если ТипЗнч(Влож) = Тип("Массив") тогда
            для Каждого Вл из  Влож цикл
                Если Вл.ПолучитьОбъект() <> Неопределено тогда
                    Вложения.Добавить(Вл);
                КонецЕсли;
            КонецЦикла;
        КонецЕсли;
        
    иначе
        
        Если Заявка.Контрагент.Блокировка и не РольДоступна("ПолныеПрава") тогда
            ОбщегоНазначения.СообщитьПользователю("У контрагента стоит блокировка. Нельзя создавать задания по данному контрагенту!",заявка.Контрагент,,, Отказ);
        КонецЕсли;
        ИДЗадания = новый УникальныйИдентификатор();
        Ответственный = ПараметрыСеанса.ТекущийПользователь;
        ДатаПланОтветственный = ТекущаяДата();
        
    КонецЕсли;
    ЗаполнитьСотрудников();
    Оформление();
    
КонецПроцедуры

#КонецОбласти

#Область Сохранение

&НаКлиенте
Процедура Записать(Команда)
    
    Если ЧасыПлановые > 8 тогда 
        сообщ = новый СообщениеПользователю;
        сообщ.ПутьКДанным = "ЧасыПлановые";
        сообщ.Текст = "Плановые часы не могут быть более 8 часов - создайте подчиненную заявку или измените количество часов";
        сообщ.Сообщить();
        Элементы.СоздатьЗаявкуНаОсновании.Видимость = НомерСтроки = 0;
        возврат 
    КонецЕсли;
    
    Если СокрЛП(Задание ) = "" тогда 
        сообщ = новый СообщениеПользователю;
        сообщ.ПутьКДанным = "Задание";
        сообщ.Текст = "заполните поле Задание";
        сообщ.Сообщить();
        возврат 
    КонецЕсли;
    
    Если СокрЛП(Заявка ) = "" тогда 
        сообщ = новый СообщениеПользователю;
        сообщ.ПутьКДанным = "Заявка";
        сообщ.Текст = "заполните поле";
        сообщ.Сообщить();
        возврат 
    КонецЕсли;
    
    Если ДатаПланОтветственный = дата(1,1,1) тогда 
        сообщ = новый СообщениеПользователю;
        сообщ.ПутьКДанным = "ДатаПланОтветственный";
        сообщ.Текст = "заполните поле Дата";
        сообщ.Сообщить();
        возврат 
    КонецЕсли;
    
    Если СокрЛП(Сотрудник ) = "" тогда 
        сообщ = новый СообщениеПользователю;
        сообщ.ПутьКДанным = "Сотрудник";
        сообщ.Текст = "заполните поле Сотрудник";
        сообщ.Сообщить();
        возврат 
    КонецЕсли;
    Если Выполнено и часы = 0 тогда 
        сообщ = новый СообщениеПользователю;
        сообщ.ПутьКДанным = "часы";
        сообщ.Текст = "заполните поле Часы";
        сообщ.Сообщить();
        возврат 
    КонецЕсли;
    
    Если ДатаЗапрета <> Дата(1,1,1) и Дата <> Дата(1,1,1) и Дата <= ДатаЗапрета тогда 
        сообщ = новый СообщениеПользователю;
        сообщ.ПутьКДанным = "ДатаВыполненияРабот";
        сообщ.Текст = "Дата попадает под действие даты запрета - " + Формат(ДатаЗапрета,"ДФ=dd.MM.yy");
        сообщ.Сообщить();
        возврат 
    КонецЕсли;
    
    Если ДатаЗапрета <> Дата(1,1,1) и ДатаПланОтветственный <> Дата(1,1,1) и ДатаПланОтветственный <= ДатаЗапрета и 
        //внесение новой
        (НомерСтроки = 0 и не ТолькоЧасы) тогда 
        сообщ = новый СообщениеПользователю;
        сообщ.ПутьКДанным = "ДатаПланОтветственный";
        сообщ.Текст = "Дата плановая попадает под действие даты запрета - " + Формат(ДатаЗапрета,"ДФ=dd.MM.yy");
        сообщ.Сообщить();
        возврат 
    КонецЕсли;
    
    ЗаписатьНаСервере();
    ОповеститьОВыборе("Записано");
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере(Отмена = Ложь)
    
    мСотрудник = новый Массив;
    
    Док = Заявка.ПолучитьОбъект();
    Если НомерСтроки = 0 тогда
        стр = Док.ЧекЛисты.Добавить();                                                    
    иначе
        стр = Док.ЧекЛисты[НомерСтроки-1];
    КонецЕсли;
    
    
    #Область ОтправкаИзмененийВТелегу
    Если Отмена тогда
        
        Текст = "*" + ПараметрыСеанса.ТекущийПользователь + " Отменил задание*" + 
        Символы.ПС + "*Заявка:* `" + Формат(Число(Заявка.Номер), "ЧДЦ=0; ЧГ=0") + "`"+
        Символы.ПС + "*Контр-т:* `" + Заявка.Контрагент + "`"+
        Символы.ПС + "*Отв-ый:* `" + Ответственный + "`"+ 
        Символы.ПС + "*Сотрудник:* `" + Сотрудник + "`"+ 
        Символы.ПС + "*На дату:* `" + формат(ДатаПланОтветственный, "ДФ=dd.MM.yy") + "`"+ 
        Символы.ПС + "*Задание:* `" + Заявка + "`"; 
        
        мСотрудник.Добавить( Ответственный);
        мСотрудник.Добавить( Сотрудник);
        
        мПараметры = Новый Массив;
        мПараметры.Добавить(мСотрудник);
        мПараметры.Добавить(Текст);
        мПараметры.Добавить(ПараметрыСеанса.ТекущийПользователь);
        мПараметры.Добавить(Заявка);
        
        ФоновыеЗадания.Выполнить("КП_ОбщийМодуль.Рассылка", 
        мПараметры, Новый УникальныйИдентификатор,"Рассылка в телеграмм"); 
        
    ИначеЕсли НомерСтроки = 0 и не ТолькоЧасы тогда
        
        Текст = "*Новое задание*" + 
        Символы.ПС + ?(Важная, "ВАЖНАЯ ","") + "*Заявка:* `" + Формат(Число(заявка.Номер), "ЧДЦ = 0; ЧГ = 0") + "`" + 
        Символы.ПС + "*Контр-т:* `" + заявка.Контрагент + "`" + 
        Символы.ПС + "*Отв-ый:* `" + Ответственный + "`" + 
        Символы.ПС + "*На дату:* `" + формат(ДатаПланОтветственный,"ДФ = dd.MM.yy") + "`" + 
        Символы.ПС + "*Задание:* `" + Задание + "`"; 
        
        мСотрудник.Добавить( Сотрудник);
        мПараметры = Новый Массив;
        мПараметры.Добавить(мСотрудник);
        мПараметры.Добавить(Текст);
        мПараметры.Добавить(ПараметрыСеанса.ТекущийПользователь);
        мПараметры.Добавить(Заявка);
        
        ФоновыеЗадания.Выполнить("КП_ОбщийМодуль.Рассылка", 
        мПараметры, Новый УникальныйИдентификатор,"Рассылка в телеграмм"); 
        
    ИначеЕсли стр.часы = 0 и Выполнено и не ЗначениеЗаполнено(стр.дата) и не ТолькоЧасы тогда
        
        Текст = "*Выполнено задание*" + 
        Символы.ПС + "*Заявка:* `" + Формат(Число(заявка.Номер), "ЧДЦ = 0; ЧГ = 0") + "`" + 
        Символы.ПС + "*Контр-т:* `" + заявка.Контрагент + "`" + 
        Символы.ПС + "*Исполнитель:* `" + Сотрудник + "`" + 
        Символы.ПС + "*Важная:* `" + Формат(Важная,"БЛ = Нет; БИ = Да") + "`" + 
        Символы.ПС + "*Задание:* `" + Задание + "`" + 
        Символы.ПС + "*Описание:* `" + Описание + "`"; 
        
        мСотрудник.Добавить( Ответственный);
        мПараметры = Новый Массив;
        мПараметры.Добавить(мСотрудник);
        мПараметры.Добавить(Текст);
        мПараметры.Добавить(ПараметрыСеанса.ТекущийПользователь);
        мПараметры.Добавить(Заявка);
        
        ФоновыеЗадания.Выполнить("КП_ОбщийМодуль.Рассылка", 
        мПараметры, Новый УникальныйИдентификатор,"Рассылка в телеграмм"); 
        
    ИначеЕсли не ТолькоЧасы тогда
        Если стр.Важная <> Важная или стр.ДатаПланОтветственный <> ДатаПланОтветственный или стр.Сотрудник <> Сотрудник или СокрЛП(ВРег(Задание)) <> СокрЛП(ВРег(стр.Задание)) тогда
            
            Текст = "*Изменения в задании*" + 
            Символы.ПС + "*Заявка:* `" + Формат(Число(заявка.Номер), "ЧДЦ = 0; ЧГ = 0") + "`" + 
            Символы.ПС + "*Контр-т:* `" + заявка.Контрагент + "`" + 
            Символы.ПС + "*Отв-ый:* `" + Ответственный + "`" + 
            
            //изменен сотрудник 
            ?( стр.Сотрудник <> Сотрудник ,
            Символы.ПС + "*Сотрудник:* `" + стр.Сотрудник + "` → `" + Сотрудник + "`",
            "") + 
            
            //изменена важность задания 
            ?(стр.Важная <> Важная ,
            Символы.ПС + "*Изменена важность задания:* `" + стр.Важная + "` → `" + Важная + "`",
            "") + 
            
            //изменена дата
            ?( стр.ДатаПланОтветственный <> ДатаПланОтветственный ,
            Символы.ПС + "*На дату:* `" + формат(стр.ДатаПланОтветственный,"ДФ = dd.MM.yy") + "` → `" + формат(ДатаПланОтветственный,"ДФ = dd.MM.yy") + "`" , 
            Символы.ПС + "*На дату:* `" + формат(ДатаПланОтветственный,"ДФ = dd.MM.yy") + "`") + 
            
            //изменено задание
            ?( СокрЛП(ВРег(Задание)) <> СокрЛП(ВРег(стр.Задание)), 
            Символы.ПС + "*Задание:* `" + """" + стр.Задание + """` → `""" + задание + """`", 
            Символы.ПС + "*Задание:* `" + Задание + "`"); 
            
            Если не стр.Сотрудник = Сотрудник тогда
                мСотрудник.Добавить(стр.Сотрудник);
            КонецЕсли;
            
            мСотрудник.Добавить(Сотрудник);
            
            мПараметры = Новый Массив;
            мПараметры.Добавить(мСотрудник);
            мПараметры.Добавить(Текст);
            мПараметры.Добавить(ПараметрыСеанса.ТекущийПользователь);
            мПараметры.Добавить(Заявка);
            
            ФоновыеЗадания.Выполнить("КП_ОбщийМодуль.Рассылка", 
            мПараметры, Новый УникальныйИдентификатор,"Рассылка в телеграмм");
        КонецЕсли;
    КонецЕсли;
    
    
    #КонецОбласти
    
    Если Отмена тогда
        
        стр.Статус =  Перечисления.СтатусыЧЛ.Отменено;
        
    иначе
        
        стр.ИДЗадания = ИДЗадания;
        стр.ДатаПланОтветственный = ДатаПланОтветственный;
        стр.Дата = Дата;
        стр.ДатаПланСотрудник = ДатаПланСотрудник;
        стр.Задание = Задание;
        стр.Описание = Описание;
        стр.Сотрудник = Сотрудник;
        стр.ЭтоЗадание = не ТолькоЧасы;
        стр.Важная = Важная;
        стр.Вложения = новый ХранилищеЗначения(Вложения.ВыгрузитьЗначения());
        Если стр.часы = 0 и Выполнено и не ЗначениеЗаполнено(стр.дата) тогда
            стр.дата = ТекущаяДата();
        КонецЕсли;
        стр.Часы = Часы;
        стр.ЧасыПлановые = ЧасыПлановые;
        стр.Ответственный = Ответственный;
        стр.ЧасыКлиенту = Часы;
        стр.Статус = ?(Выполнено, Перечисления.СтатусыЧЛ.Выполнено, стр.Статус);
        Если стр.Часы <> 0 и стр.Сотрудник = стр.Ответственный тогда
            стр.Просмотрено = Истина;
        КонецЕсли;
    КонецЕсли;
    Док.Записать();
    
    МНомерСтроки = НомерСтроки; 
    НомерСтроки = стр.НомерСтроки;
    ЗаполнитьСотрудников();
    Оформление();
    Модифицированность = Ложь;
    
    
    МНомерСтроки = НомерСтроки; 
    
КонецПроцедуры


#КонецОбласти

#Область Оформление
&НаСервере
Процедура ОформлениеЗадания()
    
    Элементы.Задание.Заголовок = "Задание ("+ СтрДлина(Задание) +"/1000 симв.)";

КонецПроцедуры    

&НаСервере
Процедура Оформление()
    
    ОформлениеЗадания();
    Элементы.Статус.Видимость = Статус = Перечисления.СтатусыЧЛ.Отменено;
    Элементы.Заявка.ТолькоПросмотр = НомерСтроки <> 0;
    Элементы.ФормаОтменить.Видимость = НомерСтроки <> 0 и не Выполнено;
    Элементы.Выполнено.Видимость = не ТолькоЧасы;
    Элементы.ДатаВыполненияРабот.Видимость = не Часы = 0;
    Элементы.ГруппаВыполнено.Видимость = (НомерСтроки <> 0 или ТолькоЧасы) или Сотрудник = ПараметрыСеанса.ТекущийПользователь;
    Элементы.ЗаявкаПроверена.Видимость  = Заявка.Проверена;
        
    Если не   Элементы.ГруппаВыполнено.Видимость тогда
        Если Выполнено или Часы <> 0  Тогда
            Выполнено = Ложь;
            Часы = 0 ;
            Дата = Неопределено;
        КонецЕсли;
    КонецЕсли;
    
    Элементы.Описание.Видимость = (НомерСтроки <> 0 или ТолькоЧасы) или Сотрудник = ПараметрыСеанса.ТекущийПользователь;
    
    Если ТолькоЧасы тогда
        Элементы.Переместить(Элементы.ГруппаШапка,Элементы.ГруппаСкрытая);
        Элементы.Переместить(Элементы.ГруппаДатаПланОтветственный,Элементы.ГруппаСкрытая);
        Элементы.Переместить(Элементы.ГруппаВложения,Элементы.ГруппаСкрытая);
        ЭтаФорма.Высота = 27;
        ЭтаФорма.Ширина = 50;
    иначе
        ЭтаФорма.Высота = 35;
        ЭтаФорма.Ширина = 100; 
    КонецЕсли;
    
    СписокСерыхСтатусов = новый СписокЗначений;
    СписокСерыхСтатусов.Добавить(Перечисления.СтатусыЗаявки.Отменен);
    СписокСерыхСтатусов.Добавить(Перечисления.СтатусыЗаявки.НаУточнении);
    СписокСерыхСтатусов.Добавить(Перечисления.СтатусыЗаявки.ПереданоВТестирование);
    СписокСерыхСтатусов.Добавить(Перечисления.СтатусыЗаявки.Выполнена);
    Если СписокСерыхСтатусов.НайтиПоЗначению(Заявка.Статус) <> Неопределено 
        или Статус = Перечисления.СтатусыЧЛ.Отменено тогда
        Элементы.ГруппаФормы.ЦветФона = WebЦвета.Серебряный;
    иначе
        Элементы.ГруппаФормы.ЦветФона = ?(Важная, новый Цвет(233, 242, 255), новый Цвет);
    КонецЕсли;

    
    //ничего не скрываем для полных прав
    //и все доступно
    Если РольДоступна("ПолныеПрава") тогда 
        Возврат;
    КонецЕсли;
    
    
    ИзменениеОтветственногоВЗадачах = РольДоступна("ИзменениеОтветственногоВЗадачах");
    
    Элементы.Ответственный.ТолькоПросмотр   = не ИзменениеОтветственногоВЗадачах; 
    Элементы.Сотрудник.ТолькоПросмотр       = не (Ответственный = ПараметрыСеанса.ТекущийПользователь или ИзменениеОтветственногоВЗадачах);
    Элементы.Задание.ТолькоПросмотр         = Ответственный <> ПараметрыСеанса.ТекущийПользователь и не ИзменениеОтветственногоВЗадачах;
    Элементы.Описание.ТолькоПросмотр        = Сотрудник <> ПараметрыСеанса.ТекущийПользователь ;
    Элементы.ГруппаВыполнено.ТолькоПросмотр = Сотрудник <> ПараметрыСеанса.ТекущийПользователь;
    
   Если СписокСерыхСтатусов.НайтиПоЗначению(Заявка.Статус) <> Неопределено или Статус = Перечисления.СтатусыЧЛ.Отменено тогда
        ЭтаФорма.ТолькоПросмотр             = Истина;
    КонецЕсли;
    
    Если Заявка.Проверена тогда
        ЭтаФорма.ТолькоПросмотр             = Истина;
    КонецЕсли;
    //доступно только когда новая строка, при том это не ввод часов, или постановщик текущий пользователь 
    Элементы.ГруппаЗадание.ТолькоПросмотр   = не( НомерСтроки = 0 и не ТолькоЧасы или Ответственный = ПараметрыСеанса.ТекущийПользователь);
    Элементы.ГруппаШапка.ТолькоПросмотр     = не( НомерСтроки = 0 и не ТолькоЧасы или Ответственный = ПараметрыСеанса.ТекущийПользователь);;
    Элементы.Важная.ТолькоПросмотр          = не( НомерСтроки = 0 и не ТолькоЧасы или Ответственный = ПараметрыСеанса.ТекущийПользователь);;
    
    
    
    
    
КонецПроцедуры

#КонецОбласти

#Область РаботаСВложениями

&НаКлиенте
Процедура РаботаСВложениями(Отказ, Действие)
    
    Отказ = Истина;
    
    Если Действие = "Добавление" тогда 
        
        РаботаСФайламиКлиент.ДобавитьФайлы(Заявка, УникальныйИдентификатор,,,новый ОписаниеОповещения("ВыборФайлаЗавершение",ЭтаФорма));
        
    Иначе 
        
        ПоказатьВопрос(новый ОписаниеОповещения("УдалениеФайлаЗавершение",ЭтаФорма), "Удалить файл?", РежимДиалогаВопрос.ДаНет);
        
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаЗавершение(массивФайлов, ДП) Экспорт 
    
    для Каждого стр из массивФайлов цикл
        
        Вложения.Добавить(стр,,Истина);
        
    КонецЦикла;
    
    Модифицированность = Истина;
    
КонецПроцедуры

&НаКлиенте
Процедура УдалениеФайлаЗавершение(ответ, ДП) Экспорт 
    
    Если ответ = КодВозвратаДиалога.Да тогда
        УдалитьФайл(Элементы.Вложения.ТекущиеДанные.Значение);
        Вложения.Удалить(Вложения.НайтиПоЗначению(Элементы.Вложения.ТекущиеДанные.Значение));
    КонецЕсли;
    
КонецПроцедуры

&НаСервере
Процедура УдалитьФайл(Файл) Экспорт 
    
    ФайлОбъект = Файл.ПолучитьОбъект();
    ФайлОбъект.Удалить();
    
КонецПроцедуры


#КонецОбласти

#Область СобытияЭлементов

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    КлючОбъекта = "Обработка.РабочийСтол_Заявки.Форма.СозданиеЗадания/Такси/НастройкиОкна";
    ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
    ХранилищеСистемныхНастроек.Удалить(КлючОбъекта,"", ИмяПользователя);
    КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
    УстановитьДатуЗапрета();
    
    ЗаполнитьФорму(Отказ, СтандартнаяОбработка, Параметры);
     
КонецПроцедуры

&НаСервере
Процедура УстановитьДатуЗапрета()
    
    Даты = ДатыЗапретаИзмененияСлужебный.РассчитанныеДатыЗапретаИзменения();
    Если даты.найти(ПараметрыСеанса.ТекущийПользователь)= Неопределено тогда
        ДатаЗапрета = даты.найти(Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей).ДатаЗапрета;
    иначе
        Попытка
            ДатаЗапрета = даты.найти(ПараметрыСеанса.ТекущийПользователь).ДатаЗапрета;
        Исключение
            ДатаЗапрета = Дата(1,1,1);
        КонецПопытки;
        
    КонецЕсли;
    ЭтаФорма.ТолькоПросмотр = ?(ДатаЗапрета <> Дата(1,1,1) и Дата <> Дата(1,1,1) и Дата <= ДатаЗапрета,не РольДоступна("ПолныеПрава"), Ложь);
    
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкаПриИзменении(Элемент)
    ЗаполнитьСотрудников(); 
    НомерСтроки = 0;
    
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
    Если НомерСтроки<>0 тогда
        Если Сотрудник <> Заявка.ЧекЛисты[НомерСтроки-1].Сотрудник тогда
            ДатаПланСотрудник = Неопределено;
        КонецЕсли; 
        
    КонецЕсли;
    Оформление();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
    СотрудникПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыполненоПриИзменении(Элемент)
    
    Если не Выполнено тогда
        Часы = 0 ;
    иначе
        Часы = ЧасыПлановые;
        ЧасыПриИзменении();
    КонецЕсли;
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСотрудников()
    
    Элементы.Сотрудник.СписокВыбора.Очистить();
    Элементы.Сотрудник.СписокВыбора.ЗагрузитьЗначения(Заявка.Смета.ВыгрузитьКолонку("Сотрудник")) ;
    
КонецПроцедуры

&НаКлиенте
Процедура ЧасыПриИзменении(Элемент = Неопределено)
    Оформление(); 
    Если не Часы = 0 тогда
        Выполнено = Истина;
        Дата = ТекущаяДата();
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
    
    Если Модифицированность тогда
        отказ = Истина;
        ПоказатьВопрос(новый ОписаниеОповещения("ПередЗакрытиемЗавершение",ЭтаФорма),"Данные были изменены, сохранить ?",РежимДиалогаВопрос.ДаНет);
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение (Ответ, ДП) Экспорт
    
    Если Ответ = КодВозвратаДиалога.Да тогда
        Записать(Неопределено);
    иначе
        Модифицированность = Ложь;
        для Каждого стр из Вложения цикл
            Если стр.Пометка тогда
                УдалитьФайл(стр.Значение);
            КонецЕсли;
        КонецЦикла;
        Закрыть();
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
    
    Оформление();
    
КонецПроцедуры

&НаКлиенте
Процедура ВажнаяПриИзменении(Элемент)
    Оформление();
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
    РаботаСВложениями(Отказ, "Добавление")
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередУдалением(Элемент, Отказ)
    РаботаСВложениями(Отказ, "Удаление")
КонецПроцедуры

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    ДанныеФайла = Неопределено;
    Файл = Вложения.НайтиПоИдентификатору(ВыбраннаяСтрока).Значение;
    ОбновитьПредпросмотр(ДанныеФайла,Файл);
    Если ДанныеФайла = Неопределено тогда 
        ОткрытьФайл(Элемент, Файл, Поле, СтандартнаяОбработка);
        Возврат; 
    КонецЕсли;
    ОткрытьФорму("Обработка.РабочийСтол_Заявки.Форма.ПросмотрВложения",новый Структура("Файл,Заголовок",ДанныеФайла,Файл),ЭтаФорма);
КонецПроцедуры



&НаКлиенте
Процедура ОткрытьФайл(Элемент, ТекущиеДанные, Поле, СтандартнаяОбработка)
    
    СтандартнаяОбработка = Ложь;
    
    
    КакОткрывать = РаботаСФайламиСлужебныйКлиент.ПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
    
    Если КакОткрывать = "ОткрыватьКарточку" Тогда
        ПоказатьЗначение(, ТекущиеДанные);
        Возврат;
    КонецЕсли;
    
    ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные,
    Неопределено, УникальныйИдентификатор, Неопределено,);
    
    ПараметрыОбработчика = Новый Структура;
    ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
    РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
    
КонецПроцедуры



&НаСервере
Процедура ОбновитьПредпросмотр(АдресДанныхФайла,ТекущиеДанные)
    
    РасширенияДляПредпросмотра = Новый СписокЗначений;
    РасширенияДляПредпросмотра.Добавить("bmp");
    РасширенияДляПредпросмотра.Добавить("emf");
    РасширенияДляПредпросмотра.Добавить("gif");
    РасширенияДляПредпросмотра.Добавить("ico");
    РасширенияДляПредпросмотра.Добавить("icon");
    РасширенияДляПредпросмотра.Добавить("jpg");
    РасширенияДляПредпросмотра.Добавить("jpeg");
    РасширенияДляПредпросмотра.Добавить("png");
    РасширенияДляПредпросмотра.Добавить("tiff");
    РасширенияДляПредпросмотра.Добавить("tif");
    РасширенияДляПредпросмотра.Добавить("wmf");
    
    Если ТекущиеДанные <> Неопределено И РасширенияДляПредпросмотра.НайтиПоЗначению(ТекущиеДанные.Расширение) <> Неопределено Тогда
        
        Попытка
            ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор,, АдресДанныхФайла);
            АдресДанныхФайла = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
        Исключение
            // Если файла не существует, то будет вызвано исключение.
            АдресДанныхФайла = Неопределено;
        КонецПопытки;
        
    Иначе
        
        АдресДанныхФайла = Неопределено;
        
    КонецЕсли;
    
    
КонецПроцедуры

&НаСервере
Процедура СоздатьЗаявкуНаОснованииСервер(Форма)
    
    ЗаполнитьЗначенияСвойств( Форма,Заявка,"Контрагент,КонтактноеЛицо, Приоритет, Организация");
    Форма.Основание = Заявка;
    Форма.Описание = Задание;
    Форма.НазначенаНа = Сотрудник;
    Если Ответственный <> Сотрудник тогда
        СтрокаОтв = Форма.Смета.Добавить();
        СтрокаОтв.Сотрудник = Ответственный;
        СтрокаОтв.Роль = СтрокаОтв.сотрудник.Роль;
    КонецЕсли;
    СтрокаОтв = Форма.Смета.Добавить();
    СтрокаОтв.Сотрудник = Сотрудник;
    СтрокаОтв.Роль = СтрокаОтв.сотрудник.Роль;
    
    СтрокаОтв.ПлановыеЧасы = ЧасыПлановые;
    
    стр = Форма.ЧекЛисты.Добавить();
    
    стр.ЧасыПлановые = 8;
    стр.Ответственный = Ответственный;
    стр.ЭтоЗадание = Истина;
    стр.ДатаПланОтветственный = ДатаПланОтветственный;
    стр.Задание = Форма.Название;
    стр.Сотрудник = Форма.НазначенаНа;
    
КонецПроцедуры

#КонецОбласти


#Область КомандыФормы

&НаКлиенте
Процедура ОткрытьИнструкциюПоОсмечиванию(Команда)
    
    КП_ОбщийМодуль_Клиент.ОткрытьВ1С(ФайлОсмечивания());
    
КонецПроцедуры

&НаСервере
Функция ФайлОсмечивания()
    
    Возврат Справочники.ВопросыИОтветы.НайтиПоКоду("000000005");
    
КонецФункции

&НаКлиенте
Процедура СоздатьЗаявкуНаОсновании(Команда)
    
    ФормаПодчиненного = ОткрытьФорму("Документ.Заявка.Форма.ФормаДокументаНовая");
    ОбъектФормы = ФормаПодчиненного.Объект;
    
    СоздатьЗаявкуНаОснованииСервер(ОбъектФормы);
    
    КопироватьДанныеФормы(ОбъектФормы, ФормаПодчиненного.Объект);
    
    ФормаПодчиненного.Модифицированность = Истина;
    
    Модифицированность = Ложь;
    Закрыть();
    
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
    
    ПоказатьВопрос(новый ОписаниеОповещения("ОтменитьЗавершение", ЭтаФорма),
        "Отменить задание" + ?(Модифицированность," (текущие изменения будут отменены)","") + " ?",РежимДиалогаВопрос.ДаНет) ;
    
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьЗавершение(Ответ,ДП) Экспорт
    
    Если Ответ = КодВозвратаДиалога.Да тогда
        
        ПараметрыФормы = новый Структура;
        ПараметрыФормы.Вставить("ссылка", Заявка);
        ПараметрыФормы.Вставить("НомерСтроки ", НомерСтроки );
        ПараметрыФормы.Вставить("ТолькоЧасы ", ТолькоЧасы);
    
        ЗаписатьНаСервере(Истина);
        ЗаполнитьФорму(Ложь, Истина, ПараметрыФормы);
        Оформление();
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
    //ОформлениеЗадания();
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
    //ОформлениеЗадания();
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеПриИзменении(Элемент)
    ОформлениеЗадания();
КонецПроцедуры

#КонецОбласти




