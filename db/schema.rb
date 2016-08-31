# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160816080001) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "password",   limit: 255
    t.integer  "status",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "accounts_roles", id: false, force: :cascade do |t|
    t.integer "account_id", limit: 4
    t.integer "role_id",    limit: 4
  end

  add_index "accounts_roles", ["account_id"], name: "fk_accounts_roles_account_id", using: :btree
  add_index "accounts_roles", ["role_id"], name: "fk_accounts_roles_role_id", using: :btree

  create_table "activity_report_views", id: false, force: :cascade do |t|
    t.date    "report_time"
    t.string  "tag",               limit: 255
    t.integer "seed_activity_num", limit: 4
    t.integer "bash_activity_num", limit: 4
    t.integer "embed_num",         limit: 4
    t.integer "sign_num",          limit: 4
    t.decimal "seed_request_avg",              precision: 14, scale: 4
    t.decimal "bash_request_avg",              precision: 14, scale: 4
  end

  create_table "activity_situation_reports", force: :cascade do |t|
    t.string   "report_type",       limit: 255
    t.integer  "activation_num",    limit: 4
    t.string   "tag",               limit: 255
    t.integer  "activity_num",      limit: 4
    t.integer  "request_times",     limit: 4
    t.float    "avg_request_times", limit: 24
    t.string   "record_time",       limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "activity_situation_reports", ["record_time"], name: "index_activity_situation_reports_on_record_time", using: :btree
  add_index "activity_situation_reports", ["report_type"], name: "index_activity_situation_reports_on_report_type", using: :btree
  add_index "activity_situation_reports", ["tag"], name: "index_activity_situation_reports_on_tag", using: :btree

  create_table "activity_total_reports", force: :cascade do |t|
    t.string   "report_type",              limit: 255
    t.string   "tag",                      limit: 255
    t.integer  "total_activation_num",     limit: 4
    t.integer  "yesterday_activation_num", limit: 4
    t.integer  "yesterday_activity_num",   limit: 4
    t.integer  "activity7",                limit: 4
    t.integer  "activity30",               limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "activity_total_reports", ["report_type"], name: "index_activity_total_reports_on_report_type", using: :btree
  add_index "activity_total_reports", ["tag"], name: "index_activity_total_reports_on_tag", using: :btree

  create_table "apk_md5_alarm_reports", force: :cascade do |t|
    t.string   "tag",                 limit: 255
    t.date     "tag_created_at"
    t.integer  "user_total_count",    limit: 4
    t.integer  "abnormal_user_count", limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "apk_md5_alarm_reports", ["tag"], name: "index_apk_md5_alarm_reports_on_tag", using: :btree

  create_table "bash_activity_reports", force: :cascade do |t|
    t.string   "tag",            limit: 255
    t.integer  "activity_num",   limit: 4
    t.integer  "activation_num", limit: 4
    t.integer  "request_num",    limit: 4
    t.date     "report_time"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "bash_activity_reports", ["report_time"], name: "index_bash_activity_reports_on_report_time", using: :btree
  add_index "bash_activity_reports", ["tag"], name: "index_bash_activity_reports_on_tag", using: :btree

  create_table "bash_alive_reports", force: :cascade do |t|
    t.string   "tag",            limit: 255
    t.integer  "activation_num", limit: 4
    t.integer  "stay_alive2",    limit: 4
    t.integer  "stay_alive3",    limit: 4
    t.integer  "stay_alive7",    limit: 4
    t.integer  "stay_alive15",   limit: 4
    t.integer  "stay_alive30",   limit: 4
    t.date     "report_time"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "bash_alive_reports", ["report_time"], name: "index_bash_alive_reports_on_report_time", using: :btree
  add_index "bash_alive_reports", ["tag"], name: "index_bash_alive_reports_on_tag", using: :btree

  create_table "charge_activation_reports", force: :cascade do |t|
    t.date     "report_date"
    t.integer  "activation_num",  limit: 4
    t.string   "tag",             limit: 255
    t.string   "product_version", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "charge_activation_reports", ["product_version"], name: "index_charge_activation_reports_on_product_version", using: :btree
  add_index "charge_activation_reports", ["report_date"], name: "index_charge_activation_reports_on_report_date", using: :btree
  add_index "charge_activation_reports", ["tag"], name: "index_charge_activation_reports_on_tag", using: :btree

  create_table "charge_activity_month_reports", force: :cascade do |t|
    t.string   "report_date",     limit: 255
    t.integer  "activity_num",    limit: 4
    t.integer  "request_times",   limit: 4
    t.float    "request_per_avg", limit: 24
    t.integer  "cmcc_num",        limit: 4
    t.integer  "cucc_num",        limit: 4
    t.integer  "ctcc_num",        limit: 4
    t.integer  "others_sp_num",   limit: 4
    t.string   "tag",             limit: 255
    t.string   "province",        limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "product_version", limit: 255
  end

  add_index "charge_activity_month_reports", ["product_version"], name: "index_charge_activity_month_reports_on_product_version", using: :btree
  add_index "charge_activity_month_reports", ["province"], name: "index_charge_activity_month_reports_on_province", using: :btree
  add_index "charge_activity_month_reports", ["report_date"], name: "index_charge_activity_month_reports_on_report_date", using: :btree
  add_index "charge_activity_month_reports", ["tag"], name: "index_charge_activity_month_reports_on_tag", using: :btree

  create_table "charge_activity_reports", force: :cascade do |t|
    t.date     "report_date"
    t.integer  "activity_num",    limit: 4
    t.integer  "request_times",   limit: 4
    t.float    "request_per_avg", limit: 24
    t.integer  "cmcc_num",        limit: 4
    t.integer  "cucc_num",        limit: 4
    t.integer  "ctcc_num",        limit: 4
    t.integer  "others_sp_num",   limit: 4
    t.string   "tag",             limit: 255
    t.string   "product_version", limit: 255
    t.string   "province",        limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "charge_activity_reports", ["product_version"], name: "index_charge_activity_reports_on_product_version", using: :btree
  add_index "charge_activity_reports", ["province"], name: "index_charge_activity_reports_on_province", using: :btree
  add_index "charge_activity_reports", ["report_date"], name: "index_charge_activity_reports_on_report_date", using: :btree
  add_index "charge_activity_reports", ["tag"], name: "index_charge_activity_reports_on_tag", using: :btree

  create_table "charge_alive_reports", force: :cascade do |t|
    t.date     "report_date"
    t.integer  "activation_num",   limit: 4
    t.integer  "stay_alive2_num",  limit: 4
    t.integer  "stay_alive3_num",  limit: 4
    t.integer  "stay_alive7_num",  limit: 4
    t.integer  "stay_alive15_num", limit: 4
    t.integer  "stay_alive30_num", limit: 4
    t.string   "tag",              limit: 255
    t.string   "product_version",  limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "charge_alive_reports", ["product_version"], name: "index_charge_alive_reports_on_product_version", using: :btree
  add_index "charge_alive_reports", ["report_date"], name: "index_charge_alive_reports_on_report_date", using: :btree
  add_index "charge_alive_reports", ["tag"], name: "index_charge_alive_reports_on_tag", using: :btree

  create_table "charge_monthly_code_alive_reports", force: :cascade do |t|
    t.date     "report_date"
    t.integer  "sp_id",                     limit: 4
    t.string   "code",                      limit: 255
    t.string   "dest_number",               limit: 255
    t.integer  "theory_alive",              limit: 4,   default: 0
    t.integer  "order_alive",               limit: 4,   default: 0
    t.integer  "deducted_alive",            limit: 4,   default: 0
    t.integer  "last_month_deducted_alive", limit: 4,   default: 0
    t.integer  "order_charged_alive",       limit: 4,   default: 0
    t.integer  "activation",                limit: 4,   default: 0
    t.integer  "order_activation",          limit: 4,   default: 0
    t.integer  "deducted_activation",       limit: 4,   default: 0
    t.integer  "order_activation_charged",  limit: 4,   default: 0
    t.integer  "lt_72",                     limit: 4,   default: 0
    t.integer  "gt_72",                     limit: 4,   default: 0
    t.integer  "unsubscribed_alive",        limit: 4,   default: 0
    t.integer  "rate",                      limit: 4,   default: 0
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "sp_name",                   limit: 255
  end

  create_table "charge_monthly_code_downlink_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "report_type",                  limit: 255
    t.string   "code_name",                    limit: 255
    t.integer  "deliver_users_num",            limit: 4,   default: 0
    t.integer  "theory_successful_users_num",  limit: 4,   default: 0
    t.integer  "activation_users_num",         limit: 4,   default: 0
    t.integer  "lt_72_unsubscribed_users_num", limit: 4
    t.integer  "gt_72_unsubscribed_users_num", limit: 4
    t.integer  "no_downlink_users_num",        limit: 4,   default: 0
    t.integer  "low_downlink_users_num",       limit: 4,   default: 0
    t.integer  "successful_users_num",         limit: 4,   default: 0
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "charge_situation_reports", force: :cascade do |t|
    t.string   "tag",               limit: 255
    t.string   "product_version",   limit: 255
    t.integer  "activation_num",    limit: 4
    t.integer  "activity_num",      limit: 4
    t.integer  "request_times",     limit: 4
    t.float    "avg_request_times", limit: 24
    t.string   "record_time",       limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "charge_total_reports", force: :cascade do |t|
    t.string   "tag",                      limit: 255
    t.string   "product_version",          limit: 255
    t.integer  "total_activation_num",     limit: 4
    t.integer  "yesterday_activation_num", limit: 4
    t.integer  "yesterday_activity_num",   limit: 4
    t.integer  "activity7",                limit: 4
    t.integer  "activity30",               limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string   "job_id",            limit: 255,   null: false
    t.text     "log",               limit: 65535
    t.datetime "last_performed_at"
    t.boolean  "healthy"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "crono_jobs", ["job_id"], name: "index_crono_jobs_on_job_id", unique: true, using: :btree

  create_table "ework_arrival_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",                  limit: 255
    t.integer  "ework_activation",     limit: 4
    t.integer  "seed_active",          limit: 4
    t.integer  "seed_executing",       limit: 4
    t.integer  "seed_executied",       limit: 4
    t.integer  "seed_successed",       limit: 4
    t.integer  "seed_installed",       limit: 4
    t.integer  "seed_started",         limit: 4
    t.integer  "seed_failed",          limit: 4
    t.integer  "seed_v8_exists",       limit: 4
    t.integer  "seed_v9_exists",       limit: 4
    t.integer  "v9_activity",          limit: 4
    t.float    "seed_active_ratio",    limit: 24
    t.float    "seed_executing_ratio", limit: 24
    t.float    "seed_executied_ratio", limit: 24
    t.float    "seed_successed_ratio", limit: 24
    t.float    "seed_installed_ratio", limit: 24
    t.float    "seed_started_ratio",   limit: 24
    t.float    "seed_failed_ratio",    limit: 24
    t.float    "seed_v8_exists_ratio", limit: 24
    t.float    "seed_v9_exists_ratio", limit: 24
    t.float    "v9_activity_ratio",    limit: 24
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "ework_arrival_reports", ["report_date"], name: "index_ework_arrival_reports_on_report_date", using: :btree
  add_index "ework_arrival_reports", ["tag"], name: "index_ework_arrival_reports_on_tag", using: :btree

  create_table "ework_conversion_medians", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.float    "get_url_ratio",           limit: 24
    t.float    "download_jar_ratio",      limit: 24
    t.float    "merge_jar_ratio",         limit: 24
    t.float    "launch_jar_ratio",        limit: 24
    t.float    "seed_executed_ratio",     limit: 24
    t.float    "seed_active_ratio",       limit: 24
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.float    "seed_active_aid_ratio",   limit: 24
    t.float    "seed_executed_aid_ratio", limit: 24
  end

  create_table "ework_conversion_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",                     limit: 255
    t.integer  "app_activation",          limit: 4
    t.integer  "get_url",                 limit: 4
    t.float    "get_url_ratio",           limit: 24
    t.integer  "download_jar",            limit: 4
    t.float    "download_jar_ratio",      limit: 24
    t.integer  "merge_jar",               limit: 4
    t.float    "merge_jar_ratio",         limit: 24
    t.integer  "launch_jar",              limit: 4
    t.float    "launch_jar_ratio",        limit: 24
    t.integer  "seed_active",             limit: 4
    t.float    "seed_active_ratio",       limit: 24
    t.integer  "seed_executed",           limit: 4
    t.float    "seed_executed_ratio",     limit: 24
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "seed_active_aid",         limit: 4
    t.float    "seed_active_aid_ratio",   limit: 24
    t.integer  "seed_executed_aid",       limit: 4
    t.float    "seed_executed_aid_ratio", limit: 24
  end

  add_index "ework_conversion_reports", ["report_date"], name: "index_ework_conversion_reports_on_report_date", using: :btree
  add_index "ework_conversion_reports", ["tag"], name: "index_ework_conversion_reports_on_tag", using: :btree

  create_table "medians", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "median_ratio2",  limit: 255
    t.string   "median_ratio3",  limit: 255
    t.string   "median_ratio7",  limit: 255
    t.string   "median_ratio15", limit: 255
    t.string   "median_ratio30", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "package_infos", id: false, force: :cascade do |t|
    t.integer  "id",         limit: 4
    t.string   "tag",        limit: 255
    t.string   "md5",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: :cascade do |t|
    t.integer "link_id",      limit: 4
    t.string  "link_type",    limit: 255
    t.integer "function_id",  limit: 4,     null: false
    t.integer "subsystem_id", limit: 4,     null: false
    t.integer "status",       limit: 4,     null: false
    t.text    "operates",     limit: 65535
    t.integer "sort",         limit: 4
  end

  create_table "roles", force: :cascade do |t|
    t.string "name",        limit: 40,    null: false
    t.text   "description", limit: 65535
  end

  create_table "sdk_activation_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",            limit: 255
    t.integer  "activation_num", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "sdk_activation_reports", ["report_date"], name: "index_sdk_activation_reports_on_report_date", using: :btree
  add_index "sdk_activation_reports", ["tag"], name: "index_sdk_activation_reports_on_tag", using: :btree

  create_table "sdk_activity_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",             limit: 255
    t.integer  "activity_num",    limit: 4
    t.integer  "request_times",   limit: 4
    t.float    "request_per_avg", limit: 24
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "sdk_activity_reports", ["report_date"], name: "index_sdk_activity_reports_on_report_date", using: :btree
  add_index "sdk_activity_reports", ["tag"], name: "index_sdk_activity_reports_on_tag", using: :btree

  create_table "sdk_alive_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",              limit: 255
    t.integer  "activation_num",   limit: 4
    t.integer  "stay_alive2_num",  limit: 4
    t.integer  "stay_alive3_num",  limit: 4
    t.integer  "stay_alive7_num",  limit: 4
    t.integer  "stay_alive15_num", limit: 4
    t.integer  "stay_alive30_num", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "sdk_alive_reports", ["report_date"], name: "index_sdk_alive_reports_on_report_date", using: :btree
  add_index "sdk_alive_reports", ["tag"], name: "index_sdk_alive_reports_on_tag", using: :btree

  create_table "seed_activation_reports", force: :cascade do |t|
    t.string   "partner",               limit: 255
    t.string   "tag",                   limit: 255
    t.integer  "seed_activation_num",   limit: 4
    t.integer  "panda_activation_num",  limit: 4
    t.integer  "old_user_active_num",   limit: 4
    t.integer  "old_user_lose_num",     limit: 4
    t.integer  "bash_activation_num",   limit: 4
    t.float    "bash_activation_ratio", limit: 24
    t.integer  "signature_num",         limit: 4
    t.float    "signature_ratio",       limit: 24
    t.date     "report_time"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "reset_num",             limit: 4
    t.float    "reset_num_ratio",       limit: 24
    t.integer  "old_user_activity_num", limit: 4
  end

  add_index "seed_activation_reports", ["report_time"], name: "index_seed_activation_reports_on_report_time", using: :btree
  add_index "seed_activation_reports", ["tag"], name: "index_seed_activation_reports_on_tag", using: :btree

  create_table "seed_activity_reports", force: :cascade do |t|
    t.string   "tag",               limit: 255
    t.integer  "activity_num",      limit: 4
    t.integer  "activation_num",    limit: 4
    t.integer  "embed_num",         limit: 4
    t.integer  "sign_num",          limit: 4
    t.integer  "request_num",       limit: 4
    t.date     "report_time"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "v9_activity_num",   limit: 4
    t.integer  "v9_activation_num", limit: 4
    t.integer  "v9_request_num",    limit: 4
  end

  add_index "seed_activity_reports", ["report_time"], name: "index_seed_activity_reports_on_report_time", using: :btree
  add_index "seed_activity_reports", ["tag"], name: "index_seed_activity_reports_on_tag", using: :btree

  create_table "seed_alive_reports", force: :cascade do |t|
    t.string   "tag",            limit: 255
    t.integer  "activation_num", limit: 4
    t.integer  "stay_alive2",    limit: 4
    t.integer  "stay_alive3",    limit: 4
    t.integer  "stay_alive7",    limit: 4
    t.integer  "stay_alive15",   limit: 4
    t.integer  "stay_alive30",   limit: 4
    t.date     "report_time"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "seed_alive_reports", ["report_time"], name: "index_seed_alive_reports_on_report_time", using: :btree
  add_index "seed_alive_reports", ["tag"], name: "index_seed_alive_reports_on_tag", using: :btree

  create_table "seed_apk_md5_alarms", id: false, force: :cascade do |t|
    t.integer  "id",          limit: 4
    t.integer  "uid",         limit: 4
    t.string   "tag",         limit: 255
    t.string   "md5",         limit: 255
    t.datetime "record_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seed_arrival_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",                  limit: 255
    t.integer  "seed_activation",      limit: 4
    t.integer  "seed_active",          limit: 4
    t.integer  "seed_executing",       limit: 4
    t.integer  "seed_executied",       limit: 4
    t.integer  "seed_successed",       limit: 4
    t.integer  "seed_installed",       limit: 4
    t.integer  "seed_started",         limit: 4
    t.integer  "seed_failed",          limit: 4
    t.integer  "seed_v8_exists",       limit: 4
    t.integer  "seed_v9_exists",       limit: 4
    t.integer  "v9_activity",          limit: 4
    t.float    "seed_active_ratio",    limit: 24
    t.float    "seed_executing_ratio", limit: 24
    t.float    "seed_executied_ratio", limit: 24
    t.float    "seed_successed_ratio", limit: 24
    t.float    "seed_installed_ratio", limit: 24
    t.float    "seed_started_ratio",   limit: 24
    t.float    "seed_failed_ratio",    limit: 24
    t.float    "seed_v8_exists_ratio", limit: 24
    t.float    "seed_v9_exists_ratio", limit: 24
    t.float    "v9_activity_ratio",    limit: 24
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "seed_arrival_reports", ["report_date"], name: "index_seed_arrival_reports_on_report_date", using: :btree
  add_index "seed_arrival_reports", ["tag"], name: "index_seed_arrival_reports_on_tag", using: :btree

  create_table "seed_device_detail_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",                   limit: 255
    t.string   "brand",                 limit: 255
    t.string   "model",                 limit: 255
    t.integer  "count",                 limit: 4
    t.float    "proportion_ratio",      limit: 24
    t.integer  "success_count",         limit: 4
    t.float    "success_ratio",         limit: 24
    t.float    "succ_proportion_ratio", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seed_device_detail_reports", ["brand"], name: "index_seed_device_detail_reports_on_brand", using: :btree
  add_index "seed_device_detail_reports", ["model"], name: "index_seed_device_detail_reports_on_model", using: :btree
  add_index "seed_device_detail_reports", ["report_date"], name: "index_seed_device_detail_reports_on_report_date", using: :btree
  add_index "seed_device_detail_reports", ["tag"], name: "index_seed_device_detail_reports_on_tag", using: :btree

  create_table "seed_prop_detail_monthly_reports", force: :cascade do |t|
    t.string   "report_date",           limit: 255
    t.string   "tag",                   limit: 255
    t.string   "board",                 limit: 255
    t.string   "manufacturer",          limit: 255
    t.integer  "count",                 limit: 4
    t.float    "proportion_ratio",      limit: 24
    t.integer  "success_count",         limit: 4
    t.float    "success_ratio",         limit: 24
    t.float    "succ_proportion_ratio", limit: 24
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "seed_prop_detail_monthly_reports", ["board"], name: "index_seed_prop_detail_monthly_reports_on_board", using: :btree
  add_index "seed_prop_detail_monthly_reports", ["manufacturer"], name: "index_seed_prop_detail_monthly_reports_on_manufacturer", using: :btree
  add_index "seed_prop_detail_monthly_reports", ["report_date"], name: "index_seed_prop_detail_monthly_reports_on_report_date", using: :btree
  add_index "seed_prop_detail_monthly_reports", ["tag"], name: "index_seed_prop_detail_monthly_reports_on_tag", using: :btree

  create_table "seed_prop_detail_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",                   limit: 255
    t.string   "board",                 limit: 255
    t.string   "manufacturer",          limit: 255
    t.integer  "count",                 limit: 4
    t.float    "proportion_ratio",      limit: 24
    t.integer  "success_count",         limit: 4
    t.float    "success_ratio",         limit: 24
    t.float    "succ_proportion_ratio", limit: 24
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "seed_prop_detail_reports", ["board"], name: "index_seed_prop_detail_reports_on_board", using: :btree
  add_index "seed_prop_detail_reports", ["manufacturer"], name: "index_seed_prop_detail_reports_on_manufacturer", using: :btree
  add_index "seed_prop_detail_reports", ["report_date"], name: "index_seed_prop_detail_reports_on_report_date", using: :btree
  add_index "seed_prop_detail_reports", ["tag"], name: "index_seed_prop_detail_reports_on_tag", using: :btree

  create_table "seed_prop_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",                   limit: 255
    t.string   "manufacturer",          limit: 255
    t.integer  "count",                 limit: 4
    t.float    "proportion_ratio",      limit: 24
    t.integer  "success_count",         limit: 4
    t.float    "success_ratio",         limit: 24
    t.float    "succ_proportion_ratio", limit: 24
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "seed_prop_reports", ["manufacturer"], name: "index_seed_prop_reports_on_manufacturer", using: :btree
  add_index "seed_prop_reports", ["report_date"], name: "index_seed_prop_reports_on_report_date", using: :btree
  add_index "seed_prop_reports", ["tag"], name: "index_seed_prop_reports_on_tag", using: :btree

  create_table "seed_request_histories", id: false, force: :cascade do |t|
    t.integer  "id",          limit: 4
    t.string   "phtp",        limit: 255
    t.string   "osv",         limit: 255
    t.integer  "uid",         limit: 4
    t.string   "pkgn",        limit: 255
    t.string   "tag",         limit: 255
    t.integer  "sdkv",        limit: 4
    t.string   "sv",          limit: 255
    t.datetime "crtime"
    t.string   "rmd5",        limit: 255
    t.string   "bhmd5",       limit: 255
    t.string   "smd5",        limit: 255
    t.string   "reqid",       limit: 255
    t.string   "imei1",       limit: 255
    t.string   "imei2",       limit: 255
    t.string   "imsi1",       limit: 255
    t.string   "imsi2",       limit: 255
    t.datetime "record_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "appstate",    limit: 4
    t.boolean  "sysa"
    t.integer  "nsc",         limit: 4
    t.integer  "nfc",         limit: 4
    t.integer  "ern",         limit: 4
    t.string   "samd",        limit: 255
    t.string   "mac",         limit: 255
  end

  create_table "seed_solution_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",                   limit: 255
    t.integer  "plan_id",               limit: 4
    t.integer  "execting_count",        limit: 4
    t.integer  "exected_count",         limit: 4
    t.integer  "canceled_count",        limit: 4
    t.integer  "success_count",         limit: 4
    t.float    "success_ratio",         limit: 24
    t.float    "return_ratio",          limit: 24
    t.float    "succ_proportion_ratio", limit: 24
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "installed_count",       limit: 4
    t.float    "installed_ratio",       limit: 24
    t.integer  "v8_exists_count",       limit: 4
    t.float    "v8_exists_ratio",       limit: 24
    t.integer  "v9_exists_count",       limit: 4
    t.float    "v9_exists_ratio",       limit: 24
    t.integer  "active_count",          limit: 4
    t.integer  "new_installed_count",   limit: 4
    t.float    "new_installed_ratio",   limit: 24
  end

  add_index "seed_solution_reports", ["plan_id"], name: "index_seed_solution_reports_on_plan_id", using: :btree
  add_index "seed_solution_reports", ["report_date"], name: "index_seed_solution_reports_on_report_date", using: :btree
  add_index "seed_solution_reports", ["tag"], name: "index_seed_solution_reports_on_tag", using: :btree

  create_table "seed_users", id: false, force: :cascade do |t|
    t.integer  "id",              limit: 4
    t.integer  "uid",             limit: 4
    t.string   "tag",             limit: 255
    t.datetime "activation_time"
    t.boolean  "sysa"
    t.boolean  "is_root"
    t.boolean  "is_bash"
    t.string   "phtp",            limit: 255
    t.string   "pkgn",            limit: 255
    t.string   "sdkv",            limit: 255
    t.string   "sv",              limit: 255
    t.string   "osv",             limit: 255
    t.string   "imei1",           limit: 255
    t.string   "imei2",           limit: 255
    t.string   "imsi1",           limit: 255
    t.string   "imsi2",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remote_ips",      limit: 255
    t.boolean  "is_deliver_yy2"
    t.string   "mac",             limit: 255
    t.integer  "installed_type",  limit: 4
    t.integer  "ern",             limit: 4
    t.string   "activating_tag",  limit: 255
    t.boolean  "is_deliver_yy3"
  end

  create_table "sim_cards", id: false, force: :cascade do |t|
    t.integer  "id",         limit: 4
    t.string   "phone_num",  limit: 15
    t.string   "imsi",       limit: 15
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_tag_groups", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "regexp",       limit: 255
    t.boolean  "is_sum_group"
    t.string   "desc",         limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string   "current_imei",             limit: 15
    t.string   "current_imsi",             limit: 15
    t.integer  "current_uuid",             limit: 4
    t.integer  "id",                       limit: 4
    t.string   "current_phone_num",        limit: 15
    t.datetime "activation_time"
    t.string   "current_software_version", limit: 15
    t.string   "current_data_version",     limit: 15
    t.string   "current_loader_version",   limit: 15
    t.integer  "current_channel_id",       limit: 4
    t.string   "current_phone_model",      limit: 20
    t.boolean  "activate_status"
    t.string   "current_tag",              limit: 20
    t.string   "current_sc",               limit: 15
    t.integer  "current_sg",               limit: 2
    t.integer  "current_sv",               limit: 2
    t.datetime "update_time"
    t.string   "current_sub_tag",          limit: 255
    t.string   "current_imsi2",            limit: 15
    t.datetime "updated_at"
    t.datetime "create_time"
    t.string   "current_wifi_mac",         limit: 255
    t.string   "current_remote_ip",        limit: 255
    t.string   "activating_tag",           limit: 20
  end

  create_table "wlob_activation_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",            limit: 255
    t.integer  "activation_num", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "wlob_activation_reports", ["report_date"], name: "index_wlob_activation_reports_on_report_date", using: :btree
  add_index "wlob_activation_reports", ["tag"], name: "index_wlob_activation_reports_on_tag", using: :btree

  create_table "wlob_activity_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",              limit: 255
    t.integer  "activity_num",     limit: 4
    t.integer  "request_times",    limit: 4
    t.float    "request_per_avg",  limit: 24
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "activity_num1",    limit: 4
    t.integer  "request_times1",   limit: 4
    t.float    "request_per_avg1", limit: 24
    t.integer  "activity_num2",    limit: 4
    t.integer  "request_times2",   limit: 4
    t.float    "request_per_avg2", limit: 24
    t.integer  "activity_num3",    limit: 4
    t.integer  "request_times3",   limit: 4
    t.float    "request_per_avg3", limit: 24
    t.integer  "activity_num4",    limit: 4
    t.integer  "request_times4",   limit: 4
    t.float    "request_per_avg4", limit: 24
    t.integer  "activity_num5",    limit: 4
    t.integer  "request_times5",   limit: 4
    t.float    "request_per_avg5", limit: 24
  end

  add_index "wlob_activity_reports", ["report_date"], name: "index_wlob_activity_reports_on_report_date", using: :btree
  add_index "wlob_activity_reports", ["tag"], name: "index_wlob_activity_reports_on_tag", using: :btree

  create_table "wlob_alive_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",              limit: 255
    t.integer  "activation_num",   limit: 4
    t.integer  "stay_alive2_num",  limit: 4
    t.integer  "stay_alive3_num",  limit: 4
    t.integer  "stay_alive7_num",  limit: 4
    t.integer  "stay_alive15_num", limit: 4
    t.integer  "stay_alive30_num", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "wlob_alive_reports", ["report_date"], name: "index_wlob_alive_reports_on_report_date", using: :btree
  add_index "wlob_alive_reports", ["tag"], name: "index_wlob_alive_reports_on_tag", using: :btree

  create_table "wlob_arrival_reports", force: :cascade do |t|
    t.date     "report_date"
    t.string   "tag",           limit: 255
    t.integer  "arrival_total", limit: 4
    t.integer  "arrival_num1",  limit: 4
    t.integer  "arrival_num2",  limit: 4
    t.integer  "arrival_num3",  limit: 4
    t.integer  "arrival_num4",  limit: 4
    t.integer  "arrival_num5",  limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "wlob_arrival_reports", ["report_date"], name: "index_wlob_arrival_reports_on_report_date", using: :btree
  add_index "wlob_arrival_reports", ["tag"], name: "index_wlob_arrival_reports_on_tag", using: :btree

  add_foreign_key "accounts_roles", "accounts", name: "fk_accounts_roles_account_id"
  add_foreign_key "accounts_roles", "roles", name: "fk_accounts_roles_role_id"
end
