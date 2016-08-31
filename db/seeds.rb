# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
unless System::Account.any?
  role_admin = System::Role.find_or_initialize_by(name: "admin")

  if role_admin.new_record?
    permission = System::Permission.new
    permission.link = role_admin
    permission.function_id = 0
    permission.subsystem_id = 0
    permission.status = 1
    permission.operates = [0, 1, 2, 3]
    permission.save
    role_admin.save!
  end

  account_admin = System::Account.find_or_initialize_by(name: "evanchiu")
  account_admin.password = "password" if account_admin.new_record?
  account_admin.status = 1
  account_admin.roles = [role_admin]
  account_admin.save!

end


# Fix the sum tag name.
[ Seed::ActivitySituationReport,
  Seed::ActivityTotalReport,
  Seed::ActivationReport,
  Seed::ActivityReport,
  Seed::AliveReport,
  Seed::SolutionReport,
  Seed::PropReport,
  Seed::PropDetailReport,
  Seed::DeviceDetailReport,
  Seed::PropDetailMonthlyReport,
  Ework::ConversionReport,
  Ework::ArrivalReport
].each do |clazz|
  clazz.where({:tag => '全部'}).update_all(:tag => System::TagGroup::TOTAL_SUM_TAG)
end
