# -*- encoding : utf-8 -*-
class ReplaceActivityReportViews < ActiveRecord::Migration
  def change
    execute "create  or replace view activity_report_views as
    select
    `sar`.`report_time` AS `report_time`,
    `sar`.`tag` AS `tag`,
    `sar`.`activity_num` AS `seed_activity_num`,
    `bar`.`activity_num` AS `bash_activity_num`,
    `sar`.`embed_num` AS `embed_num`,
    `sar`.`sign_num` AS `sign_num`,
    (`sar`.`request_num` / `sar`.`activity_num`) AS `seed_request_avg`,
    (`bar`.`request_num` / `bar`.`activity_num`) AS `bash_request_avg`
    from (`seed_activity_reports` `sar` left join `bash_activity_reports` `bar`
    on(((`sar`.`tag` = `bar`.`tag`) and (`sar`.`report_time` = `bar`.`report_time`))))
    union select
    `sar`.`report_time` AS `report_time`,
    `sar`.`tag` AS `tag`,
    `sar`.`activity_num` AS `seed_activity_num`,
    `bar`.`activity_num` AS `bash_activity_num`,
    `sar`.`embed_num` AS `embed_num`,
    `sar`.`sign_num` AS `sign_num`,
    (`sar`.`request_num` / `sar`.`activity_num`) AS `seed_request_avg`,
    (`bar`.`request_num` / `bar`.`activity_num`) AS `bash_request_avg`
    from (`bash_activity_reports` `bar` left join `seed_activity_reports` `sar`
    on(((`sar`.`tag` = `bar`.`tag`) and (`sar`.`report_time` = `bar`.`report_time`))))"
  end
end
