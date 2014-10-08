#encoding:utf-8
namespace :db do
  task seed: :environment do
    make_dictionary
  end
end

def make_dictionary
  @dictionary_type1 = DictionaryType.create(
      id: 8,
      name: '民族',
      code: 'nationality'
  )
  @dictionary_type2 = DictionaryType.create(
      id: 9,
      name: '国籍',
      code: 'citizenship'
  )
  Dictionary.create(
      name: '汉族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '蒙古族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '回族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '苗族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '傣族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '僳僳族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '藏族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '壮族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '朝鲜族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '高山族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '纳西族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '布朗族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '阿昌族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '怒族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '鄂温克族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '鄂伦春族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '赫哲族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '门巴族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '白族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '保安族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '布依族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '达斡尔族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '德昂族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '东乡族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '侗族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '独龙族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '俄罗斯族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '哈尼族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '哈萨克族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '基诺族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '京族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '景颇族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '柯尔克孜族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '拉祜族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '黎族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '珞巴族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '满族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '毛南族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '仫佬族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '普米族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '羌族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '撒拉族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '畲族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '水族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '塔吉克族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '塔塔尔族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '土家族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '佤族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '维吾尔族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '乌孜别克族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '锡伯族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '瑶族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '裕固族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '彝族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '达斡尔族 ',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '土族',
      code: '',
      dictionary_type_id:@dictionary_type1.id
  )
  Dictionary.create(
      name: '中国',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '美国 ',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '英国',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '法国',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '韩国 ',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '日本',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '澳大利亚',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '新加坡',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '比利时',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '新西兰',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '泰国',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '马来西亚',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '巴基斯坦',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '俄罗斯',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '德国',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '加拿大',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '巴西',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
  Dictionary.create(
      name: '阿根廷',
      code: '',
      dictionary_type_id:@dictionary_type2.id
  )
end
