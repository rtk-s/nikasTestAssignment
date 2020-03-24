
Описание ТЗ:
Нужно разработать приложение, которое показывает каталог жилищных комплексов.
Каталог строится на основе объекта получаемого при GET запросе в ответе от сервера по адресу http://api.trend-dev.ru/v3_1/blocks/search/ в формате JSON.
При нажатии на "Загрузить еще 10" происходит загрузка еще 10 ЖК в каталог.
Над каталогом есть dropdown меню с ценой от и до. При нажатии на какой-либо вариант открывается панель с вариантами цен. 
Минимальное значение варианта цены 1 000 000, шаг в 500 000, в одном списке показывается по 10 вариантов.
При выборе "цены от" в списке "цена до" варианты должны начинаться по правилу "цена от + шаг".
Выбранная цена должна подставляться вместо надписи "Цена от" или "Цена до".

Принимаемые GET параметры: {
show_type: 'list', // тип вывода
count: 10, // кол-во показываемых ЖК на странице
offset: 0, // смещение кол-ва показываемых объектов
cache: false, 
price_from: 0, // Цена от
price_to: 0 // Цена до
sort // Сортировка по полю. Принимает price, subway, region