class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token
  before_create :create_activation_digest
  before_save :downcase_email
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :ownerships , foreign_key: "user_id" , dependent: :destroy
  has_many :items , through: :ownerships
  has_many :wants, class_name: "Want", foreign_key: "user_id", dependent: :destroy
  has_many :want_items , through: :wants, source: :item
  has_many :haves, class_name: "Have", foreign_key: "user_id", dependent: :destroy
  has_many :have_items , through: :haves, source: :item
  has_many :message_boards , foreign_key: "user_id"
  has_many :messages , foreign_key: "user_id" , dependent: :destroy
  has_many :favorites, foreign_key: "user_id", dependent: :destroy
  has_many :favorited_message_boards, through: :favorites, source: :message_board
  
  # 与えられた文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続的セッションで使用するユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーログインを破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def have(item)
    haves.find_or_create_by(item_id: item.id)
  end

  def unhave(item)
    have = haves.find_by(item_id: item.id)
    have.destroy if have
  end

  def have?(item)
    have_items.include?(item)
  end

  def want(item)
    wants.find_or_create_by(item_id: item.id)
  end

  def unwant(item)
    want = wants.find_by(item_id: item.id)
    want.destroy if want
  end

  def want?(item)
    want_items.include?(item)
  end
  
  def add_favorite(message_board)
    favorites.find_or_create_by(message_board_id: message_board.id)
  end
  
  def release_favorite(message_board)
    favorite = favorites.find_by(message_board_id: message_board.id)
    favorite.destroy if favorite
  end
  
  def favorite?(message_board)
    favorited_message_boards.include?(message_board)
  end
  
  private
  
  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  
end
