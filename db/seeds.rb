# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "创建角色"
User.delete_all
User.create(:role => "局职教基地", orgnize: "局职教基地", permission: 1,password: "123456",password_confirmation:"123456")

User.create(:role => "北京站", orgnize: "北京站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "北京西站", orgnize: "北京西站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "北京南站", orgnize: "北京南站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "丰台西站", orgnize: "丰台西站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "南仓站", orgnize: "南仓站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "双桥站", orgnize: "双桥站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "唐山南站", orgnize: "唐山南站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "唐山站", orgnize: "唐山站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "塘沽站", orgnize: "塘沽站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "天津站", orgnize: "天津站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "天津西站", orgnize: "天津西站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "石家庄南站", orgnize: "石家庄南站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "石家庄站", orgnize: "石家庄站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "邯郸站", orgnize: "邯郸站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "阳泉站", orgnize: "阳泉站", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "北京西车务段", orgnize: "北京西车务段", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "北京车务段", orgnize: "北京车务段", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "唐山车务段", orgnize: "唐山车务段", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "天津车务段", orgnize: "天津车务段", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "张家口车务段", orgnize: "张家口车务段", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "承德车务段", orgnize: "承德车务段", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "沧州车务段", orgnize: "沧州车务段", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "秦皇岛车务段", orgnize: "秦皇岛车务段", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "衡水车务段", orgnize: "衡水车务段", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "通州车务段", orgnize: "通州车务段", permission: 2,password:"123456",password_confirmation:"123456")
User.create(:role => "邯郸车务段", orgnize: "邯郸车务段", permission: 2,password:"123456",password_confirmation:"123456")


 puts "创建成功"
