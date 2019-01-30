puts "创建角色"
# User.create(:role => "八里庄站管理员", orgnize: "八里庄站", permission: 3,password: "123456",password_confirmation:"123456")
# User.create(:role => "八里庄管理员", orgnize: "八里庄", permission: 3,password: "123456",password_confirmation:"123456")
puts "创建成功"

puts "删除问题车站"
TStationInfo.where(:F_uuid => ["28fd727c34da1651c3b7e4914b1e5c65","d5fb1a5a91742e0ef49b356cd3ccf646","401b6c4543e5e8d1371354e7bff84695","a960d5fd7f1709f253bd422a7982b507","f18ab372b39e8e39048896c39e059b7b","dc432f68c47532a8405987323c6e17a7"]).delete_all
puts "删除成功"

puts "删除问题班组"
TTeamInfo.where(:F_uuid =>['8b79eb1c07ebe5113c4f0cf7a566a2ca','a15ad4e520d4f06c90dded44f39a9c01','644ae4035368e343643b5b450715133d','5c5bc5fe3e04ca08addd1a7a9dd3ce2f','86d770cb7d17dd62dcc6f106c63704ba','c642845623454617e284decf175b7a21','61a4406a6c4131fbfb399c63ad8c5d95',
                           '31387b51ccd2d9ec6027b9ff804c5754','ce73c59e4af142cf48951e7253f7d17b','1f0174d1b507a6a634c597f053fc7468','21ef59f115a69a3bfcb0d9253afaad52','9933d7aeddb06f2ac11c305f8b613801','a438bd34829ab9470c6d47dcf31d3c83','1b5f2a5927f17e33a29861d75b9509ed',
                           'c24912388a62ac60b1e55bd8e5b36146','416dae5e3b4125c0731ad2122d7ec820','7a24bb4000b9d059f72db49f36eb24f9','adab6a9439b1a255b0a9290221dea76f','9b26793d6f9274b0286052b6cc1f8c59','48653e97c9176b84ee7c15c7bd24d8c7','808c671751af44678006efe969026079',
                           '55b3f32bad3fca864dcb0f00c91e56c8','99cc1938f1ffe79fe003b7aab7a272a8','953e68a75056f7a4b438626880ea2624','6a92f7aca5f7fa2879379e09525d6fdd','9c4c83b14ee70f415b516eece0eb59b2','f168eaa2bc5e6fbe1170a1bf074b9c3e','e14f78a448daa2fd4a923aeb7788d714',
                           'ffa7d336f0f0882f03ddea3dadf20c13','5659321e5f24aef2c5971359ed34c04e','c271e794540f25b06ac794e450088d96','d88eee227960d43375e8f317b89dfd11','5e63eec3e3a3ae9037200e692593e3ec','4a5bafde9fe6dba56037aeb014ffd02b','07261b1e8a4cd3fe4c04e496eb26a574',
                           'bda542f98601de246c8b16273d9a3a1e','ca9800af09e38ce7d3b27afe281eaf45','bff54af8b19ff8b7582430c0db5939a6','b7ed68a773fcd5b7ee0ae1d7a6406b85','6def3dd40625f89e9bce20c4bd4bba35','b06cf018c10618637165cbff87ce39c7','2ea3562b04ab31795c9d6a9f9d851c97']).delete_all
puts "删除成功"

puts "新增车间"
station_name_array = ['永兴线路所','曹庄子线路所','唐海南站','曹妃甸东站','南堡北站','曹妃甸港站']
station_uuid_array = ["28fd727c34da1651c3b7e4914b1e5c65","d5fb1a5a91742e0ef49b356cd3ccf646","401b6c4543e5e8d1371354e7bff84695","a960d5fd7f1709f253bd422a7982b507","f18ab372b39e8e39048896c39e059b7b","dc432f68c47532a8405987323c6e17a7"]
team_name_array = ['乙班','教师班组','替班','丁班','培训班组','甲班','丙班']
team_uuid_array = ['8b79eb1c07ebe5113c4f0cf7a566a2ca','a15ad4e520d4f06c90dded44f39a9c01','644ae4035368e343643b5b450715133d','5c5bc5fe3e04ca08addd1a7a9dd3ce2f','86d770cb7d17dd62dcc6f106c63704ba','c642845623454617e284decf175b7a21','61a4406a6c4131fbfb399c63ad8c5d95',
                   '31387b51ccd2d9ec6027b9ff804c5754','ce73c59e4af142cf48951e7253f7d17b','1f0174d1b507a6a634c597f053fc7468','21ef59f115a69a3bfcb0d9253afaad52','9933d7aeddb06f2ac11c305f8b613801','a438bd34829ab9470c6d47dcf31d3c83','1b5f2a5927f17e33a29861d75b9509ed',
                   'c24912388a62ac60b1e55bd8e5b36146','416dae5e3b4125c0731ad2122d7ec820','7a24bb4000b9d059f72db49f36eb24f9','adab6a9439b1a255b0a9290221dea76f','9b26793d6f9274b0286052b6cc1f8c59','48653e97c9176b84ee7c15c7bd24d8c7','808c671751af44678006efe969026079',
                   '55b3f32bad3fca864dcb0f00c91e56c8','99cc1938f1ffe79fe003b7aab7a272a8','953e68a75056f7a4b438626880ea2624','6a92f7aca5f7fa2879379e09525d6fdd','9c4c83b14ee70f415b516eece0eb59b2','f168eaa2bc5e6fbe1170a1bf074b9c3e','e14f78a448daa2fd4a923aeb7788d714',
                   'ffa7d336f0f0882f03ddea3dadf20c13','5659321e5f24aef2c5971359ed34c04e','c271e794540f25b06ac794e450088d96','d88eee227960d43375e8f317b89dfd11','5e63eec3e3a3ae9037200e692593e3ec','4a5bafde9fe6dba56037aeb014ffd02b','07261b1e8a4cd3fe4c04e496eb26a574',
                   'bda542f98601de246c8b16273d9a3a1e','ca9800af09e38ce7d3b27afe281eaf45','bff54af8b19ff8b7582430c0db5939a6','b7ed68a773fcd5b7ee0ae1d7a6406b85','6def3dd40625f89e9bce20c4bd4bba35','b06cf018c10618637165cbff87ce39c7','2ea3562b04ab31795c9d6a9f9d851c97']
(0..5).each do |n|
  TStationInfo.create(:F_uuid => station_uuid_array[n],:F_name => station_name_array[n],:F_duan_uuid => "72cee766145a11e6ad9d001ec9b3cd0c",:F_level => "2",:LEVEL => "2",:status => "在线")
  User.create(:role => (station_name_array[n]+"管理员"), orgnize: station_name_array[n], permission: 3,password: "123456",password_confirmation:"123456")
end 
puts "新增车间成功"


puts "新增班组"
(0..5).each do |m|
  (0..6).each do |n| 
    TTeamInfo.create(:F_uuid => team_uuid_array[m*7+n],:F_name => team_name_array[n],:F_station_uuid => station_uuid_array[m])
  end 
end 
puts "新增班组成功"

