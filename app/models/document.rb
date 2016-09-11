class Document < ApplicationRecord
  belongs_to :folder
  has_one :privacy, as: :shareable, :dependent => :destroy
  enum extension: [ :txt, :md ]
  has_many :notifications, :dependent => :destroy, :foreign_key => 'document_id'


  def user
  	return self.folder.user
  end
end
