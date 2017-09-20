# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "创建角色"
 User.create(:role => "局职教基地", orgnize: "局职教基地", permission: 1,password: "123456",password_confirmation:"123456")

 User.create(:role => "北京站", orgnize: "北京站", permission: 2,password:"123456",password_confirmation:"123456")

 puts "创建成功"
