require 'sequel'

Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      foreign_key :group_id
      foreign_key :city_id
      String :event_name
      String :url
      String :origin
      String :status
      Float :lat
      Float :lon
      String :venue
      String :topic
      DateTime :time
    end
  end
end
