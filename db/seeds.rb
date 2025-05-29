# Seed example users in auth.users
client = Supabase::Client.new
client.from('auth.users').insert([
  { email: 'admin@example.com', role: 'admin', confirmed_at: Time.now },
  { email: 'user@example.com', role: 'user', confirmed_at: Time.now }
])

# Seed example stores in store_management.stores
ActiveRecord::Base.connection.execute(<<-SQL)
  INSERT INTO store_management.stores (store_id, store_name, created_at, updated_at)
  VALUES
    (gen_random_uuid(), 'Main Store', NOW(), NOW()),
    (gen_random_uuid(), 'Branch Store', NOW(), NOW());
SQL