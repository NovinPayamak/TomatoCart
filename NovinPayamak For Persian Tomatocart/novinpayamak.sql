
ALTER TABLE `toc_orders` ADD `delivery_telephone` VARCHAR( 32 ) NOT NULL AFTER `delivery_address_format` ;
ALTER TABLE `toc_orders` ADD `billing_telephone` VARCHAR( 32 ) NOT NULL AFTER `billing_address_format` ;

ALTER TABLE `toc_orders_status_history` ADD `sms_customer_notified` int(1) default '0' AFTER `customer_notified` ;


DROP TABLE IF EXISTS toc_sms_templates;
CREATE TABLE toc_sms_templates (
  sms_templates_id int(11) NOT NULL auto_increment,
  sms_templates_name varchar(100) NOT NULL,
  sms_templates_status tinyint(1) NOT NULL,
  PRIMARY KEY  (sms_templates_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS toc_sms_templates_description;
CREATE TABLE toc_sms_templates_description (
  sms_templates_id int(11) NOT NULL,
  language_id int(11) NOT NULL,
  sms_title varchar(255) NOT NULL,
  sms_content text NOT NULL,
  PRIMARY KEY  (sms_templates_id,language_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



INSERT INTO toc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, use_function, set_function, date_added) VALUES ('ارسال پیام کوتاه', 'SEND_SMS', '-1', 'ارسال پیام کوتاه فعال باشد؟', '13', '1', 'osc_cfg_use_get_boolean_value', 'osc_cfg_set_boolean_value(array(1, -1))', now());
INSERT INTO toc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, use_function, set_function, date_added) VALUES ('ارسال پیام کوتاه به مشتری در زمان ثبت سفارش جدید', 'SEND_SMS_NEW_OREDER_TO_USER', '-1', 'هنگامی که مشتری سفارش جدیدی ثبت می کند برای او پیام کوتاه تشکر ارسال شود؟', '13', '2', 'osc_cfg_use_get_boolean_value', 'osc_cfg_set_boolean_value(array(1, -1))', now());
INSERT INTO toc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, use_function, set_function, date_added) VALUES ('ارسال پیام کوتاه به مدیر در زمان ثبت سفارش جدید', 'SEND_SMS_NEW_OREDER_TO_ADMIN', '-1', 'هنگام ثبت سفارش جدید در فروشگاه به مدیر با پیام کوتاه اطلاع رسانی شود؟', '13', '3', 'osc_cfg_use_get_boolean_value', 'osc_cfg_set_boolean_value(array(1, -1))', now());
INSERT INTO toc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, use_function, set_function, date_added) VALUES ('اطلاع رسانی تغییر وضعیت سفارش به کاربر', 'SEND_SMS_ORDER_STATUS_UPDATED', '-1', 'در زمان بروز رسانی وضعیت سفارش به مشتری با پیامک اطلاع داده شود؟', '13', '4', 'osc_cfg_use_get_boolean_value', 'osc_cfg_set_boolean_value(array(1, -1))', now());
INSERT INTO toc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, use_function, set_function, date_added) VALUES ('پیام کوتاه اخطار اتمام موجودی به مدیر', 'SEND_SMS_STOCK_ALERT', '-1', 'وقتی موجودی یک کالا از مقدار سطح مجاز کمتر می شود توسط پیام به مدیر اطلاع داده شود؟', '13', '5', 'osc_cfg_use_get_boolean_value', 'osc_cfg_set_boolean_value(array(1, -1))', now());
INSERT INTO toc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('سرویس دهنده پیام کوتاه', 'SMS_GATEWAY', 'NovinPayamak', 'سایتی که از آن سرویس ارسال پیام کوتاه دارید را انتخاب کنید.', '13', '6', 'osc_cfg_set_boolean_value(array(\'NovinPayamak\'))', now());
INSERT INTO toc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('کلمه عبور', 'SMS_GETWAY_PASSWORD', '', 'کلمه عبور درگاه پیام کوتاه', '13', '8', now());
INSERT INTO toc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('شماره ارسال کننده', 'SMS_GETWAY_FROM_NUMBER', '', 'شماره ارسال کننده درگاه پیام کوتاه یا شماره خط اختصاصی', '13', '9', now());
INSERT INTO toc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('شماره همراه مدیر فروشگاه', 'SMS_ADMIN_MOBILE_NUMBER', '', 'شماره تلفن همراه مدیر فروشگاه جهت ارسال پیامک', '13', '10', now());


INSERT INTO toc_configuration_group VALUES ('13', 'Sms Options', 'General setting for SMS', '13', '1');

#sms template
INSERT INTO toc_sms_templates (sms_templates_id, sms_templates_name, sms_templates_status) VALUES
(1, 'new_order_created', 1),
(2, 'new_order_created_admin', 1),
(3, 'out_of_stock_alerts', 1),
(4, 'admin_order_status_updated', 1);

INSERT INTO toc_sms_templates_description (sms_templates_id, language_id, sms_title, sms_content) VALUES
(1, 1, 'ثبت سفارش جدید', '%%customer_name%% گرامی ، سفارش شما ثبت گردید. -- شماره سفارش : %%order_number%% -- وضعيت سفارش : %%order_status%% -- %%store_name%%'),
(2, 1, 'اطلاع رسانی سفارش جدید برای مدیر', 'سفارش جدید--شماره سفارش : %%order_number%%--تاريخ سفارش : %%date_ordered%% -- تلفن مشتری : %%telephone%%--وضعيت سفارش : %%order_status%%--%%store_name%%'),
(3, 1, 'اتمام موجودی', '%%products_name%% موجودي ندارد--تعداد باقي مانده: %%products_quantity%%.--%%store_name%%'),
(4, 1, 'بروز رسانی سفارش', 'سفارش شما بروز شد -- شماره سفارش: %%order_number%% -- وضعیت سفارش: %%orders_status%% . --%%store_name%%');

