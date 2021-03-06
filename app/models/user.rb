class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save :downcase_email
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]+\z/
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
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
  has_many :clips , class_name: "Clip", foreign_key: "user_id", dependent: :destroy
  has_many :clip_messages , through: :clips, source: :message
  
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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーログインを破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # アクティベート
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  # アクティベート用メールの送信
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
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
  
   # 投稿記事をクリップする
  def clip(message)
    clips.find_or_create_by(message_id: message.id)
  end
  
  # 投稿記事のクリップを解除
  def unclip(message)
    clip = clips.find_by(message_id: message.id)
    clip.destroy if clip
  end
  
  # クリップしているかどうか？
  def clip?(message)
    clip_messages.include?(message)
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
