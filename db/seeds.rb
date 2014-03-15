# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Spree::Core::Engine.load_seed if defined?(Spree::Core) if Spree::Zone.count == 0
# Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

if Spree::User.admin.empty?
  password = 'abc123'
  email = 'ashramsey@gmail.com'

  attributes = {
    :password => password,
    :password_confirmation => password,
    :email => email,
    :login => email
  }

  # load 'spree/user.rb'

  if Spree::User.find_by_email(email)
    say "\nWARNING: There is already a user with the email: #{email}, so no account changes were made.  If you wish to create an additional admin user, please run rake spree_auth:admin:create again with a different email.\n\n"
  else
    admin = Spree::User.new(attributes)
    if admin.save
      role = Spree::Role.find_or_create_by(name: 'admin')
      admin.spree_roles << role
      admin.save
    else
      say "There was some problems with persisting new admin user:"
      admin.errors.full_messages.each do |error|
        puts error
      end
    end
  end
end