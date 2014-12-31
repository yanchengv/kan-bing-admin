class Group < ActiveRecord::Base
  #has_many :groups_skills, :dependent => :destroy
  #has_many :skills, :through => :groups_skills, :source => :skill
  #has_many :doctors_groups, :dependent => :destroy
  #has_many :doctors, :dependent => :destroy
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :doctors

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
