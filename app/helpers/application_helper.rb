module ApplicationHelper

  # module に記述すされたメソッドを使うには include メソッドでモジュールを読み込む
  # 必要があるが、Rails では自動でヘルパーモジュールを読み込んでくれるので
  # include が必要なく、自動的にすべてのビューで利用できる。

  # ページごとの完全なタイトルを返す
  def full_title(page_title = '') # 引数が渡されない場合、デフォルトの空文字が代入される
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
