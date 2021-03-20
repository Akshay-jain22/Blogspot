class ArticlesController < ApplicationController
  load_and_authorize_resource
  
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    private_article_credit_needed = !@article.public && !current_user.admin && @article.user_id != session[:user_id]
    if private_article_credit_needed && session[:private_articles_remaining]>0
      session[:private_articles_remaining] -= 1
    elsif private_article_credit_needed
      redirect_to root_url, alert: "Private Articles Limit Exceeded"
    else
      respond_to do |format|
        format.html
        format.pdf do
            render pdf: "Article No. #{@article.id}",
            page_size: 'A4',
            template: "articles/show.html.erb",
            layout: "pdf.html",
            orientation: "Portrait",
            zoom: 1,
            dpi: 72
        end
      end
    end
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
  
    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
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
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :topic, :tags, :content, :public, :image)
    end
end
