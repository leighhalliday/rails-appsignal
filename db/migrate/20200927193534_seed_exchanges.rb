class SeedExchanges < ActiveRecord::Migration[6.0]
  def up
    %w[FAKE TSX NASDAQ].each { |name| Exchange.create!(name: name) }

    add_column :companies, :exchange_id, :integer

    Exchange.all.each do |exchange|
      Company.where('exchange = ?', exchange.name).update_all(
        exchange_id: exchange.id
      )
    end

    rename_column :companies, :exchange, :exchange_name

    add_index :companies, :exchange_id
  end

  def down
    Exchange.delete_all

    remove_column :companies, :exchange_id

    rename_column :companies, :exchange_name, :exchange
  end
end
