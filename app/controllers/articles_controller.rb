class ArticlesController < ApplicationController
  # No need use :find_by for friendly_id > 5.2
  #load_and_authorize_resource :find_by => :slug
  load_and_authorize_resource
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    #@articles = Article.all
    # Change for kaminari pagination
    @articles = Article.includes(:user).page params[:page]
    #used only once , so use flash instead. (do not use flash.now)
    #flash <--- the request after this render view
    #flash.now <--- the current render view
    #if params[:page]
    #  session[:page_num] = params[:page]
    #else
    #  session.delete(:page_num)
    #end

    flash[:page_num] = params[:page]

  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    #if using "render comment/comments" instead of "render @article.comments"
    #@comment = Comment.where(article_id: @article)

    # use this to reuse the same comments/_form
    @comment = Comment.new
  end

  # GET /articles/new
  def new
    #@article = Article.new
    @article = current_user.articles.build
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    #@article = Article.new(article_params)
    @article = current_user.articles.build(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      # No need use friendly.find for friendly_id > 5.2
      #@article = Article.friendly.find(params[:id])
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :content)
    end
end
