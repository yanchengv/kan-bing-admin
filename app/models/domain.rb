class Domain < ActiveRecord::Base
  belongs_to :department
  belongs_to :hospital

  # 初次添加域名时，默认首页模板
  def init_template
    block_type=['slides','login','anlizongshu1','jianjie','anlizongshu','doctor_list','hospital_environment']
    block_name={slides:'轮播',login:'登录',anlizongshu1:'文章列表',jianjie:'科室简介',
                anlizongshu:'科室通知',doctor_list:'医生列表',hospital_environment:'医院环境'}
    block_type.each_with_index {|type,index|
      if type=='anlizongshu1'
        type='anlizongshu'
        @block_name=block_name[:anlizongshu1]
      else
        sym_type=type.to_sym
        @block_name=block_name[sym_type]
      end
       template = ActionView::Base.new(Rails.configuration.paths['app/views']).render(
           :partial => "page_blocks/templates/#{type}",
           :formats => :html,
           :handlers => :erb,
           :object =>@block_name,
           :locals => {:@block_name=>@block_name}

       )

       pra={}
       pra[:name]=@block_name
       pra[:block_type]=type
       pra[:content]= template
       pra[:hospital_id]=self.hospital_id
       pra[:position]=index
       pra[:is_show]=true
       pra[:department_id]=self.department_id
       @page_block=PageBlock.new(pra)
       @page_block.save

    }

  end
end
