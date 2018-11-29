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

ActiveRecord::Schema.define(version: 20180728082747) do

  create_table "browses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "call_board_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "call_boards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "content",                limit: 16777215
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.json     "call_board_attachments"
    t.integer  "user_id"
  end

  create_table "faqs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "title"
    t.text     "content",        limit: 65535
    t.json     "faq_attachment"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "station_equipment_maintains", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "station_name"
    t.string   "t_type"
    t.datetime "begin_time"
    t.datetime "end_time",                                default: '2030-01-01 00:00:00'
    t.text     "maintain_reason",           limit: 65535
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.string   "equipment_come_from"
    t.string   "equipment_used_time_lenth"
  end

  create_table "t_baogao_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "duan_name"
    t.integer  "online_station"
    t.integer  "cankao_station"
    t.integer  "student_yingkao"
    t.integer  "student_shikao"
    t.string   "student_dabiao_percent"
    t.integer  "student_diaoli"
    t.integer  "student_tuixiu"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "kuaizhao_create_time"
  end

  create_table "t_baogao_inputs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "content",           limit: 65535
    t.json     "baogao_attachment"
    t.datetime "baogao_time"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "t_baogao_programs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "program_one"
    t.string   "program_two"
    t.string   "program_three"
    t.string   "program_four"
    t.string   "program_five"
    t.string   "program_six"
    t.string   "program_seven"
    t.string   "program_eight"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["name"], name: "index_t_baogao_programs_on_name", unique: true, using: :btree
  end

  create_table "t_chejian_counts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "duan_name"
    t.integer  "station_count"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["duan_name"], name: "index_t_chejian_counts_on_duan_name", unique: true, using: :btree
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
    t.index ["F_name"], name: "index_t_duan_info_on_F_name", using: :btree
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
    t.string   "F_user_uuid",     limit: 64,                                      null: false
    t.string   "F_duan_uuid",     limit: 64,                                      null: false
    t.string   "F_station_uuid",  limit: 64,                                      null: false
    t.string   "F_team_uuid",     limit: 64,                                      null: false
    t.string   "F_work_uuid",     limit: 64,                                      null: false
    t.string   "F_time",          limit: 64,                                      null: false
    t.string   "F_teacher_uuid",  limit: 64,                                      null: false
    t.integer  "F_synch",                    default: 0,                          null: false
    t.string   "F_question_uuid", limit: 64
    t.string   "F_record",                                                        null: false
    t.integer  "F_double_screen",            default: 0,                          null: false
    t.integer  "F_score",                    default: 0,                          null: false
    t.integer  "F_synch_record",             default: 0,                          null: false, comment: "`"
    t.datetime "created_at",                 default: -> { "CURRENT_TIMESTAMP" }
    t.integer  "time_length"
    t.index ["F_duan_uuid", "F_time"], name: "F_duan_uuid_2", using: :btree
    t.index ["F_duan_uuid"], name: "F_duan_uuid", using: :btree
    t.index ["F_duan_uuid"], name: "index_t_record_info_on_F_duan_uuid", using: :btree
    t.index ["F_score"], name: "index_t_record_info_on_F_score", using: :btree
    t.index ["F_station_uuid", "F_time"], name: "F_station_uuid_2", using: :btree
    t.index ["F_station_uuid"], name: "F_station_uuid", using: :btree
    t.index ["F_station_uuid"], name: "index_t_record_info_on_F_station_uuid", using: :btree
    t.index ["F_team_uuid", "F_time"], name: "F_team_uuid_2", using: :btree
    t.index ["F_team_uuid"], name: "F_team_uuid", using: :btree
    t.index ["F_team_uuid"], name: "index_t_record_info_on_F_team_uuid", using: :btree
    t.index ["F_user_uuid", "F_duan_uuid", "F_station_uuid", "F_team_uuid"], name: "F_user_uuid_3", using: :btree
    t.index ["F_user_uuid", "F_time"], name: "F_user_uuid_2", using: :btree
    t.index ["F_user_uuid"], name: "F_user_uuid", using: :btree
    t.index ["F_user_uuid"], name: "index_t_record_info_on_F_user_uuid", using: :btree
    t.index ["F_work_uuid"], name: "index_t_record_info_on_F_work_uuid", using: :btree
  end

  create_table "t_station_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_name",      limit: 64,                null: false
    t.string  "F_duan_uuid", limit: 64,                null: false
    t.integer "F_level",                default: 0,    null: false
    t.bigint  "LEVEL"
    t.string  "status",                 default: "在线"
    t.json    "image"
    t.json    "attachment"
    t.json    "attachment2"
    t.index ["F_duan_uuid"], name: "index_t_station_info_on_F_duan_uuid", using: :btree
  end

  create_table "t_team_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "F_name",         limit: 64, null: false
    t.string "F_station_uuid", limit: 64, null: false
    t.index ["F_station_uuid"], name: "index_t_team_info_on_F_station_uuid", using: :btree
  end

  create_table "t_test", primary_key: "F_uuid", id: :string, limit: 64, collation: "latin1_swedish_ci", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
  end

  create_table "t_user_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "F_id",           limit: 64,                                      null: false
    t.string   "F_name",         limit: 16,                                      null: false
    t.string   "F_code",         limit: 32,                                      null: false
    t.string   "F_password",     limit: 32,                                      null: false
    t.integer  "F_type",                    default: 0,                          null: false
    t.integer  "F_state",                   default: 0,                          null: false
    t.string   "F_duan_uuid",    limit: 64,                                      null: false
    t.string   "F_station_uuid", limit: 64,                                      null: false
    t.string   "F_team_uuid",    limit: 64,                                      null: false
    t.string   "F_work_uuid",    limit: 64,                                      null: false
    t.integer  "F_synch",                   default: 0,                          null: false
    t.string   "status",                    default: "在职"
    t.datetime "created_at",                default: -> { "CURRENT_TIMESTAMP" }
    t.index ["F_code"], name: "F_code", using: :btree
    t.index ["F_duan_uuid"], name: "index_1", using: :btree
    t.index ["F_name"], name: "F_name", using: :btree
    t.index ["F_station_uuid"], name: "F_station_uuid", using: :btree
    t.index ["F_team_uuid"], name: "F_team_uuid", using: :btree
    t.index ["F_team_uuid"], name: "index_t_user_info_on_F_team_uuid", using: :btree
    t.index ["F_type"], name: "index_t_user_info_on_F_type", using: :btree
    t.index ["F_uuid"], name: "F_uuid", using: :btree
    t.index ["F_work_uuid"], name: "F_work_uuid", using: :btree
  end

  create_table "t_vacation_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "F_id"
    t.datetime "begin_time"
    t.datetime "end_time"
    t.string   "F_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "station_name"
  end

  create_table "t_work_info", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "F_name", limit: 64, null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "role"
    t.string   "orgnize"
    t.integer  "permission"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["role"], name: "index_users_on_role", unique: true, using: :btree
  end

  create_table "xcf_detail_reason_infos", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "F_record_detail_uuid"
    t.datetime "F_time"
    t.integer  "F_reason_id"
    t.integer  "F_score"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "xcf_program_infos", primary_key: "F_id", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "F_name",    limit: 256,             null: false
    t.integer "F_type_id",             default: 0, null: false
  end

  create_table "xcf_program_type_infos", primary_key: "F_id", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "F_name", limit: 64, null: false, collation: "utf8_general_ci"
  end

  create_table "xcf_reason_infos", primary_key: "F_id", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "F_reason_type_id",             null: false
    t.string  "F_name",           limit: 256, null: false, collation: "utf8_general_ci"
    t.integer "F_value",                      null: false
  end

  create_table "xcf_reason_type_infos", primary_key: "F_id", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "F_name", limit: 64, null: false, collation: "utf8_general_ci"
  end

  create_table "xcf_record_detail_infos", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "F_record_uuid"
    t.integer  "F_program_id"
    t.integer  "F_score"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "xcf_record_infos", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "F_user_uuid"
    t.string   "F_location"
    t.integer  "F_score"
    t.datetime "F_begin_time"
    t.integer  "time_length"
    t.string   "F_teacher_uuid"
    t.string   "F_question_name"
    t.string   "F_record"
    t.string   "F_pre_work_uuid"
    t.string   "F_bs_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["F_score"], name: "index_xcf_record_infos_on_F_score", using: :btree
    t.index ["F_user_uuid"], name: "index_xcf_record_infos_on_F_user_uuid", using: :btree
  end

  create_table "xcf_user_infos", primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "F_name"
    t.string   "F_id"
    t.integer  "F_type"
    t.string   "F_duan_uuid"
    t.string   "F_station_uuid"
    t.string   "F_team_uuid"
    t.string   "F_work_uuid"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["F_duan_uuid"], name: "index_xcf_user_infos_on_F_duan_uuid", using: :btree
    t.index ["F_id"], name: "index_xcf_user_infos_on_F_id", using: :btree
    t.index ["F_station_uuid"], name: "index_xcf_user_infos_on_F_station_uuid", using: :btree
    t.index ["F_uuid"], name: "index_xcf_user_infos_on_F_uuid", using: :btree
  end

end
