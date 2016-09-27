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

ActiveRecord::Schema.define(version: 20160927023335) do

  create_table "classrooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "discipline_id"
    t.integer  "educator_id"
    t.integer  "period"
    t.integer  "vacancies"
    t.string   "year"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["discipline_id"], name: "index_classrooms_on_discipline_id", using: :btree
    t.index ["educator_id"], name: "index_classrooms_on_educator_id", using: :btree
  end

  create_table "courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "university_id"
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["university_id"], name: "index_courses_on_university_id", using: :btree
  end

  create_table "disciplines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "university_id"
    t.integer  "course_id"
    t.string   "name"
    t.text     "description",   limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["course_id"], name: "index_disciplines_on_course_id", using: :btree
    t.index ["university_id"], name: "index_disciplines_on_university_id", using: :btree
  end

  create_table "educators", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "university_id"
    t.string   "name"
    t.string   "registration"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "course_id"
    t.integer  "user_id"
    t.index ["course_id"], name: "index_educators_on_course_id", using: :btree
    t.index ["university_id"], name: "index_educators_on_university_id", using: :btree
    t.index ["user_id"], name: "index_educators_on_user_id", using: :btree
  end

  create_table "school_classes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "course_id"
    t.string   "name"
    t.string   "year"
    t.integer  "period"
    t.integer  "vacancies"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_school_classes_on_course_id", using: :btree
  end

  create_table "scientific_researches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "educator_id"
    t.integer  "university_id"
    t.string   "name"
    t.text     "description",   limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["educator_id"], name: "index_scientific_researches_on_educator_id", using: :btree
    t.index ["university_id"], name: "index_scientific_researches_on_university_id", using: :btree
  end

  create_table "students", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "school_class_id"
    t.string   "name"
    t.string   "registration"
    t.string   "email"
    t.integer  "university_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.index ["school_class_id"], name: "index_students_on_school_class_id", using: :btree
    t.index ["university_id"], name: "index_students_on_university_id", using: :btree
    t.index ["user_id"], name: "index_students_on_user_id", using: :btree
  end

  create_table "universities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "classrooms", "disciplines"
  add_foreign_key "classrooms", "educators"
  add_foreign_key "courses", "universities"
  add_foreign_key "disciplines", "courses"
  add_foreign_key "disciplines", "universities"
  add_foreign_key "educators", "courses"
  add_foreign_key "educators", "universities"
  add_foreign_key "educators", "users"
  add_foreign_key "school_classes", "courses"
  add_foreign_key "scientific_researches", "educators"
  add_foreign_key "scientific_researches", "universities"
  add_foreign_key "students", "school_classes"
  add_foreign_key "students", "universities"
  add_foreign_key "students", "users"
end
