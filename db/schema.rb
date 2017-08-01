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

ActiveRecord::Schema.define(version: 0) do

  create_table "attachment", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", comment: "系统附件表" do |t|
    t.string   "file_name",          limit: 50,                                       null: false, comment: "文件名称"
    t.string   "original_file_name", limit: 100,                                      null: false, comment: "文件原始名称"
    t.string   "file_type",          limit: 50,                                       null: false, comment: "文件类型"
    t.string   "file_path",          limit: 100,                                      null: false, comment: "文件保存的相对路径"
    t.integer  "file_size",                                                           null: false, comment: "文件大小"
    t.string   "profile",            limit: 100,                                                   comment: "文件摘要"
    t.bigint   "create_userid",                                                       null: false, comment: "创建纪录用户id"
    t.datetime "create_time",                    default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "文件"
    t.bigint   "update_userid",                                                                    comment: "修改记录用户id"
    t.datetime "update_time",                                                         null: false, comment: "记录最后修改时间"
    t.index ["file_name"], name: "INX_ATTACHMENT_FILE_NAME", unique: true, using: :btree
  end

  create_table "monitor_receiver_log", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", comment: "访问服务监控日志表" do |t|
    t.string   "inner_serial_id", limit: 30,                                        null: false, comment: "内部流水号，由调用服务的时间生成"
    t.string   "service_name",    limit: 5000,                                      null: false, comment: "调用服务的名称"
    t.bigint   "user_id",                                                           null: false, comment: "访问用户ID"
    t.string   "user_name",       limit: 30,                                        null: false, comment: "访问用户的登录名"
    t.bigint   "org_id",                                                            null: false, comment: "用户所属机构ID"
    t.string   "role_ids",        limit: 50,                                        null: false, comment: "用户角色ID集合"
    t.string   "result_code",     limit: 30,                                        null: false, comment: "访问的结果编码"
    t.string   "result_msg",      limit: 500,                                       null: false, comment: "访问的结果信息"
    t.integer  "time_cost",                                                         null: false, comment: "调用耗时，单位毫秒"
    t.string   "full_url",        limit: 100,                                       null: false, comment: "访问服务的全路径"
    t.string   "remote_ip",       limit: 30,                                        null: false, comment: "访问者ip地址"
    t.string   "server_ip",       limit: 30,                                        null: false, comment: "服务器ip地址"
    t.datetime "create_time",                  default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "记录创建时间"
    t.datetime "invoke_time",                                                       null: false, comment: "访问服务开始时间"
    t.datetime "response_time",                                                     null: false, comment: "请求响应时间"
    t.index ["inner_serial_id"], name: "IDX_RLOG_SERIAL_ID", using: :btree
    t.index ["invoke_time"], name: "IDX_RLOG_INVOKE_TIME", using: :btree
    t.index ["user_id"], name: "IDX_RLOG_USER_ID", using: :btree
    t.index ["user_name"], name: "IDX_RLOG_USER_NAME", using: :btree
  end

  create_table "monitor_sql_log", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", comment: "SQL监测日志表" do |t|
    t.string   "inner_serial_id",  limit: 30,                                        null: false, comment: "内部流水号，由调用服务的时间生成"
    t.string   "sql_command_type", limit: 50,                                        null: false, comment: "SQL操作类型"
    t.string   "sql_str",          limit: 1000,                                      null: false, comment: "SQL操作语句"
    t.string   "parameters",       limit: 1000,                                                   comment: "SQL参数"
    t.string   "mybatis_sql_id",   limit: 100,                                       null: false, comment: "SQL来源类方法"
    t.string   "file_resource",    limit: 100,                                       null: false, comment: "SQL来源文件"
    t.string   "data_source",      limit: 100,                                       null: false, comment: "数据库信息"
    t.integer  "time_cost",                                                          null: false, comment: "执行SQL耗时，单位毫秒"
    t.datetime "create_time",                   default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "记录创建时间"
    t.datetime "sql_start_time",                                                     null: false, comment: "SQL开始时间"
    t.datetime "sql_end_time",                                                       null: false, comment: "SQL结束时间"
    t.index ["inner_serial_id"], name: "IDX_SLOG_SERIAL_ID", using: :btree
    t.index ["mybatis_sql_id"], name: "IDX_SLOG_SQL_ID", using: :btree
    t.index ["sql_start_time"], name: "IDX_SLOG_SQL_START_TIME", using: :btree
  end

  create_table "sys_organization", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", comment: "机构表" do |t|
    t.bigint   "pId"
    t.string   "org_name",      limit: 30,                                      comment: "机构名称"
    t.string   "org_num"
    t.integer  "type",          limit: 1,  default: 1,                          comment: "机构类型：0, 总部； 1 区域；2, 第三方；3, 其他；默认值1"
    t.integer  "editable",      limit: 1,  default: 1,                          comment: "是否可编辑，系统初始化的机构不可修改、删除：0 不可编辑；1 可编辑，默认值为1"
    t.datetime "create_time",              default: -> { "CURRENT_TIMESTAMP" }, comment: "记录创建时间"
    t.bigint   "create_userid",                                                 comment: "记录创建userid"
    t.datetime "update_time",                                                   comment: "记录最后修改时间"
    t.bigint   "update_userid",                                                 comment: "记录修改userid"
    t.string   "note",                                                          comment: "备注"
    t.string   "create_org"
    t.string   "create_dept"
    t.string   "sort"
    t.string   "ORG_DUTR"
    t.string   "ORG_ZONECODE"
    t.string   "ORG_LEVEL"
    t.string   "sourcestate"
    t.string   "sourcecounty"
    t.string   "sourcecity"
    t.index ["org_name"], name: "IDX_ORG_NAME", using: :btree
  end

  create_table "sys_resource_module", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", comment: "系统资源模块表" do |t|
    t.string   "module_name",   limit: 30,                                      null: false, comment: "资源模块名称"
    t.integer  "sort_num",      limit: 1,  default: 0,                          null: false, comment: "显示序号"
    t.bigint   "pid",                      default: 0,                          null: false, comment: "当前资源所属父资源模块id，默认值为0：无父模块"
    t.datetime "create_time",              default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "记录创建时间"
    t.bigint   "create_userid",                                                 null: false, comment: "记录创建userid"
    t.datetime "update_time",                                                   null: false, comment: "记录最后修改时间"
    t.bigint   "update_userid",                                                              comment: "记录修改userid"
    t.string   "note",                                                                       comment: "备注"
    t.string   "ename",         limit: 30,                                                   comment: "英文名称"
    t.string   "module_style"
    t.string   "module_url"
    t.index ["module_name"], name: "IDX_MODULE_NAME", unique: true, using: :btree
  end

  create_table "sys_resources", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", comment: "系统资源表" do |t|
    t.string   "resource_name", limit: 30,                                      null: false, comment: "资源名称"
    t.string   "resource_url",  limit: 50,                                      null: false, comment: "访问资源的路径"
    t.bigint   "module_id",                                                                  comment: "资源所属模块id，与系统资源模块表存在主外键关系"
    t.integer  "sort_num",      limit: 1,                                                    comment: "展示顺序"
    t.integer  "is_restricted", limit: 1,  default: 1,                          null: false, comment: "用户访问是否需判断用户所属角色拥有访问此资源的权限 0 不需要，1需要。  默认：1需要"
    t.integer  "is_menu",       limit: 1,  default: 1,                          null: false, comment: "该资源是否是页面左侧的菜单项. 0 不是，1 是。默认：1是"
    t.datetime "create_time",              default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "记录创建时间"
    t.bigint   "create_userid",                                                              comment: "记录创建userid"
    t.datetime "update_time",                                                   null: false, comment: "记录最后修改时间"
    t.bigint   "update_userid",                                                              comment: "记录修改userid"
    t.string   "note",                                                                       comment: "备注"
    t.string   "ename",         limit: 30,                                                   comment: "英文名称"
    t.bigint   "pId"
    t.string   "icon",          limit: 40
    t.index ["module_id", "sort_num"], name: "IDX_RESOURCES_MODULE_SORT_NUM", unique: true, using: :btree
  end

  create_table "sys_resources_sub", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", comment: "系统资源子表" do |t|
    t.string   "sub_resource_name", limit: 30,                                      null: false, comment: "子资源名称"
    t.string   "sub_resource_url",  limit: 50,                                      null: false, comment: "访问子资源的路径"
    t.bigint   "resource_id",                                                       null: false, comment: "子资源所属资源id，与系统资源表存在主外键关系"
    t.datetime "create_time",                  default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "记录创建时间"
    t.bigint   "create_userid",                                                     null: false, comment: "记录创建userid"
    t.datetime "update_time",                                                       null: false, comment: "记录最后修改时间"
    t.bigint   "update_userid",                                                                  comment: "记录修改userid"
    t.string   "note",                                                                           comment: "备注"
    t.index ["resource_id"], name: "resource_id", using: :btree
  end

  create_table "sys_role_resource", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", comment: "系统角色资源关联表" do |t|
    t.bigint   "role_id",                                            null: false, comment: "角色id"
    t.bigint   "resource_id",                                        null: false, comment: "资源id"
    t.datetime "create_time",   default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "记录创建时间"
    t.bigint   "create_userid",                                      null: false, comment: "记录创建userid"
    t.datetime "update_time",                                        null: false, comment: "记录最后修改时间"
    t.bigint   "update_userid",                                                   comment: "记录修改userid"
    t.string   "note",                                                            comment: "备注"
    t.index ["resource_id"], name: "FK_REFERENCE_ROLERESOURCE_RESOURCE", using: :btree
    t.index ["role_id", "resource_id"], name: "IDX_ROLE_RESOURCE", unique: true, using: :btree
  end

  create_table "sys_roles", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", comment: "系统角色表" do |t|
    t.string   "role_name",     limit: 30,                                      null: false, comment: "角色名称"
    t.integer  "editable",      limit: 1,  default: 1,                          null: false, comment: "是否可编辑，系统初始化的角色不可修改、删除：0 不可编辑；1 可编辑，默认值为1"
    t.datetime "create_time",              default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "记录创建时间"
    t.bigint   "create_userid",                                                 null: false, comment: "记录创建userid"
    t.datetime "update_time",                                                   null: false, comment: "记录最后修改时间"
    t.bigint   "update_userid",                                                              comment: "记录修改userid"
    t.string   "note",                                                                       comment: "备注"
    t.index ["role_name"], name: "IDX_ROLE_NAME", unique: true, using: :btree
  end

  create_table "sys_user_role", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", comment: "用户角色关联表" do |t|
    t.bigint   "user_id",                                            null: false, comment: "用户id，与用户表存在主外键关系"
    t.bigint   "role_id",                                            null: false, comment: "角色id，与角色表存在主外键关系"
    t.datetime "create_time",   default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "记录创建时间"
    t.bigint   "create_userid",                                      null: false, comment: "记录创建userid"
    t.datetime "update_time",                                        null: false, comment: "记录最后修改时间"
    t.bigint   "update_userid",                                                   comment: "记录修改userid"
    t.string   "note",                                                            comment: "备注"
    t.index ["role_id"], name: "FK_REFERENCE_USERROLE_ROLE", using: :btree
    t.index ["user_id", "role_id"], name: "IDX_USER_ROLE", unique: true, using: :btree
  end

  create_table "sys_users", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", comment: "系统用户表" do |t|
    t.string   "user_name",     limit: 50,                                       comment: "用户登录名称"
    t.string   "password",      limit: 50,                                       comment: "用户登录密码"
    t.string   "user_email",    limit: 50,                                       comment: "用户电子邮箱地址"
    t.string   "true_name",     limit: 30,                                       comment: "用户真实名称"
    t.bigint   "org_id",                                                         comment: "用户所属机构，与机构表存在主外键关系"
    t.bigint   "dept_id"
    t.string   "user_title",    limit: 50,                                       comment: "用户职称"
    t.string   "user_mobile",   limit: 30,                                       comment: "用户手机号码"
    t.string   "user_phone",    limit: 30,                                       comment: "用户座机号码"
    t.integer  "is_lock",       limit: 1,   default: 0,                          comment: "是否锁定，被锁定的用户将不能登录到系统中：0 正常； 1被锁定，默认值为0"
    t.integer  "editable",      limit: 1,   default: 1,                          comment: "是否可编辑，系统初始化的用户不可修改、删除：0 不可编辑；1 可编辑，默认值为1"
    t.datetime "create_time",               default: -> { "CURRENT_TIMESTAMP" }, comment: "记录创建时间"
    t.bigint   "create_userid",                                                  comment: "记录创建userid"
    t.datetime "update_time",                                                    comment: "记录最后修改时间"
    t.bigint   "update_userid",                                                  comment: "记录修改userid"
    t.string   "note",                                                           comment: "备注"
    t.string   "msn"
    t.integer  "nsms",                                                           comment: "手机短信"
    t.integer  "nmsn",                                                           comment: "MSN Messenger"
    t.integer  "nemail",                                                         comment: "接收通知"
    t.bigint   "type"
    t.string   "duanuuid",      limit: 200
    t.string   "user_code",     limit: 30
  end

  create_table "t_detail_reason_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_record_detail_uuid", limit: 64, null: false
    t.string  "F_time",               limit: 64, null: false
    t.integer "F_reason_id",                     null: false
    t.integer "F_score",                         null: false
  end

  create_table "t_duan_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_name", limit: 64,             null: false
    t.integer "F_type",            default: 1, null: false, comment: "类型 1 车务段 2 直属站"
    t.bigint  "LEVEL"
  end

  create_table "t_program_info", primary_key: "F_id", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_name",    limit: 256,             null: false
    t.integer "F_type_id",             default: 0, null: false
  end

  create_table "t_program_info_ignore", primary_key: "F_id", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_name",         limit: 256,             null: false
    t.integer "F_synch",                    default: 0, null: false
    t.string  "F_station_uuid", limit: 64,              null: false
  end

  create_table "t_program_type_info", primary_key: "F_id", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "F_name", limit: 64, null: false, collation: "utf8_general_ci"
  end

  create_table "t_question_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_name",         limit: 64,               null: false
    t.string  "F_desc",         limit: 1024
    t.string  "F_programs",     limit: 256,              null: false
    t.integer "F_synch",                     default: 0, null: false
    t.string  "F_station_uuid", limit: 64,               null: false
  end

  create_table "t_reason_info", primary_key: "F_id", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "F_reason_type_id",             null: false
    t.string  "F_name",           limit: 256, null: false, collation: "utf8_general_ci"
    t.integer "F_value",                      null: false
  end

  create_table "t_reason_type_info", primary_key: "F_id", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "F_name", limit: 64, null: false, collation: "utf8_general_ci"
  end

  create_table "t_record_detail_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_record_uuid", limit: 64,               null: false
    t.integer "F_program_id",               default: 0, null: false
    t.integer "F_score",                    default: 0, null: false
    t.string  "F_mark",        limit: 2048,             null: false
    t.integer "F_synch",                    default: 0, null: false
    t.integer "F_max",                      default: 0, null: false
  end

  create_table "t_record_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_user_uuid",     limit: 64,             null: false
    t.string  "F_duan_uuid",     limit: 64,             null: false
    t.string  "F_station_uuid",  limit: 64,             null: false
    t.string  "F_team_uuid",     limit: 64,             null: false
    t.string  "F_work_uuid",     limit: 64,             null: false
    t.string  "F_time",          limit: 64,             null: false
    t.string  "F_teacher_uuid",  limit: 64,             null: false
    t.integer "F_synch",                    default: 0, null: false
    t.string  "F_question_uuid", limit: 64
    t.string  "F_record",                               null: false
    t.integer "F_double_screen",            default: 0, null: false
    t.integer "F_score",                    default: 0, null: false
    t.integer "F_synch_record",             default: 0, null: false, comment: "`"
    t.index ["F_duan_uuid", "F_time"], name: "F_duan_uuid_2", using: :btree
    t.index ["F_duan_uuid"], name: "F_duan_uuid", using: :btree
    t.index ["F_station_uuid", "F_time"], name: "F_station_uuid_2", using: :btree
    t.index ["F_station_uuid"], name: "F_station_uuid", using: :btree
    t.index ["F_team_uuid", "F_time"], name: "F_team_uuid_2", using: :btree
    t.index ["F_team_uuid"], name: "F_team_uuid", using: :btree
    t.index ["F_user_uuid", "F_duan_uuid", "F_station_uuid", "F_team_uuid"], name: "F_user_uuid_3", using: :btree
    t.index ["F_user_uuid", "F_time"], name: "F_user_uuid_2", using: :btree
    t.index ["F_user_uuid"], name: "F_user_uuid", using: :btree
  end

  create_table "t_station_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_name",      limit: 64,             null: false
    t.string  "F_duan_uuid", limit: 64,             null: false
    t.integer "F_level",                default: 0, null: false
    t.bigint  "LEVEL"
  end

  create_table "t_team_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "F_name",         limit: 64, null: false
    t.string "F_station_uuid", limit: 64, null: false
  end

  create_table "t_test", primary_key: "F_uuid", id: :string, limit: 64, collation: "latin1_swedish_ci", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
  end

  create_table "t_user_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_id",           limit: 64,             null: false
    t.string  "F_name",         limit: 16,             null: false
    t.string  "F_code",         limit: 32,             null: false
    t.string  "F_password",     limit: 32,             null: false
    t.integer "F_type",                    default: 0, null: false
    t.integer "F_state",                   default: 0, null: false
    t.string  "F_duan_uuid",    limit: 64,             null: false
    t.string  "F_station_uuid", limit: 64,             null: false
    t.string  "F_team_uuid",    limit: 64,             null: false
    t.string  "F_work_uuid",    limit: 64,             null: false
    t.integer "F_synch",                   default: 0, null: false
    t.index ["F_code"], name: "F_code", using: :btree
    t.index ["F_duan_uuid"], name: "index_1", using: :btree
    t.index ["F_name"], name: "F_name", using: :btree
    t.index ["F_station_uuid"], name: "F_station_uuid", using: :btree
    t.index ["F_team_uuid"], name: "F_team_uuid", using: :btree
    t.index ["F_uuid"], name: "F_uuid", using: :btree
    t.index ["F_work_uuid"], name: "F_work_uuid", using: :btree
  end

  create_table "t_user_info_copy", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_id",           limit: 64,             null: false
    t.string  "F_name",         limit: 16,             null: false
    t.string  "F_code",         limit: 32,             null: false
    t.string  "F_password",     limit: 32,             null: false
    t.integer "F_type",                    default: 0, null: false
    t.integer "F_state",                   default: 0, null: false
    t.string  "F_duan_uuid",    limit: 64,             null: false
    t.string  "F_station_uuid", limit: 64,             null: false
    t.string  "F_team_uuid",    limit: 64,             null: false
    t.string  "F_work_uuid",    limit: 64,             null: false
    t.integer "F_synch",                   default: 0, null: false
  end

  create_table "t_user_info_copy_copy", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_id",           limit: 64,             null: false
    t.string  "F_name",         limit: 16,             null: false
    t.string  "F_code",         limit: 32,             null: false
    t.string  "F_password",     limit: 32,             null: false
    t.integer "F_type",                    default: 0, null: false
    t.integer "F_state",                   default: 0, null: false
    t.string  "F_duan_uuid",    limit: 64,             null: false
    t.string  "F_station_uuid", limit: 64,             null: false
    t.string  "F_team_uuid",    limit: 64,             null: false
    t.string  "F_work_uuid",    limit: 64,             null: false
    t.integer "F_synch",                   default: 0, null: false
  end

  create_table "t_work_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "F_name", limit: 64, null: false
  end

  add_foreign_key "sys_resources_sub", "sys_resources", column: "resource_id", name: "sys_resources_sub_ibfk_1", on_delete: :cascade
  add_foreign_key "sys_role_resource", "sys_resources", column: "resource_id", name: "sys_role_resource_ibfk_2", on_delete: :cascade
  add_foreign_key "sys_role_resource", "sys_roles", column: "role_id", name: "sys_role_resource_ibfk_1", on_delete: :cascade
  add_foreign_key "sys_user_role", "sys_roles", column: "role_id", name: "sys_user_role_ibfk_1", on_delete: :cascade
end
