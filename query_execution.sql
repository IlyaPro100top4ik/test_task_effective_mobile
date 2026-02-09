/*Задание 1: Абитуриенты
Есть таблица examination с двумя полями: id (id абитуриента), scores (кол-во набранных баллов дополнительного вступительного испытания от 0 до 100).
Требуется реализовать запрос, который создаёт колонку с позицией абитуриента в общем рейтинге.*/

SELECT 
    id,
    scores,
    RANK() OVER (ORDER BY scores DESC) AS position
FROM examination
ORDER BY scores DESC, id;


/*Задание 2: FULL JOIN
Представьте две таблицы: первая содержит 30 строк, а вторая — 20 строк. Мы выполняем операцию FULL JOIN между ними.
Какой диапазон возможного количества строк может быть в результирующей таблице, если учесть, что ключи для соединения могут быть 
как полностью совпадающими, так и абсолютно уникальными?


Ответ дать в краткой форме, например: минимально 30 и максимально 50 строк*/

-- Задание 3: Покупки

--Вывести ID клиентов, которые за последний месяц по всем своим счетам совершили покупок меньше, чем на 5000 рублей.Без использования подзапросов и оконных функций.

SELECT 
    a.client_id
FROM account a
LEFT JOIN transaction t 
    ON a.id = t.account_id 
    -- Транзакции за последние 30 дней
    AND t.transaction_date >= CURRENT_DATE - INTERVAL '30 days'
    AND t.transaction_date <= CURRENT_DATE
    -- Только покупки (если тип указан)
    AND (t.type = 'PUR' OR t.type IS NULL)  -- адаптивно
    -- Счёт должен быть активен на дату транзакции
    AND t.transaction_date >= a.open_dt
    AND (a.close_dt IS NULL OR t.transaction_date <= a.close_dt)
GROUP BY a.client_id
HAVING COALESCE(SUM(t.amount), 0) < 5000.00
ORDER BY a.client_id;