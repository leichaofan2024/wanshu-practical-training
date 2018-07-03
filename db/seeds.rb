puts "创建角色"
User.create(:role => "八里庄站管理员", orgnize: "八里庄站", permission: 3,password: "123456",password_confirmation:"123456")
User.create(:role => "八里庄管理员", orgnize: "八里庄", permission: 3,password: "123456",password_confirmation:"123456")
puts "创建成功"
