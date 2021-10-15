Hanami::Model.migration do
  change do
    create_table :entries do
      primary_key :id

      column :date, Date, null: false, unique: true
      column :title, String, null: true
      column :body, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
