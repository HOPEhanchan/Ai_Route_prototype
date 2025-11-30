# frozen_string_literal: true

class CreateListItems < ActiveRecord::Migration[7.2]
  def change
    create_table :list_items do |t|
      t.references :list, null: false, foreign_key: true
      t.references :spot, null: false, foreign_key: true

      t.timestamps
    end

    # 同じスポットを同じリストに重複登録しないための設定
    add_index :list_items, %i[list_id spot_id], unique: true
  end
end
