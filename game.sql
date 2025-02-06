INSERT INTO campaigns.targeting(id, ab_experiment)
VALUES (11, 'reward_platform_january_2025.test');

INSERT INTO campaigns.profile_layout(id, platform, description) VALUES
    (10011, 'desktop', 'описание');

ALTER TYPE campaigns.award_type ADD VALUE 'esg_points';

SELECT unnest(enum_range(NULL::campaigns.award_type));

INSERT INTO campaigns.award (id, description, award_type) VALUES
                                                              (3, 'ESG баллы', 'esg_points'),
                                                              (4, 'Авито Бонусы', 'bonuses'),
                                                              (5, 'Промокоды на отчет Автотеки', 'autoteka_report')
    ON CONFLICT (id) DO NOTHING;

INSERT INTO campaigns.award_for_completing (id, description, award_info)
VALUES (222, '10 esg баллов', '{"esgPoints": 10}'),
       (223, '50 Авито Бонусов', '{"bonuses": 50}'),
       (224, 'Промокод на отчет Автотеки', '{"autotekaReport": 1}');

INSERT INTO campaigns.specific_award (id, award_id, award_parameters, award_for_completing_id)
VALUES (1114, 3,
        '{"esg_points": {"ttl": 5184000000000000, "amount": 10, "comment": "Reward platform. Campaign_id=11. Task_group_id=113.\nГруппа с ESG заданиями", "top_up_title": "Бонусы - награда за задания", "remind_in_days": 7, "issuer_category_id": 100000}}',
        222);

INSERT INTO campaigns.campaign(id, started_at, ended_at, registration_started_at, registration_ended_at, targeting_id)
VALUES (22, '2025-01-16 00:00:00+03', '2025-04-09 00:00:00+03', '2025-01-16 00:00:00+03', '2025-02-09 00:00:00+03', 11);

INSERT INTO campaigns.task_group (id, campaign_id, type, need, award_for_completing_id, started_at, ended_at, visual_components)
VALUES (211, 22, 'parallel'::campaigns.task_group_type, 5, 222, '2025-01-16 00:00:00+03', '2025-02-09 00:00:00+03',
        '{"title": "ESG Задания", "joinTasks": true, "description": "Выполняйте задания и зарабатывайте ESG баллы", "backgroundColor": "monoHorizontalGreen"}');

-- ESG Задания
INSERT INTO campaigns.rule (id, description, event_requirements)
VALUES (301, 'Разместите объявление о передаче вещей', '{"requirements": [{"steps": [{"eventIDs": [3011]}]}]}'),
       (302, 'Добавьте объявление в избранное', '{"requirements": [{"steps": [{"eventIDs": [3021]}]}]}'),
       (303, 'Просмотрите подборку устойчивых товаров', '{"requirements": [{"steps": [{"eventIDs": [3031]}]}]}'),
       (304, 'Прочитайте статью о раздельном сборе', '{"requirements": [{"steps": [{"eventIDs": [3041]}]}]}'),
       (305, 'Оставьте отзыв на объявление', '{"requirements": [{"steps": [{"eventIDs": [3051]}]}]}');

INSERT INTO campaigns.task (id, description, task_group_id, depends_on_task_id, dependency_config, rule_id, need,
                            unique_event_object, precheck_id, award_for_completing_id, started_at, ended_at,
                            visual_components, frequency, progress_award_for_completing_id)
VALUES (2111, 'Разместите объявление о передаче вещей', 211, null, null, 301, 1, true, null, 222, '2025-01-16 00:00:00+03', '2025-02-09 00:00:00+03', '{"title":"Передайте вещи бесплатно","hints":{"desktop":{"texts":["Разместите объявление и получите награду"],"title":"Передача вещей","shortcutsInfo":[{"image":"https://avito.st/s/app/visual_rubricator_laas/light/280x120/cat_27_v2_L.png","title":"Бесплатные вещи","backgroundColor":"warmGray4"}]}}}', null, null),
       (2112, 'Добавьте объявление в избранное', 211, null, null, 302, 1, true, null, 223, '2025-01-16 00:00:00+03', '2025-02-09 00:00:00+03', '{"title":"Поддержите ответственное потребление","hints":{"desktop":{"texts":["Добавьте объявление в избранное"],"title":"Ответственное потребление"}}}', null, null),
       (2113, 'Просмотрите подборку устойчивых товаров', 211, null, null, 303, 1, true, null, 222, '2025-01-16 00:00:00+03', '2025-02-09 00:00:00+03', '{"title":"Узнайте больше об эко-товарах","hints":{"desktop":{"texts":["Откройте подборку устойчивых товаров"],"title":"Эко-товары"}}}', null, null),
       (2114, 'Прочитайте статью о раздельном сборе', 211, null, null, 304, 1, true, null, 224, '2025-01-16 00:00:00+03', '2025-02-09 00:00:00+03', '{"title":"Научитесь сортировать отходы","hints":{"desktop":{"texts":["Прочитайте статью о раздельном сборе"],"title":"Раздельный сбор"}}}', null, null),
       (2115, 'Оставьте отзыв на объявление', 211, null, null, 305, 1, true, null, 222, '2025-01-16 00:00:00+03', '2025-02-09 00:00:00+03', '{"title":"Поделитесь опытом о сделке","hints":{"desktop":{"texts":["Оставьте отзыв и помогите сообществу"],"title":"Отзывы"}}}', null, null);

INSERT INTO campaigns.profile_layout_component (id, order_number, profile_layout_id)
VALUES (222, 3, 10011);

INSERT INTO campaigns.profile_layout_container (id, columns_template, row_gap, column_gap, profile_layout_component_id)
VALUES (222, 2, 3, 4, 222);

INSERT INTO campaigns.widget_slot (id, order_number, columns, container_id)
VALUES (222, 3, 1, 222);

INSERT INTO campaigns.regular_tasks_widget (slug, version, priority, id, widget_slot_id, campaign_id, visual_components,
                                            registration_type)
VALUES ('esg-tasks', 1, 2, 222, 222, 22,
        '{"title": ["ESG Задания за баллы"], "description": ["Выполняйте задания и получайте награды"]}',
        'on_show'::campaigns.registration_type);


INSERT INTO campaigns.banner_widget(id, slug, version, widget_slot_id, visual_components, priority) VALUES
    (12, 'campaign_result_banner_1', 1, 222, '{"title": ["Итоги ESG кампании"], "description": ["Вы участвовали в полезных заданиях"]}', 1);



