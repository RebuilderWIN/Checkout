class MigrationRollup < ActiveRecord::Migration
  def up
    create_table "brands", :force => true do |t|
      t.string   "name"
      t.string   "autocomplete", :null => false
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
    end

    add_index "brands", ["autocomplete"], :name => "index_brands_on_autocomplete"
    add_index "brands", ["name"], :name => "index_brands_on_name", :unique => true

    create_table "budgets", :force => true do |t|
      t.string   "number"
      t.string   "name"
      t.date     "starts_at"
      t.date     "ends_at"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "business_days", :force => true do |t|
      t.integer  "index",      :null => false
      t.string   "name",       :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "business_days_business_hours", :force => true do |t|
      t.integer "business_day_id"
      t.integer "business_hour_id"
    end

    create_table "business_hour_exceptions", :force => true do |t|
      t.integer  "location_id", :null => false
      t.date     "closed_at",   :null => false
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "business_hour_exceptions", ["location_id"], :name => "index_business_hour_exceptions_on_location_id"

    create_table "business_hours", :force => true do |t|
      t.integer  "location_id",  :null => false
      t.integer  "open_hour",    :null => false
      t.integer  "open_minute",  :null => false
      t.integer  "close_hour",   :null => false
      t.integer  "close_minute", :null => false
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
    end

    add_index "business_hours", ["location_id"], :name => "index_business_hours_on_location_id"

    create_table "categories", :force => true do |t|
      t.string   "name"
      t.string   "autocomplete", :null => false
      t.text     "description"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
    end

    add_index "categories", ["name"], :name => "index_categories_on_name"

    create_table "categories_component_models", :id => false, :force => true do |t|
      t.integer "category_id"
      t.integer "component_model_id"
    end

    add_index "categories_component_models", ["category_id", "component_model_id"], :name => "index_categories_models_on_category_id_and_model_id"

    create_table "component_models", :force => true do |t|
      t.integer  "brand_id",                             :null => false
      t.string   "name",                                 :null => false
      t.string   "autocomplete",                         :null => false
      t.text     "description"
      t.boolean  "training_required", :default => false
      t.datetime "created_at",                           :null => false
      t.datetime "updated_at",                           :null => false
    end

    add_index "component_models", ["autocomplete"], :name => "index_component_models_on_autocomplete"
    add_index "component_models", ["brand_id"], :name => "index_models_on_brand_id"
    add_index "component_models", ["name", "brand_id"], :name => "index_component_models_on_name_and_brand_id", :unique => true

    create_table "components", :force => true do |t|
      t.integer  "kit_id"
      t.integer  "component_model_id"
      t.string   "asset_tag"
      t.string   "serial_number"
      t.boolean  "missing",            :default => false
      t.integer  "position"
      t.datetime "created_at",                            :null => false
      t.datetime "updated_at",                            :null => false
    end

    add_index "components", ["asset_tag"], :name => "index_components_on_asset_tag", :unique => true
    add_index "components", ["kit_id"], :name => "index_parts_on_kit_id"
    add_index "components", ["missing"], :name => "index_components_on_missing"

    create_table "covenant_signatures", :force => true do |t|
      t.integer  "user_id"
      t.integer  "covenant_id"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    create_table "covenants", :force => true do |t|
      t.string   "name",        :null => false
      t.text     "description"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    create_table "groups", :force => true do |t|
      t.string   "name"
      t.text     "description"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    create_table "kits", :force => true do |t|
      t.integer  "location_id"
      t.integer  "budget_id"
      t.boolean  "tombstoned"
      t.boolean  "checkoutable", :default => false
      t.decimal  "cost"
      t.boolean  "insured",      :default => false
      t.datetime "created_at",                      :null => false
      t.datetime "updated_at",                      :null => false
    end

    add_index "kits", ["checkoutable"], :name => "index_kits_on_checkoutable"
    add_index "kits", ["location_id"], :name => "index_kits_on_location_id"

    create_table "locations", :force => true do |t|
      t.string   "name"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "memberships", :force => true do |t|
      t.integer  "group_id"
      t.integer  "user_id"
      t.date     "expires_at"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "memberships", ["group_id"], :name => "index_memberships_on_group_id"
    add_index "memberships", ["user_id", "group_id"], :name => "index_memberships_on_user_id_and_group_id", :unique => true
    add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

    create_table "permissions", :force => true do |t|
      t.integer  "group_id"
      t.integer  "kit_id"
      t.date     "expires_at"
      t.date     "exclusive_until"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
    end

    add_index "permissions", ["group_id"], :name => "index_permissions_on_group_id"
    add_index "permissions", ["kit_id", "group_id"], :name => "index_permissions_on_kit_id_and_group_id", :unique => true
    add_index "permissions", ["kit_id"], :name => "index_permissions_on_kit_id"

    create_table "reservations", :force => true do |t|
      t.integer  "client_id"
      t.integer  "kit_id"
      t.datetime "starts_at"
      t.datetime "ends_at"
      t.datetime "out_at"
      t.datetime "in_at"
      t.integer  "out_assistant_id"
      t.integer  "in_assistant_id"
      t.boolean  "late",             :default => false
      t.text     "request_note"
      t.integer  "approver_id"
      t.text     "approval_note"
      t.datetime "created_at",                          :null => false
      t.datetime "updated_at",                          :null => false
    end

    add_index "reservations", ["approver_id"], :name => "index_reservations_on_approver_id"
    add_index "reservations", ["client_id"], :name => "index_reservations_on_client_id"
    add_index "reservations", ["ends_at", "in_at", "late"], :name => "index_reservations_on_ends_at_and_in_at_and_late"
    add_index "reservations", ["ends_at"], :name => "index_reservations_on_ends_at"
    add_index "reservations", ["in_assistant_id"], :name => "index_reservations_on_in_assistant_id"
    add_index "reservations", ["kit_id"], :name => "index_reservations_on_kit_id"
    add_index "reservations", ["out_assistant_id"], :name => "index_reservations_on_out_assistant_id"
    add_index "reservations", ["starts_at", "out_at"], :name => "index_reservations_on_starts_at_and_out_at"

    create_table "roles", :force => true do |t|
      t.string   "name"
      t.integer  "resource_id"
      t.string   "resource_type"
      t.datetime "created_at",    :null => false
      t.datetime "updated_at",    :null => false
    end

    add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
    add_index "roles", ["name"], :name => "index_roles_on_name"

    create_table "users", :force => true do |t|
      t.string   "username",                                  :null => false
      t.string   "email",                                     :null => false
      t.string   "first_name"
      t.string   "last_name"
      t.string   "encrypted_password",                        :null => false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.integer  "failed_attempts",        :default => 0
      t.string   "unlock_token"
      t.datetime "locked_at"
      t.integer  "suspension_count",       :default => 0
      t.datetime "suspended_until"
      t.boolean  "disabled",               :default => false
      t.datetime "created_at",                                :null => false
      t.datetime "updated_at",                                :null => false
    end

    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
    add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
    add_index "users", ["username"], :name => "index_users_on_username", :unique => true

    create_table "users_roles", :id => false, :force => true do |t|
      t.integer "user_id"
      t.integer "role_id"
    end

    add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

    add_foreign_key "business_days_business_hours", "business_days", :name => "business_days_business_hours_business_day_id_fk"
    add_foreign_key "business_days_business_hours", "business_hours", :name => "business_days_business_hours_business_hour_id_fk"

    add_foreign_key "business_hour_exceptions", "locations", :name => "business_hour_exceptions_location_id_fk"

    add_foreign_key "business_hours", "locations", :name => "business_hours_location_id_fk"

    add_foreign_key "categories_component_models", "categories", :name => "categories_models_category_id_fk"
    add_foreign_key "categories_component_models", "component_models", :name => "categories_models_model_id_fk"

    add_foreign_key "component_models", "brands", :name => "models_brand_id_fk"

    add_foreign_key "components", "component_models", :name => "components_model_id_fk"
    add_foreign_key "components", "kits", :name => "components_kit_id_fk"

    add_foreign_key "covenant_signatures", "covenants", :name => "covenant_signatures_covenant_id_fk"
    add_foreign_key "covenant_signatures", "users", :name => "covenant_signatures_user_id_fk"

    add_foreign_key "kits", "budgets", :name => "kits_budget_id_fk"
    add_foreign_key "kits", "locations", :name => "kits_location_id_fk"

    add_foreign_key "memberships", "groups", :name => "groups_users_group_id_fk"
    add_foreign_key "memberships", "users", :name => "groups_users_user_id_fk"

    add_foreign_key "permissions", "groups", :name => "permissions_group_id_fk"
    add_foreign_key "permissions", "kits", :name => "permissions_kit_id_fk"

    add_foreign_key "reservations", "kits", :name => "reservations_kit_id_fk"
    add_foreign_key "reservations", "users", :name => "reservations_approver_id_fk", :column => "approver_id"
    add_foreign_key "reservations", "users", :name => "reservations_client_id_fk", :column => "client_id"
    add_foreign_key "reservations", "users", :name => "reservations_in_assistant_id_fk", :column => "in_assistant_id"
    add_foreign_key "reservations", "users", :name => "reservations_out_assistant_id_fk", :column => "out_assistant_id"

    add_foreign_key "users_roles", "roles", :name => "users_roles_role_id_fk"
    add_foreign_key "users_roles", "users", :name => "users_roles_user_id_fk"

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
