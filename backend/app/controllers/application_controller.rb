class ApplicationController < ActionController::API
  # すべてのアクションが動く前に、Originをチェックする
  before_action :check_origin

  private
  # POST / PATCH / DELETE などの書き込み通信のとき：
  # もしリクエストの Origin が "http://localhost:3000" じゃない場合、 403 Forbidden を返す
  def check_origin
    # GET / HEAD / OPTIONS などの読み取り通信はそのまま通す
    return if request.get? || request.head? || request.options?

    # 実際の値 (ブラウザが送ってくる値)を取り出す
    actual_origin = request.headers["Origin"]

    # 許可する Origin (環境に合わせて書き換える)
    allowed_origin = "http://localhost:3000"

    # もし許可されたOrignと一致しない(またはOriginがない)なら403 Forbiddenを返す
    unless actual_origin == allowed_origin
      render json: { error: "不正なリクエストです" }, status: :forbidden
    end
  end
end
