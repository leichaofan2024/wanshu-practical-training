# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "创建角色"
User.create(:role => "邯郸西场管理员", orgnize: "邯郸西场", permission: 3,password:"123456",password_confirmation:"123456")
User.create(:role => "曹妃甸站管理员", orgnize: "曹妃甸站", permission: 3,password:"123456",password_confirmation:"123456")
User.create(:role => "华润电厂站管理员", orgnize: "华润电厂站", permission: 3,password:"123456",password_confirmation:"123456")
User.create(:role => "龙城站管理员", orgnize: "龙城站", permission: 3,password:"123456",password_confirmation:"123456")
User.create(:role => "曹妃甸南站管理员", orgnize: "曹妃甸南站", permission: 3,password:"123456",password_confirmation:"123456")
User.create(:role => "首钢工业站管理员", orgnize: "首钢工业站", permission: 3,password:"123456",password_confirmation:"123456")
User.create(:role => "上行出发场管理员", orgnize: "上行出发场", permission: 3,password:"123456",password_confirmation:"123456")
User.create(:role => "上行到达场管理员", orgnize: "上行到达场", permission: 3,password:"123456",password_confirmation:"123456")
User.create(:role => "下行到达场管理员", orgnize: "下行到达场", permission: 3,password:"123456",password_confirmation:"123456")
User.create(:role => "下行直通场管理员", orgnize: "下行直通场", permission: 3,password:"123456",password_confirmation:"123456")

User.create(:role => "集团公司", orgnize: "集团公司", permission: 1,password: "123456",password_confirmation:"123456")
User.create(:role => "研发中心", orgnize: "研发中心", permission: 1,password: "yfzx",password_confirmation:"yfzx")

 puts "创建成功"
