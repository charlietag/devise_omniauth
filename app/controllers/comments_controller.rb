class CommentsController < ApplicationController
  # make sure user can only edit/del comments which is owned by specific user, using cancancan
  load_and_authorize_resource

  #before_action :set_comment, only: [:show, :edit, :update, :destroy]
  # because I want to redirect to @articles , so I use :destroy, even all actions under set_article, which is :set_article_comment
  before_action :set_article, only:                [:edit, :update, :destroy, :create]
  before_action :set_article_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    #@comments = Comment.all
    @comments = Comment.includes(:user, :article)
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comments = Comment.where(article_id: @article)
  end

  # GET /comments/new
  def new
    #@comment = Comment.new
    @comment = current_user.comments.build
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    #@comment = Comment.new(comment_params)
    #@comment = current_user.comments.build(comment_params)
    @comment = @article.comments.create(comment_params)
    @comment.user_id = current_user.id
    #render plain: @comment.inspect

    respond_to do |format|
      if @comment.save
        #format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        #format.html { redirect_to article_path(@article), notice: 'Comment was successfully created.' } # The following is the same as this line
        format.html { redirect_to @article, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        #format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.html { redirect_to @article, notice: 'Comment was successfully updated.' }
        #format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        #format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      #format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.html { redirect_to @article, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      # No need use friendly.find for friendly_id > 5.2
      #@article = Article.friendly.find(params[:id])
      @article = Article.find(params[:article_id])
    end

    #def set_comment
    #  @comment = Comment.find(params[:id])
    #end

    def set_article_comment
      @comment = @article.comments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :article_id, :user_id)
    end
end
