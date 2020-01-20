class User < ApplicationRecord
  attr_accessor :remember_token

  # User モデルの中では、右の式の self を省略可能
  # 保存する直前に実行され、userオブジェクトの email をすべて小文字に変換する
  before_save { email.downcase! }

  validates :name, presence: true, length: { maximum: 50 }
  # カッコを使った validates メソッド
  # validates(:name, presence: true)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }


  class << self
  # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    # selfと付けると、remember_token というローカル変数が作成されない
    self.remember_token = User.new_token

    # update_attributeはバリデーションを素通りさせて、記憶ダイジェストを更新する
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したら true を返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄
  def forget
    update_attribute(:remember_token, nil)
  end
end
