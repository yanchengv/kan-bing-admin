#encoding:utf-8
namespace :db do
  task national: :environment do
    save_national
  end
end

def save_national
  @country = NationalInformation.create(:name => '中国')
  NationalInformation.delete_all
  datas = [ "汉族","蒙古族","满族","朝鲜族","苗族","布依族","侗族","回族","东乡族","土族","撒拉族","保安族","裕固族","维吾尔族","哈萨克族","水族","仡佬族","壮族","瑶族","仫佬族","毛南族","京族","土家族","黎族","畲族","高山族","赫哲族","达斡尔族","鄂温克族","鄂伦春族","羌族","彝族","白族","哈尼族","傣族","柯尔克孜族","锡伯族","塔吉克族","乌孜别克族","俄罗斯族","塔塔尔族","藏族","门巴族","珞巴族","僳僳族","佤族","拉祜族","纳西族","景颇族","布朗族","阿昌族","普米族","怒族","德昂族","独龙族","基诺族"  ]
  datas.each do |d|
    NationalInformation.create(:name => d, :parent_id => @country.id)
  end
end