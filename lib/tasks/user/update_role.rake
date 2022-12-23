namespace :user do
    desc 'Assigns role as admin for email provided'
    task :make_admin, [:email] => [:environment] do |t, args|
      if user = User.find_by(email: args[:email])
        user.update!(role: 'admin')
        puts "User with #{args[:email]} has been assigned as admin."
      else
        puts "No such user with email #{args[:email]} exists."
      end
    end
  end
