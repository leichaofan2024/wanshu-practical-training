puts "创建角色"
User.create(:role => "研发中心", orgnize: "研发中心", permission: 1,password: "yfzx",password_confirmation:"yfzx")
puts "创建成功"
