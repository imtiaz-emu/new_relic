class Student < ActiveRecord::Base
  has_many :registration, :dependent => :destroy
end
