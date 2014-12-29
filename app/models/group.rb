class Group < ActiveRecord::Base

  ##group和用户关系
  #belongs_to :owner ,:class_name => "User" ,:foreign_key => :user_id
  #has_many :experts ,:through => :group_users ,:source => :doctor
  #
  ##group和医生关系
  #has_many :group_users ,dependent: :destroy
  #has_many :members, :through => :group_users, :source => :user
  #
  ##group和医疗新技术之间关系
  #has_many :skills
  #
  #
  ##group和项目之间关系
  #has_many :items

  after_create :join_owner_to_group

  def join_owner_to_group

  end
end
