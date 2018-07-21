class Api::CommentsController < Api::ApiController
  def create
    comment = current_user.comments.build(comment_params_on_create)
    comment.save!
    render json: comment, status: :created
  end

  def update
    editable_comment.update!(comment_params)
    render json: editable_comment, status: :ok
  end

  def destroy
    editable_comment.destroy!
    render json: { head: :ok }
  end

  private

  def comment_params_on_create
    params.require(:comment).permit(:post_id, :body)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def editable_comment
    comment = Comment.find(params[:id])
    raise Forbidden unless current_user == comment.user

    comment
  end
end
