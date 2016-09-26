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

ActiveRecord::Schema.define(version: 20160926003745) do

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
    t.index ["course_id"], name: "index_educators_on_course_id", using: :btree
    t.index ["university_id"], name: "index_educators_on_university_id", using: :btree
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

  create_table "students", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "school_class_id"
    t.string   "name"
    t.string   "registration"
    t.string   "email"
    t.integer  "university_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["school_class_id"], name: "index_students_on_school_class_id", using: :btree
    t.index ["university_id"], name: "index_students_on_university_id", using: :btree
  end

  create_table "universities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "classrooms", "disciplines"
  add_foreign_key "classrooms", "educators"
  add_foreign_key "courses", "universities"
  add_foreign_key "disciplines", "courses"
  add_foreign_key "disciplines", "universities"
  add_foreign_key "educators", "courses"
  add_foreign_key "educators", "universities"
  add_foreign_key "school_classes", "courses"
  add_foreign_key "students", "school_classes"
  add_foreign_key "students", "universities"
end
