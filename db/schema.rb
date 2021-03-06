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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131116180630) do

  create_table "charities", :force => true do |t|
    t.string   "name",                :null => false
    t.integer  "ein",                 :null => false
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "ntee_code"
    t.string   "classification_code"
    t.string   "subsection_code"
    t.string   "activity_code"
    t.string   "description"
    t.string   "website"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "email"
    t.float    "balance"
    t.string   "active"
    t.float    "giv2giv_fees"
    t.float    "transaction_fees"
  end

  add_index "charities", ["ein"], :name => "index_charities_on_ein"

  create_table "charities_endowments", :id => false, :force => true do |t|
    t.integer "endowment_id", :null => false
    t.integer "charity_id",   :null => false
  end

  add_index "charities_endowments", ["charity_id"], :name => "index_charities_endowments_on_charity_id"
  add_index "charities_endowments", ["endowment_id", "charity_id"], :name => "endowments_charities_compound"
  add_index "charities_endowments", ["endowment_id"], :name => "index_charities_endowments_on_endowment_id"

  create_table "charities_tags", :id => false, :force => true do |t|
    t.integer "charity_id", :null => false
    t.integer "tag_id",     :null => false
  end

  add_index "charities_tags", ["charity_id", "tag_id"], :name => "index_charities_tags_on_charity_id_and_tag_id", :unique => true

  create_table "charity_grants", :force => true do |t|
    t.integer  "charity_id"
    t.integer  "endowment_id"
    t.integer  "donor_id"
    t.decimal  "shares_subtracted", :precision => 30, :scale => 20
    t.integer  "transaction_id"
    t.date     "date"
    t.float    "transaction_fee"
    t.float    "giv2giv_fee"
    t.float    "gross_amount"
    t.float    "grant_amount"
    t.string   "status"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  create_table "donations", :force => true do |t|
    t.float    "gross_amount",                                       :null => false
    t.integer  "endowment_id",                                       :null => false
    t.integer  "payment_account_id",                                 :null => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.decimal  "shares_added",       :precision => 30, :scale => 20
    t.integer  "donor_id"
    t.float    "transaction_fees"
    t.float    "net_amount"
  end

  add_index "donations", ["endowment_id"], :name => "index_donations_on_endowment_id"
  add_index "donations", ["payment_account_id"], :name => "index_donations_on_payment_account_id"

  create_table "donor_grants", :force => true do |t|
    t.integer  "charity_id"
    t.integer  "endowment_id"
    t.integer  "donor_id"
    t.string   "status"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.decimal  "shares_pending", :precision => 30, :scale => 20
    t.date     "date"
    t.integer  "transaction_id"
  end

  create_table "donor_subscriptions", :force => true do |t|
    t.integer  "donor_id"
    t.integer  "payment_account_id"
    t.integer  "endowment_id"
    t.string   "stripe_subscription_id"
    t.string   "type_subscription"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.float    "gross_amount"
  end

  create_table "donors", :force => true do |t|
    t.string   "name",                  :null => false
    t.string   "email",                 :null => false
    t.string   "password",              :null => false
    t.string   "facebook_id"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "phone_number"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "type_donor"
    t.string   "password_reset_token"
    t.datetime "expire_password_reset"
    t.string   "auth_token"
  end

  create_table "endowments", :force => true do |t|
    t.string   "name",                    :null => false
    t.string   "description"
    t.float    "minimum_donation_amount"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "donor_id"
    t.string   "endowment_visibility"
  end

  create_table "etrade_tokens", :force => true do |t|
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "etrades", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "date"
    t.float    "balance",    :null => false
    t.float    "fees"
  end

  create_table "giv_payments", :force => true do |t|
    t.float    "amount"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "from_etrade_to_dwolla_transaction_id"
    t.string   "from_dwolla_to_giv2giv_transaction_id"
    t.string   "status"
  end

  create_table "payment_accounts", :force => true do |t|
    t.string   "processor",                          :null => false
    t.integer  "donor_id",                           :null => false
    t.boolean  "requires_reauth", :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "stripe_cust_id"
  end

  add_index "payment_accounts", ["donor_id"], :name => "index_payment_accounts_on_donor_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.string   "token",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shares", :force => true do |t|
    t.float    "stripe_balance"
    t.decimal  "etrade_balance",              :precision => 30, :scale => 20
    t.decimal  "share_total_beginning",       :precision => 30, :scale => 20
    t.decimal  "shares_added_by_donation",    :precision => 30, :scale => 20
    t.decimal  "shares_subtracted_by_grants", :precision => 30, :scale => 20
    t.decimal  "share_total_end",             :precision => 30, :scale => 20
    t.float    "donation_price"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.float    "grant_price"
  end

  create_table "tags", :force => true do |t|
    t.string   "name",       :limit => 1024
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "tags", ["id"], :name => "index_tags_on_id"
  add_index "tags", ["name"], :name => "index_tags_on_name", :length => {"name"=>255}

end
